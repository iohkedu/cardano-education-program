# Minting policies and native tokens

In Plutus, a minting policy or minting script defines the
conditions under which native tokens can be minted. Each UTXO has an
address, a value, and potentially a datum. In previous examples, the
value was always ada. To include native tokens in a UTXO, they must be
explicitly created. The
[IO blog on native tokens](https://iohk.io/en/blog/posts/2025/05/09/native-tokens-in-the-extended-utxo-model/)
states that on many blockchains, creating custom tokens
traditionally requires writing and deploying smart contracts – code that
defines how the token behaves and how it can be transferred, created (minted),
or destroyed (burned). This approach makes these user-defined tokens
non-native, meaning the underlying blockchain’s fundamental structure
does not directly support them, – which can lead to inefficiencies, higher
costs, and increased complexity. In Cardano, all tokens are native, which
means developers can create and manage their own tokens without relying
on complex smart contracts. These tokens are treated as first-class
citizens by the ledger, enabling secure and efficient handling of many
token types directly at the protocol level. The blog further states
that the key advantages of native tokens in Cardano over traditional
smart contract-based approaches are:

* Efficiency and lower costs. Because native tokens are supported at the
ledger level, their creation, transfer, and management require no custom
contract logic. This reduces transaction size, increases throughput, and
significantly lowers fees. Operations are faster and consume fewer resources
compared to tokens built with smart contracts.
* Security and simplicity. Native tokens inherit the same security properties
as ada. There is no additional contract logic to audit or maintain, reducing
the risk of vulnerabilities and exploits. This makes native tokens simpler
and safer to use in DApps.
* Developer experience and compatibility. Creating and managing native tokens
is more straightforward than writing and deploying custom contracts. Native
tokens integrate seamlessly with wallets, tools, and the wider ecosystem.

One can read more about the security advantages of native tokens on Cardano
in the Mastering Cardano section
[Cardano security](https://github.com/input-output-hk/mastering-cardano/blob/main/chapters/chapter-08-writing-smart-contracts-plutusv3.adoc#cardano-security).
Before looking at an example of a minting
policy, let us look again at the Haskell definition of the <span style="color: purple;">Value</span> type.
This type is defined in the module `PlutusLedgerApi.V1.Value` and defines an
amount of ada and/or native tokens.

```haskell
newtype Value = Value { getValue :: Map CurrencySymbol (Map TokenName Integer) }
    deriving stock (Generic, Data, Typeable, Haskell.Show)
    deriving anyclass (NFData)
    deriving newtype (PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData)
    deriving Pretty via (PrettyShow Value)
```

The Value type is a map object that connects a currency symbol to
another map, which uses token names as its keys. Both token names and
currency symbols are wrappers for the type <span style="color: purple;">BuiltinByteString</span>,
representing a byte string. As said before, the currency symbol represents
the hash of the minting policy and the `ada` token is defined by an empty
byte string both for currency symbol and token name, which means one
cannot mint ada. These two byte strings define a native token
or coin, while the integer represents the token’s amount. Additionally,
there is another type called <span style="color: purple;">AssetClass</span>.

```haskell
newtype AssetClass = AssetClass
    { unAssetClass :: (CurrencySymbol, TokenName)
    }
    deriving stock (Generic, Data, Typeable)
    deriving newtype
      ( Haskell.Eq
      , Haskell.Ord
      , Haskell.Show
      , Eq
      , Ord
      , PlutusTx.ToData
      , PlutusTx.FromData
      , PlutusTx.UnsafeFromData
      )
    deriving anyclass (NFData, HasBlueprintDefinition)
    deriving (Pretty) via (PrettyShow (CurrencySymbol, TokenName))
```

It combines the currency symbol and token name to define an asset class,
which can represent a native token or ada. Because the value type is a map,
it can contain different tokens and amounts, including ada. To construct a
value, we can use the function <span style="color: blue;">assetClass</span>, which takes a currency
symbol and token name, and returns a variable of type asset class. We can
then use the function <span style="color: blue;">assetClassValue</span>, which takes an asset class
and integer, and returns a variable of type value. With the <span style="color: blue;">assetClassValueOf</span>
function, we can check how many tokens of a specific asset class are contained
in a value type variable. Below, you can see the type signatures of these functions.

```haskell
assetClass :: CurrencySymbol -> TokenName -> AssetClass
assetClassValue :: AssetClass -> Integer -> Value
assetClassValueOf :: Value -> AssetClass -> Integer
```

To construct a value variable and check the amount of tokens in it for a
specific asset class, we can do as follows from Prelude, which we have
built with the required Plutus libraries.

```console
Prelude> import PlutusLedgerApi.V1.Value
Prelude PlutusLedgerApi.V1.Value> :set -XOverloadedStrings
Prelude PlutusLedgerApi.V1.Value> myAssetClass = assetClass "a507ff33" "MyToken"
Prelude PlutusLedgerApi.V1.Value> myTokenValue = assetClassValue myAssetClass 77
```

To construct an asset class for ada, we can use the <span style="color: blue;">adaSymbol</span> and
<span style="color: blue;">adaToken</span> variables provided by the `PlutusLedgerApi.V1.Value` module.

```console
Prelude PlutusLedgerApi.V1.Value> ada = assetClass adaSymbol adaToken
Prelude PlutusLedgerApi.V1.Value> adaValue = assetClassValue ada 100000000
```

We can also combine different variables of type value with the semigroup
operator <span style="color: blue;"><></span> as the value type has an instance of the semigroup type
class. Using the <span style="color: blue;">assetClassValueOf</span> function, we can get the quantity of
a given asset class contained in a value.

```console
Prelude PlutusLedgerApi.V1.Value> combined = myTokenValue <> adaValue
Value (Map [(,Map [("",100000000)]),(a507ff33,Map [("MyToken",77)])])
Prelude PlutusLedgerApi.V1.Value> assetClassValueOf combined myAssetClass
77
```

We can also extract information from a value type variable as a list of
triples using the <span style="color: blue;">flattenValue</span> function.

```console
Prelude PlutusLedgerApi.V1.Value> :t flattenValue
flattenValue :: Value -> [(CurrencySymbol, TokenName, Integer)]
Prelude PlutusLedgerApi.V1.Value> flattenValue combined
{empty}[(,"",100000000),(a507ff33,"MyToken",77)]
```

So far, we have focused on the spending constructor of the
<span style="color: purple;">ScriptInfo</span> type variable that defines the purpose of the
currently-executing script. The <span style="color: purple;">TxInfo</span> data type contains the
<span style="color: purple;">MintValue</span> type that is structured the same way as the <span style="color: purple;">Value</span>
type. Minting policies are triggered if this field contains a non-zero
value. Each currency symbol defined in this variable activates the
corresponding minting policy, linking them through the policy’s hash.

A minting policy, like a spending validation script, only requires
one input: the script context. If for the currently-executing script the
<span style="color: purple;">ScriptInfo</span> data type defines the minting constructor that is
parameterized with a currency symbol, then the corresponding minting policy
gets triggered. The minting constructor does not contain a maybe datum like
the spending constructor does, because datums can exist at UTXOs sitting
at script addresses, and minting scripts do not consume these UTXOs. They
only produce new ones.

A single transaction may trigger several different minting policies if
multiple native tokens with distinct currency symbols are minted. Each policy
receives its own script info and redeemer as input, and they share the same
transaction information data type. All minting policies within a transaction
must pass for the transaction to succeed. Otherwise it fails.

Now, let us examine an example of a minting policy where only the owner
of a specific public key, who signs the transaction, is permitted to
mint or burn tokens. This key could represent a project or company
acting like a central bank in traditional finance, responsible for
minting and burning fiat currencies. Our minting policy will be
parameterized, accepting an additional public key hash as a parameter.

```haskell
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ImportQualifiedPost        #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE NoImplicitPrelude          #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE PatternSynonyms            #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE Strict                     #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE ViewPatterns               #-}
{-# OPTIONS_GHC -fno-full-laziness #-}
{-# OPTIONS_GHC -fno-ignore-interface-pragmas #-}
{-# OPTIONS_GHC -fno-omit-interface-pragmas #-}
{-# OPTIONS_GHC -fno-spec-constr #-}
{-# OPTIONS_GHC -fno-specialise #-}
{-# OPTIONS_GHC -fno-strictness #-}
{-# OPTIONS_GHC -fno-unbox-small-strict-fields #-}
{-# OPTIONS_GHC -fno-unbox-strict-fields #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:target-version=1.1.0 #-}

module Week05.Minting where

import           PlutusLedgerApi.Common      (SerialisedScript,
                                              serialiseCompiledCode)
import           PlutusLedgerApi.V1.Value    (flattenValue)
import           PlutusLedgerApi.V3          (ScriptContext (..), TokenName,
                                              TxInInfo (txInInfoOutRef),
                                              TxInfo (txInfoInputs, txInfoMint),
                                              TxOutRef (TxOutRef), TxId (TxId),
                                              PubKeyHash)
import           PlutusTx                    (BuiltinData, CompiledCode,
                                              UnsafeFromData (unsafeFromBuiltinData),
                                              compile)
import           PlutusLedgerApi.V3.Contexts (txSignedBy)
import           PlutusTx.Bool               (Bool (..), (&&))
import           PlutusTx.Prelude            (BuiltinUnit, Eq ((==)), any, check,
                                              traceIfFalse, ($))

{- ------------------------------------------------------------------------------ -}
{- --------------------------------- VALIDATOR ---------------------------------- -}

{-# INLINABLE signedVal #-}
signedVal :: PubKeyHash -> ScriptContext -> Bool
signedVal pkh ctx = traceIfFalse "missing signature" $
                                 txSignedBy (scriptContextTxInfo ctx) pkh

{- ------------------------------------------------------------------------------ -}
{- ---------------------------------- HELPERS ----------------------------------- -}

compiledSignedVal :: CompiledCode (BuiltinData -> BuiltinData -> BuiltinUnit)
compiledSignedVal = $$(compile [||wrappedVal||])
 where
  wrappedVal :: BuiltinData -> BuiltinData -> BuiltinUnit
  wrappedVal pkh ctx = check $ signedVal
                                 (unsafeFromBuiltinData pkh)
                                 (unsafeFromBuiltinData ctx)

serializedSignedVal :: SerialisedScript
serializedSignedVal = serialiseCompiledCode compiledSignedVal
```

First, we add all the necessary language pragmas. We then name the
module `Week05.Minting`, since the idea for the code examples is taken
from the 5th week of the 4th Plutus pioneer program. After that, we
import the modules we need. Next, we define our minting policy. It
is parameterized with a public key hash and the validation checks if
the correct signature is present. We do not check if the currently
executing script has a minting purpose specified. In that sense, this
validation logic could also be used as a spending script. Then we
compile the minting policy as in the examples before, and serialize
it. Now that we have our minting policy, we can look at the off-chain
code that interacts with it.

```typescript
import {
    BlockfrostProvider,
    MeshWallet,
    Transaction,
    PlutusScript,
    applyCborEncoding,
    deserializeAddress,
    Mint,
    Action
  } from "@meshsdk/core";
import { applyParamsToScript } from "@meshsdk/core-cst";
import { secretSeed } from "./seed.ts";

// Define blockchain provider and wallet
const provider: BlockfrostProvider = new BlockfrostProvider("<blockfrost-key>");
const wallet: MeshWallet = new MeshWallet({
    networkId: 0, //0=testnet, 1=mainnet
    fetcher: provider,
    submitter: provider,
    key: {
        type: "mnemonic",
        words: secretSeed
    }
});

// Define address and public key hash of it
const walletAddress: string = await wallet.getChangeAddress();
const signerHash: string = deserializeAddress(walletAddress).pubKeyHash;

// Defining our minting policy
const mintingPolicy: PlutusScript = {
    code: applyParamsToScript(
            applyCborEncoding("590b490101003232323232323232323232322259..."),
            [signerHash]),
    version: "V3"
};
```

First, we import all necessary MeshJS classes and functions, then
we define our blockchain provider and wallet, same as before. Next we
read out our wallet address and the public key hash. Then we
define our minting policy, where we apply the public key hash as
a parameter. Then follows the code for minting tokens.

```typescript
// Defining our token
const token: Mint = {
    assetName: 'MyTokens',
    assetQuantity: '2',
    recipient: { address: walletAddress }
  }

// Minting our tokens
async function mintTokens(): Promise<string> {
    const redeemer: Pick<Action, "data"> = { data: { alternative: 0, fields: [] } }

    const tx = new Transaction({ initiator: wallet, fetcher: provider })
        .setNetwork("preview")
        .mintAsset(mintingPolicy, token, redeemer)
        .setRequiredSigners([walletAddress]);

    const txUnsigned = await tx.build();
    const txSigned = await wallet.signTx(txUnsigned);
    const txHash = await wallet.submitTx(txSigned);
    return txHash
}

// Function calls
console.log(await mintTokens());
```

We first define the tokens we want to mint where we specify the token
name, the amount, and the address where the tokens should be created.
In Plutus, a token name can be an arbitrary byte string, which is limited
to 32 bytes. If a human-readable name is set, wallets also display it in
that form. The number of tokens has to be a positive integer. After setting
the tokens we want to mint, we define our minting function. In it, we first
define an empty redeemer. Next, we create our transaction. In the transaction
we set the network, specify which tokens we want to mint with which minting
policy, add the redeemer, and sign the transaction with our wallet key.
At the end we build, sign, and submit the transaction and return the
transaction hash. Now we can make our function call and mint the tokens.
If we name our file `signed-minting.ts`, we can mint our tokens as:

```console
deno run -A signed-minting.ts
```

We can then check the transaction details again on the
[preview.cardanoscan.io](http://preview.cardanoscan.io/) webpage.
This was an example of minting fungible tokens. Fungibility means
that one token is interchangeable with another token of the same type,
meaning each unit has the same value as any other unit.

Plutus also allows the minting of non-fungible tokens (NFTs), which are
unique tokens that can only be minted once. The key to writing such a
minting policy is referencing something unique on the blockchain,
and for that, we use UTXOs. UTXOs can exist only once, and once consumed
as input to a transaction, they can never exist again. UTXOs are defined
by transaction hashes, which are unique, and by output indices. The reason
every transaction has a unique hash was explained in lesson 4
_Script context explained_.

When minting an NFT, the idea is to include a specific parameter in the
minting policy – namely, a UTXO transaction hash and ID – and have the policy
check that the transaction performing the minting consumes that specific UTXO.
Let us look at an example of such a minting policy.

```haskell
{- ------------------------------------------------------------------------------ -}
{- ------------------------------- NFT VALIDATOR -------------------------------- -}

{-# INLINEABLE nftVal #-}
nftVal :: TxOutRef -> TokenName -> ScriptContext -> Bool
nftVal oref tn ctx =
  traceIfFalse "UTxO not consumed" checkHasUTxO &&
  traceIfFalse "You can only mint one!" checkMintedAmount
 where
  checkHasUTxO :: Bool
  checkHasUTxO = any (\i -> txInInfoOutRef i == oref) $ txInfoInputs info

  checkMintedAmount :: Bool
  checkMintedAmount = case flattenValue (txInfoMint info) of
    [(_, tn', amt)] -> tn' == tn && amt == 1
    _               -> False

  info :: TxInfo
  info = scriptContextTxInfo ctx

{- ------------------------------------------------------------------------------ -}
{- ---------------------------------- HELPERS ----------------------------------- -}

compiledNftVal :: CompiledCode (BuiltinData -> BuiltinData -> BuiltinData ->
                                BuiltinData -> BuiltinUnit)
compiledNftVal = $$(compile [||wrappedVal||])
 where
  wrappedVal :: BuiltinData -> BuiltinData -> BuiltinData ->
                BuiltinData -> BuiltinUnit
  wrappedVal tid idx tn ctx =
    let oref :: TxOutRef
        oref = TxOutRef
          (TxId $ unsafeFromBuiltinData tid)
          (unsafeFromBuiltinData idx)
    in check $ nftVal
                 oref
                 (unsafeFromBuiltinData tn)
                 (unsafeFromBuiltinData ctx)

serializedNFTVal :: SerialisedScript
serializedNFTVal = serialiseCompiledCode compiledNftVal
```

The language pragmas and import of modules from the previous minting
policy example also cover the functionality needed in this minting policy.
Our script will be parameterized by two inputs: the transaction output
reference - <span style="color: purple;">TxOutRef</span> - of the UTXO we are spending and the token
name. The condition we check is that the minting transaction consumes the
specified transaction reference passed to the script. The <span style="color: blue;">any</span> function
is used to check this. It takes a Boolean-returning function and applies
it to a list, returning true if at least one element satisfies the condition.
We also ensure that only one token with the specified name is minted by using
the <span style="color: blue;">flattenValue</span> function, which converts a value type into a list
of triples. These checks ensure only one coin is minted with the currency
symbol tied to a specific parameterized script.

After defining our minting policy, we compile it. The transaction
output reference is made up of two types: transaction hash
and output index. Before compiling our script in untyped form, we can change
it so it takes in the transaction hash and output index as two separate
parameters. We do that in the <span style="color: blue;">wrappedVal</span> helper function. It takes
in four parameters that are all of the type <span style="color: purple;">BuiltinData</span> and converts them
to their custom data types before applying them to our typed minting policy.
After compiling our untyped minting policy, we serialize it. In principle,
we could also leave our policy to take in the transaction output
reference as a whole and then model that in our off-chain code. In our code,
we wanted to show how to split up such a variable and correctly apply
the <span style="color: blue;">unsafeFromBuiltinData</span> to individual parts. Next, we present the
off-chain code that interacts with our NFT minting policy.

```typescript
import {
    BlockfrostProvider,
    MeshWallet,
    Transaction,
    PlutusScript,
    applyCborEncoding,
    UTxO,
    Action,
    Mint
  } from "@meshsdk/core";
import { applyParamsToScript } from "@meshsdk/core-cst";
import { secretSeed } from "./seed.ts";

// Define blockchain provider and wallet
const provider: BlockfrostProvider = new BlockfrostProvider("<blockfrost-key>");
const wallet: MeshWallet = new MeshWallet({
    networkId: 0, //0=testnet, 1=mainnet
    fetcher: provider,
    submitter: provider,
    key: {
        type: "mnemonic",
        words: secretSeed
    }
});

// Define address and public key hash of it
const walletAddress: string = await wallet.getChangeAddress();

// Defining the UTXO we want to spend
const utxos: UTxO[] = await wallet.getUtxos();
const utxo: UTxO = utxos[0];

// Defining our NFT policy
const nftPolicy: PlutusScript = {
    code: applyParamsToScript(
            applyCborEncoding("590bf50101003232323232323232323232323232222259..."),
            [utxo.input.txHash, BigInt(utxo.input.outputIndex), "My NFT"]),
    version: "V3"
};
```

First, we again import all necessary MeshJS classes and functions
and define our provider and wallet. After that, we set our wallet
address and read out the first UTXO sitting at our wallet address.
We will use this UTXO to parameterize our minting policy and also
spend it when creating the minting transaction. Next we define our
NFT minting policy. We again shortened the compiled code and parameterize
the code with the transaction hash and output index of the UTXO we
selected. We also provide the name of our NFT we want to mint. Now
we can look at the function that mints the NFT.

```typescript
// Defining our NFT token
const nftToken: Mint = {
    assetName: 'My NFT',
    assetQuantity: '1',
    recipient: { address: walletAddress }
  }

// Minting our NFT
async function mintNFT(): Promise<string> {
    const redeemer: Pick<Action, "data"> = { data: { alternative: 0, fields: [] } }

    const tx = new Transaction({ initiator: wallet, fetcher: provider })
        .setNetwork("preview")
        .setTxInputs([utxo])
        .mintAsset(nftPolicy, nftToken, redeemer);

    const txUnsigned = await tx.build();
    const txSigned = await wallet.signTx(txUnsigned);
    const txHash = await wallet.submitTx(txSigned);
    return txHash
}

// Function calls
console.log(await mintNFT());
```

We define our token that we want to mint and provide the
token name, token quantity (which should be one), and set the
recipient address to our own address. Then we define our minting
function. We set an empty redeemer and create the transaction,
similar to the previous minting policy. The difference is
that in this example we specify the UTXO we want to spend,
and we do not need to add the required signature linked to
our wallet as we did in the previous minting example. At the
end we build, sign, and submit the transaction and return
the transaction hash. When we call the minting function,
we again log the hash so it can be used at the
[preview.cardanoscan.io](http://preview.cardanoscan.io/) webpage
to inspect our transaction that minted the NFT.

If we run this code multiple times, we would create tokens with
the same name but different currency symbols because we would parameterize
the minting script each time with a different UTXO. This difference in
currency symbols ensures that each token is truly an NFT, as the asset
class is defined by both the token name and its unique currency symbol.

It is also possible to associate an image with a token or NFT. It can be
referenced from the [InterPlanetary file system](https://ipfs.tech/) or
embedded as a [base64](https://en.wikipedia.org/wiki/Base64) encoded string
into the datum metadata of the token or NFT. The _code/_ folder of the Plinth
module contains the [nft-image.ts](https://github.com/iohkedu/cardano-education-program/tree/main/plinth-module/blob/main/code/off-chain/meshjs/Week05/nft-image.ts)
file that shows how to mint a NFT with an embeded image that Lace displays. 
For more information, see [CIP-68](https://cips.cardano.org/cip/CIP-68)
that defines the datum metadata standard. The
[MeshJS docs](https://meshjs.dev/apis/txbuilder/minting#minting-assets-with-cip-68-metadata-standard) also
provide an example of how to mint assets with the CIP-68 metadata standard.

At the end of this lesson, we note that the utility of a token can be determined by its use
case, the market, or the community that issues and adopts it. Tokens can be
used for various purposes such as issuing a new cryptocurrency, representing access
rights, or enabling in-app transactions. Native tokens enable a wide range of
applications by combining secure on-chain logic with the flexibility of custom
asset creation. From the
[IO blog on native tokens](https://iohk.io/en/blog/posts/2025/05/09/native-tokens-in-the-extended-utxo-model/)
we get the following use cases for native tokens:

* Digital collectibles and credentials. NFTs can represent ownership of digital
art, in-game assets, event tickets, or even academic credentials – benefiting
from the security and transparency of the Cardano ledger.
* Supply chain and asset tracking. Tokens can represent physical items and track
their journey across a supply chain. Because native tokens can be uniquely defined
and managed without smart contracts, this approach is more efficient and secure.
* Algorithmic stablecoins. Native tokens can represent assets with values tied to
external references. Forging policy scripts define the rules that keep these tokens
stable, enabling automated monetary policies and more robust decentralized finance
(DeFi) primitives.
* Tokenized roles and permissions. Roles within a decentralized system – such as
operator, validator, or participant – can also be represented by unique native tokens.
Holding a token grants permission to perform specific actions, allowing for modular
and transferable system designs.
* Access control and licensing. A token could grant access to a service, event,
or dataset. For example, holding a specific token could unlock premium features
in a DApp or grant entry to a token-gated community.
* Decentralized governance. Native tokens can represent voting rights or stake
in decision-making processes. This enables on-chain governance systems with
transparent and auditable participation.

To learn more about native tokens, see:

* [Native tokens](https://docs.cardano.org/developer-resources/native-tokens/)
overview on Cardano Docs
* [Discover native tokens](https://developers.cardano.org/docs/native-tokens/)
section on the Developer Portal
* [Ledger explanations](https://cardano-ledger.readthedocs.io/en/latest/explanations/index.html)
page, which also covers native tokens
* [Native Custom Tokens in the Extended UTXO Model](https://iohk.io/en/research/library/papers/native-custom-tokens-in-the-extended-utxo-model/)
scientific paper.
