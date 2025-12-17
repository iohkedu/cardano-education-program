# Script context explained

In this lesson, we will examine the <span style="color: purple;">ScriptContext</span> data type in more detail.
All data types contained in the script context will be presented as Haskell data types.
Let us recall the implementation of the script context data type.

```haskell
data ScriptContext = ScriptContext
  { scriptContextTxInfo     :: TxInfo
  , scriptContextRedeemer   :: V2.Redeemer
  , scriptContextScriptInfo :: ScriptInfo
  }
  deriving stock (Generic, Haskell.Eq, Haskell.Show)
  deriving anyclass (HasBlueprintDefinition)
```

It contains transaction information, the redeemer, and script information.
To reiterate: if a transaction attempts to spend multiple UTXOs at a script address, the spending
script is executed separately for each UTXO. The redeemer and script information
are assigned individually to each UTXO, whereas the transaction information
is shared across all scripts triggered by that transaction.

In the code examples from the previous lesson, the validation logic did not use
the transaction and script information. However, in most validator scripts, they are
used. First, we look at the script information data type.

## Script information

The <span style="color: purple;">ScriptInfo</span> data type is defined as:

```haskell
data ScriptInfo
  = MintingScript V2.CurrencySymbol
  | SpendingScript V3.TxOutRef (Haskell.Maybe V2.Datum)
  | RewardingScript V2.Credential
  | CertifyingScript
      Haskell.Integer
      TxCert
  | VotingScript Voter
  | ProposingScript
      Haskell.Integer
      ProposalProcedure
  deriving stock (Generic, Haskell.Show, Haskell.Eq)
  deriving anyclass (HasBlueprintDefinition)
  deriving (Pretty) via (PrettyShow ScriptInfo)
```

The script information contains information about the
script's purpose. If a transaction tries to mint a native asset, the script info
contains the <span style="color: purple;">MintingScript</span> data constructor that carries the
<span style="color: purple;">CurrencySymbol</span> data type.

```haskell
newtype CurrencySymbol = CurrencySymbol {unCurrencySymbol :: PlutusTx.BuiltinByteString}
  deriving stock (Generic, Data)
  deriving anyclass (NFData, HasBlueprintDefinition)
  deriving newtype (Haskell.Eq, Haskell.Ord, Eq, Ord,
                    PlutusTx.ToData, PlutusTx.FromData,
                    PlutusTx.UnsafeFromData)
  deriving (Haskell.Show, Pretty)
    via LedgerBytes
```

The currency symbol data type is wrapped around a <span style="color: purple;">BuiltinByteString</span>,
which represents the hash of the minting policy that gets
triggered when minting a native asset. We will talk more about native assets
and minting in lesson _Minting policies and native tokens_.

If a transaction tries to spend a UTXO at a script address, the script
info contains the <span style="color: purple;">SpendingScript</span> data constructor that carries
a transaction output reference <span style="color: purple;">TxOutRef</span> and a <span style="color: purple;">Maybe V2.Datum</span>.

```haskell
data TxOutRef = TxOutRef
  { txOutRefId  :: TxId
  , txOutRefIdx :: Integer
  }
  deriving stock (Show, Eq, Ord, Generic)
  deriving anyclass (NFData, HasBlueprintDefinition)
```

The transaction output reference contains the transaction ID,
which is a SHA-256 hash of the transaction, and the transaction index, which is an integer number.
Each UTXO that a transaction creates gets a transaction index assigned starting with
zero and increasing by one. Because a transaction hash (ID) is unique,
together with the output index it uniquely defines a UTXO.
The reason transaction hashes are unique is because a new transaction hash includes
the hash of the transaction that created the UTXO being consumed. Every transaction consumes
at least one UTXO as it needs to pay some fees. By a simple inductive
argument, it follows that two identical transaction hashes can never exist.
We also rely on the fact that the probability of a hash collision is negligible.

The <span style="color: purple;">TxId</span> data type that represents an SHA-256 hash
of the transaction is a wrapper around a <span style="color: purple;">BuiltinByteString</span>.

```haskell
newtype TxId = TxId {getTxId :: PlutusTx.BuiltinByteString}
  deriving stock (Eq, Ord, Generic)
  deriving anyclass (NFData, HasBlueprintDefinition)
  deriving newtype (PlutusTx.Eq, PlutusTx.Ord, ToData, FromData, UnsafeFromData)
  deriving (IsString, Show, Pretty)
    via LedgerBytes
```

For PlutusV3 scripts, a datum is no longer necessary to be attached to a UTXO
when creating it at a script address, as was the case for PlutusV2 scripts.
For this reason, the script info for a spending script contains a <span style="color: purple;">Maybe Datum</span> type. 

```haskell
newtype Datum = Datum {getDatum :: BuiltinData}
  deriving stock (Generic, Typeable, Haskell.Show)
  deriving newtype (Haskell.Eq, Haskell.Ord, Eq, ToData, FromData,
                    UnsafeFromData, Pretty)
  deriving anyclass (NFData, HasBlueprintDefinition)
```

The <span style="color: purple;">Datum</span> type is the same as the <span style="color: purple;">Redeemer</span> type, a wrapper
around the <span style="color: purple;">BuiltinData</span> type. The datum allows information to be
attached to a UTXO that can then be accessed within the validation script
logic. We note that the redeemer is defined when we construct a spending
transaction that consumes one or more UTXOs at a script address, and the
datum is defined when we construct a producing transaction that creates
one or more UTXOs at a script address. We will see examples of how to
construct producing and spending transactions in lesson
_Off-chain code with MeshJS_.

The third option for script purposes is rewarding, which is used to
withdraw staking rewards. The rewarding constructor carries the
<span style="color: purple;">Credential</span> data type.

```haskell
data Credential =
    PubKeyCredential PubKeyHash
  | ScriptCredential ScriptHash
    deriving stock (Eq, Ord, Show, Generic, Typeable)
    deriving anyclass (NFData, HasBlueprintDefinition)
```

This data type either contains a public key hash or a script hash. In
the case of a public key hash, the owner of the private key corresponding
to the public key needs to sign the transaction to be able to spend the
staking rewards. In the case of a script hash, the transaction must include
or reference the validation script that will be used to decide whether
the transaction can withdraw the staking rewards.

Both the <span style="color: purple;">PubKeyHash</span> and <span style="color: purple;">ScriptHash</span> data types are wrappers
around the <span style="color: purple;">BuiltinByteString</span> data type.

Other possibilities for the <span style="color: purple;">ScriptInfo</span> data type cover the
following script purposes:

* Certifying - for issuing certificates
* Voting and proposing - used when government actions are involved.

In the code examples presenten in the Plinth module, we will focus on
the spending and minting script purposes.

## Decoding the script information in untyped form

Before moving on to explaining the transaction information data type, we look
at another validator example that shows how to decode the <span style="color: purple;">ScriptInfo</span>
data type in untyped form. Our validator follows the same logic as the 42
validator in the previous lesson, except that we now match the number 42
to the value of the datum instead of the redeemer.

```haskell
{- ------------------------------------------------------------------------------ -}
{- ------------------------- Datum 42 validator untyped ------------------------- -}

{-# INLINEABLE datum42Validator #-}
datum42Validator :: BuiltinData -> BuiltinUnit
datum42Validator ctx
    | datumInt == 42 = BI.unitval
    | otherwise      = traceError "Datum is a number different than 42"
 where
    -- Lazily decode script context up to datum
    constrArgs :: BuiltinData -> BI.BuiltinList BuiltinData
    constrArgs = BI.snd . BI.unsafeDataAsConstr

    scriptInfoBD :: BuiltinData
    scriptInfoBD = BI.head . BI.tail . BI.tail $ constrArgs ctx

    maybeDatumBD :: BuiltinData
    maybeDatumBD = BI.head . BI.tail $ constrArgs scriptInfoBD

    datumBD :: BuiltinData
    datumBD = BI.head $ constrArgs maybeDatumBD

    datumInt :: BI.BuiltinInteger
    datumInt = unsafeDataAsI datumBD

compiledDatum42Validator :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledDatum42Validator = $$(compile [||datum42Validator||])

serializedDatum42Validator :: SerialisedScript
serializedDatum42Validator = serialiseCompiledCode compiledDatum42Validator
```

As we explained in the previous lesson, we need to define the
<span style="color: blue;">constrArgs</span> helper function that helps us to convert the <span style="color: purple;">BuiltinData</span>
to the <span style="color: purple;">BuiltinList</span> type. The script information
is contained in the third place in the script context. To extract an element from
the third place in the list, we can apply two times the <span style="color: blue;">tail</span> function
and one time the <span style="color: blue;">head</span> function.

Since we are working with a spending script, the script info contains the spending
constructor followed by the transaction output reference and the <span style="color: purple;">Maybe Datum</span>
type. We use once the <span style="color: blue;">tail</span> function and the <span style="color: blue;">head</span> function to extract it.
Because we now have something of type <span style="color: purple;">Maybe V2.Datum</span>, we cannot directly convert
it to an integer. We again use the <span style="color: blue;">constrArgs</span> function and then only once
the <span style="color: blue;">head</span> function since there should be only one element in the list - the datum.
After that we have the datum in untyped form, and we can apply the
<span style="color: blue;">unsafeDataAsI</span> function to convert it to an integer number.

If the datum was not attached to the UTXO, or the datum has a different format,
this validator will fail without a used-defined error message. If we do manage to
extract an integer, the validator will pass if it is 42 or fail with a user-defined
message. We note also in this example that if the datum is a more structured
data type, we could use the <span style="color: blue;">fromBuiltinData</span> function that would convert it
to typed form, enabling simpler extraction of information.

We state the various possibilities that a datum can be used for in smart contracts:

* Indicating who can consume a UTXO, when, and under what conditions
* Representing the current state of the UTXO
* Defining metadata and/or configurations.

## Transaction information

Let us look at the transaction information <span style="color: purple;">TxInfo</span> data type.

```haskell
data TxInfo = TxInfo
  { txInfoInputs                :: [TxInInfo]
  , txInfoReferenceInputs       :: [TxInInfo]
  , txInfoOutputs               :: [V2.TxOut]
  , txInfoFee                   :: V2.Lovelace
  , txInfoMint                  :: V3.MintValue
  , txInfoTxCerts               :: [TxCert]
  , txInfoWdrl                  :: Map V2.Credential V2.Lovelace
  , txInfoValidRange            :: V2.POSIXTimeRange
  , txInfoSignatories           :: [V2.PubKeyHash]
  , txInfoRedeemers             :: Map ScriptPurpose V2.Redeemer
  , txInfoData                  :: Map V2.DatumHash V2.Datum
  , txInfoId                    :: V3.TxId
  , txInfoVotes                 :: Map Voter (Map GovernanceActionId Vote)
  , txInfoProposalProcedures    :: [ProposalProcedure]
  , txInfoCurrentTreasuryAmount :: Haskell.Maybe V2.Lovelace
  , txInfoTreasuryDonation      :: Haskell.Maybe V2.Lovelace
  }
  deriving stock (Generic, Haskell.Show, Haskell.Eq)
  deriving anyclass (HasBlueprintDefinition)
```

It contains several fields that carry information about the transaction
being validated. In the beginning, it contains a list of transaction inputs
and reference inputs. Reference inputs are inputs accessible by the script
context but not consumed by the transaction. They are only referenced, hence
the name. A transaction may need access to a UTXO without consuming it
because the UTXO's datum can contain important information that
scripts can access. This information can be arbitrary data contained in
the datum or an attached reference script, which is a serialized smart
contract compiled to Plutus. The advantage of reference scripts is that
instead of appending a script to a transaction that wants to spend funds
at the script address, we simply reference this script from the UTXO
that carries it. This lowers the transaction size and reduces the
transaction cost. A code example of this is presented in lesson
_Off-chain code with MeshJS_. Another advantage of reference inputs is
that several transactions in the same block can use the same UTXO as a
reference input, since it is not being consumed by any of those transactions.
Transaction inputs and reference inputs are lists of type transaction input
info <span style="color: purple;">TxInInfo</span> that defines the input of a pending transaction.

```haskell
data TxInInfo = TxInInfo
  { txInInfoOutRef   :: V3.TxOutRef
  , txInInfoResolved :: V2.TxOut
  }
  deriving stock (Generic, Haskell.Show, Haskell.Eq)
  deriving anyclass (HasBlueprintDefinition)
```

The transaction input information contains a transaction output reference
that we previously explained. It defines the input UTXO and
contains resolved transaction input information
in the form of the transaction output <span style="color: purple;">TxOut</span> data type.

```haskell
data TxOut = TxOut
  { txOutAddress         :: Address
  , txOutValue           :: Value
  , txOutDatum           :: OutputDatum
  , txOutReferenceScript :: Maybe ScriptHash
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass (NFData, HasBlueprintDefinition)
```

A transaction output of a UTXO contains the address where this UTXO resides,
the value it contains, the output datum, and possibly a script hash.
We look first at the <span style="color: purple;">Address</span> type.

```haskell
data Address = Address
  { addressCredential        :: Credential
  , addressStakingCredential :: Maybe StakingCredential
  }
  deriving stock (Eq, Ord, Show, Generic, Typeable)
  deriving anyclass (NFData, HasBlueprintDefinition)
```

A Cardano address has two parts: the payment part and an optional staking part.
The payment part, defined with the <span style="color: purple;">Credential</span> data type, contains either
a public key hash or a script hash, as we explained when discussing rewarding
in the **Script information** section of this lesson.

The optional staking part is defined with the <span style="color: purple;">StakingCredential</span>
data type that can be either a staking hash or a staking pointer.

```haskell
data StakingCredential =
      StakingHash Credential
    | StakingPtr
        Integer -- ^ the slot number
        Integer -- ^ the transaction index (within the block)
        Integer -- ^ the certificate index (within the transaction)
    deriving stock (Eq, Ord, Show, Generic, Typeable)
    deriving anyclass (NFData, HasBlueprintDefinition)
```

The second piece of information contained in a transaction output is the
<span style="color: purple;">Value</span> type that defines an amount of ada and/or native tokens.

```haskell
newtype Value = Value { getValue :: Map CurrencySymbol (Map TokenName Integer) }
    deriving stock (Generic, Data, Typeable, Haskell.Show)
    deriving anyclass (NFData)
    deriving newtype (PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData)
    deriving Pretty via (PrettyShow Value)
```

Every native token is defined with a currency symbol and a token name. They are
both wrappers around a <span style="color: purple;">BuiltinByteString</span>. The currency symbol is computed
as the hash of the minting policy, and the token name can be an arbitrary string
(but should not be longer than 32 bytes). The `ada` token is defined by an empty
byte string both for currency symbol and token name, which means one cannot mint ada.

The third part of a transaction output is the <span style="color: purple;">OutputDatum</span> data type.

```haskell
data OutputDatum
    = NoOutputDatum
    | OutputDatumHash DatumHash
    | OutputDatum Datum
  deriving stock (Show, Eq, Generic)
  deriving anyclass (NFData, HasBlueprintDefinition)
```

A UTXO can either contain no datum, a datum hash, or a datum. A datum hash
contains a string of type <span style="color: purple;">BuiltinByteString</span> and the datum type is a
wrapper around the <span style="color: purple;">BuiltinData</span> type - just like the <span style="color: purple;">Redeemer</span> type.

The last data for the <span style="color: purple;">TxOut</span> data type defines a <span style="color: purple;">Maybe ScriptHash</span>.
A script hash is also a wrapper around a <span style="color: purple;">BuiltinByteString</span>.

Next in the <span style="color: purple;">TxInfo</span> data type are the transaction outputs that the
transaction aims to create. A transaction output is defined with the <span style="color: purple;">TxOut</span>
data type that we have already shown. After that comes the data for fees and
minting. Fees are defined with the <span style="color: purple;">Lovelace</span> data type that is a
wrapper around an <span style="color: purple;">Integer</span> type.

```haskell
newtype Lovelace = Lovelace { getLovelace :: Integer }
  deriving stock (Generic, Typeable)
  deriving (Pretty) via (PrettyShow Lovelace)
  deriving anyclass (HasBlueprintDefinition)
  deriving newtype (Haskell.Eq, Haskell.Ord, Haskell.Show, Haskell.Num,
                    Haskell.Real, Haskell.Enum, PlutusTx.Eq, PlutusTx.Ord,
                    PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData,
                    PlutusTx.AdditiveSemigroup, PlutusTx.AdditiveMonoid,
                    PlutusTx.AdditiveGroup, PlutusTx.Show)
```

Minting is defined with the <span style="color: purple;">MintValue</span> type structured the same
as the <span style="color: purple;">Value</span> type.

```haskell
newtype MintValue = UnsafeMintValue (Map CurrencySymbol (Map TokenName Integer))
  deriving stock (Generic, Data, Typeable, Haskell.Show)
  deriving anyclass (NFData)
  deriving newtype (ToData, FromData, UnsafeFromData)
  deriving (Pretty) via (PrettyShow MintValue)
```

Following fees and minting is the data that handles certificates, which is defined
by a list of the <span style="color: purple;">TxCert</span> data type.

```haskell
data TxCert =
    TxCertRegStaking V2.Credential (Haskell.Maybe V2.Lovelace)
  | TxCertUnRegStaking V2.Credential (Haskell.Maybe V2.Lovelace)
  | TxCertDelegStaking V2.Credential Delegatee
  | TxCertRegDeleg V2.Credential Delegatee V2.Lovelace
  | TxCertRegDRep DRepCredential V2.Lovelace
  | TxCertUpdateDRep DRepCredential
  | TxCertUnRegDRep DRepCredential V2.Lovelace
  | TxCertPoolRegister
      -- | poolId
      V2.PubKeyHash
      -- | pool VFR
      V2.PubKeyHash
  | TxCertPoolRetire V2.PubKeyHash Haskell.Integer
  | TxCertAuthHotCommittee ColdCommitteeCredential HotCommitteeCredential
  | TxCertResignColdCommittee ColdCommitteeCredential
  deriving stock (Generic, Haskell.Show, Haskell.Eq, Haskell.Ord)
  deriving anyclass (HasBlueprintDefinition)
  deriving (Pretty) via (PrettyShow TxCert)
```

The <span style="color: purple;">TxCert</span> data type has 11 constructors representing the
following certificates:

1. Register staking credential with an optional deposit amount
2. Unregister staking credential with an optional refund amount
3. Delegate staking credential to a delegatee
4. Register and delegate staking credential to a delegatee in one certificate
  (deposit is mandatory)
5. Register a DRep with a deposit value
6. Update a DRep
7. Unregister a DRep with mandatory refund value
8. A digest of the PoolParams
9. The retirement certificate and the epoch when the retirement will take place
10. Authorize a Hot credential for a specific committee member's cold credential
11. Resign committee member's cold credential.

After certificates comes the data that manages withdrawals of staking rewards.
The data is contained in a <span style="color: purple;">Map</span> of credentials to lovelace. Next follows
the transaction validity range, which is defined with the <span style="color: purple;">POSIXTimeRange</span>
data type.

```haskell
type POSIXTimeRange = Interval POSIXTime

data Interval a = Interval { ivFrom :: LowerBound a, ivTo :: UpperBound a }
    deriving stock (Haskell.Show, Generic)
    deriving anyclass (NFData)
```

The <span style="color: purple;">POSIXTimeRange</span> data type contains an <span style="color: purple;">Interval</span> type,
parameterized with the <span style="color: purple;">POSIXTime</span> type. The <span style="color: purple;">Interval</span> type
holds data about the lower and upper bounds of the validity interval for the
specified transaction. The lower and upper bound types are structured in the
same way. They hold the <span style="color: purple;">Extended</span> and <span style="color: purple;">Closure</span> types.

```haskell
data LowerBound a = LowerBound (Extended a) Closure
    deriving stock (Haskell.Show, Generic)
    deriving anyclass (NFData)
```

The <span style="color: purple;">Closure</span> type is just a wrapper for a Boolean that indicates
whether the boundary is included in the interval or not. The extended type
has three possible constructor values, which represent negative infinity,
positive infinity, or a finite bound parameterized, in our case, by a
<span style="color: purple;">POSIXTime</span> type.

```haskell
newtype POSIXTime = POSIXTime {getPOSIXTime :: Integer}
  deriving stock (Haskell.Eq, Haskell.Ord, Haskell.Show, Generic, Typeable)
  deriving anyclass (NFData, HasBlueprintDefinition)
  deriving newtype (AdditiveSemigroup, AdditiveMonoid, AdditiveGroup, Eq,
                    Ord, Enum, PlutusTx.ToData, PlutusTx.FromData,
                    PlutusTx.UnsafeFromData, Haskell.Num, Haskell.Enum,
                    Haskell.Real, Haskell.Integral)
```

<span style="color: purple;">POSIXTime</span> is a wrapper for an integer, representing the number of
milliseconds that have passed since 1 January, 1970, at 00:00.

The module `PlutusLedgerApi.V1.Interval` defines the following helper functions
that work with time intervals:

* <span style="color: blue;">member</span>: checks whether a value is in an interval
* <span style="color: blue;">interval</span>: takes two parameters as input and constructs an interval
with included boundaries
* <span style="color: blue;">from</span>: takes a value and returns an interval that includes all values
greater than or equal to the given value
* <span style="color: blue;">to</span>: takes a value and returns an interval that includes all values
smaller than or equal to the given value
* <span style="color: blue;">always</span>: an interval that covers every possible time
* <span style="color: blue;">never</span>: an empty interval
* <span style="color: blue;">singleton</span>: takes a value and returns an interval that only contains
the single value
* <span style="color: blue;">hull</span>: takes two intervals as input and returns the smallest interval
containing both intervals
* <span style="color: blue;">intersection</span>: takes two intervals as input and returns the largest
interval contained in both of the intervals, if it exists
* <span style="color: blue;">overlap</span>: checks whether two intervals have a value in common and
returns a Boolean
* <span style="color: blue;">contains</span>: checks whether the second interval is contained in the
first one, and returns a Boolean
* <span style="color: blue;">isEmpty</span>: checks whether an interval is empty and returns a Boolean
* <span style="color: blue;">before</span>: checks whether a given time is before the given interval and
returns a Boolean
* <span style="color: blue;">after</span>: checks whether a given time is after the given interval and
returns a Boolean.

Following the validity range in the <span style="color: purple;">TxInfo</span> data type is the list
of public key hashes that represent transaction signatories. We note again
that the <span style="color: purple;">PubKeyHash</span> data type is a wrapper around the
<span style="color: purple;">BuiltinByteString</span> data type.

Next are the redeemers and datums. As stated before, a transaction can spend
multiple UTXOs that get individual redeemers assigned. If any of these
UTXOs have only a datum hash attached, the transaction also needs to contain
the datums that belong to those hashes. Data for both redeemers and datums is
packaged inside a <span style="color: purple;">Map</span> object. The keys for the redeemer data are
of type <span style="color: purple;">ScriptPurpose</span>.

```haskell
data ScriptPurpose
  = Minting V2.CurrencySymbol
  | Spending V3.TxOutRef
  | Rewarding V2.Credential
  | Certifying
      Haskell.Integer
      TxCert
  | Voting Voter
  | Proposing
      Haskell.Integer
      ProposalProcedure
  deriving stock (Generic, Haskell.Show, Haskell.Eq, Haskell.Ord)
  deriving anyclass (HasBlueprintDefinition)
  deriving (Pretty) via (PrettyShow ScriptPurpose)
```

The <span style="color: purple;">ScriptPurpose</span> data type is structured in the same way as the
<span style="color: purple;">ScriptInfo</span> data type, except the constructor names are different
and the `Spending` constructor holds only a transaction output reference,
without the <span style="color: purple;">Maybe Datum</span> type. The keys for the datums are datum
hashes that map to actual datums.

Next comes the transaction ID of type <span style="color: purple;">TxId</span>, which represents the
hash of the transaction being validated. As already stated, this type is a
wrapper around the <span style="color: purple;">BuiltinByteString</span> data type.

Then are the votes and proposal procedures used when
dealing with government actions. The last two pieces of data contained in
the transaction information are the current treasury amount and treasury
donation. Both are of type <span style="color: purple;">Maybe V2.Lovelace</span>. Learn more about
governance features, including the topics of voting and proposal submission,
in the [Cardano governance](https://github.com/input-output-hk/mastering-cardano/blob/main/chapters/chapter-05-governance.adoc) chapter of Mastering Cardano.
