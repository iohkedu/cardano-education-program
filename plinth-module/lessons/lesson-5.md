# Time-dependent and parameterized validators

This lesson demonstrates a smart contract representing a vesting
schema. In this scenario, a person sends a gift of ada to the smart
contract, and the beneficiary can reclaim this gift after a set deadline
has passed. Such a contract can take two approaches, depending on how the
validator accesses the beneficiary and deadline information:

* From the datum attached to the UTXO we are creating at this script address
* From a parameter added as an input variable to the validator script.

First, we present the approach when the validator uses the datum of the UTXO.

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
{-# OPTIONS_GHC -fno-warn-unused-binds #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:target-version=1.1.0 #-}

module Week03.Vesting where

import           GHC.Generics                  (Generic)
import           PlutusLedgerApi.Common        (FromData (fromBuiltinData),
                                                SerialisedScript,
                                                serialiseCompiledCode)
import           PlutusLedgerApi.Data.V3       (POSIXTime, PubKeyHash)
import           PlutusLedgerApi.V1.Interval   (contains, from)
import           PlutusLedgerApi.V3            (ScriptContext (..),
                                                ScriptInfo (..),
                                                TxInfo (txInfoValidRange),
                                                getDatum)
import           PlutusLedgerApi.V3.Contexts   (txSignedBy)
import           PlutusTx                      (BuiltinData, CompiledCode,
                                                UnsafeFromData
                                                 (unsafeFromBuiltinData),
                                                compile,
                                                makeIsDataSchemaIndexed,
                                                makeLift)
import           PlutusTx.Blueprint            (HasBlueprintDefinition)
import           PlutusTx.Blueprint.Definition (definitionRef)
import           PlutusTx.Bool                 (Bool (..), (&&))
import           PlutusTx.Prelude              (BuiltinUnit, Maybe (..), check,
                                                traceError, traceIfFalse, ($),
                                                (.))

{- ------------------------------------------------------------------------------ -}
{- ----------------------------------- TYPES ------------------------------------ -}

data VestingDatum = VestingDatum
  { beneficiary :: PubKeyHash
  , deadline    :: POSIXTime
  }
  deriving stock (Generic)
  deriving anyclass (HasBlueprintDefinition)

makeIsDataSchemaIndexed ''VestingDatum [('VestingDatum, 0)]

{- ------------------------------------------------------------------------------ -}
{- --------------------------------- VALIDATOR ---------------------------------- -}

{-# INLINEABLE vestingVal #-}
vestingVal :: ScriptContext -> Bool
vestingVal ctx =
  traceIfFalse "Is not the beneficiary" checkBeneficiary
    && traceIfFalse "Deadline not reached" checkDeadline
 where
  checkBeneficiary :: Bool
  checkBeneficiary = txSignedBy info (beneficiary vestingDatum)

  checkDeadline :: Bool
  checkDeadline = from (deadline vestingDatum) `contains` txInfoValidRange info

  vestingDatum :: VestingDatum
  vestingDatum = case scriptContextScriptInfo ctx of
    SpendingScript _txRef (Just datum) ->
      case (fromBuiltinData @VestingDatum . getDatum) datum of
        Just d  -> d
        Nothing -> traceError "Expected correctly shaped datum"
    _ -> traceError "Expected SpendingScript with datum"

  info :: TxInfo
  info = scriptContextTxInfo ctx

{- ------------------------------------------------------------------------------ -}
{- ---------------------------------- HELPERS ----------------------------------- -}

compiledVestingVal :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledVestingVal = $$(compile [||wrappedVal||])
 where
  wrappedVal :: BuiltinData -> BuiltinUnit
  wrappedVal ctx = check $ vestingVal (unsafeFromBuiltinData ctx)

serializedVestingVal :: SerialisedScript
serializedVestingVal = serialiseCompiledCode compiledVestingVal
```

In the beginning, we add all necessary language pragmas and import
statements. The functions, types, and type classes we import are necessary
to cover the functionality for both validators presented in this lesson.
We name the module `Week03.Vesting` since the idea for the vesting contract
comes from the _Week03_ examples from the Plutus pioneer program.

Then we define our <span style="color: purple;">VestingDatum</span> datum type. It contains the
beneficiary's public key hash and the deadline in the form of <span style="color: purple;">POSIXTime</span>
after which the funds can be claimed. Because we are defining a custom data
type, we need to use the <span style="color: blue;">makeIsDataSchemaIndexed</span> function that generates
the <span style="color: purple;">ToData</span>, <span style="color: purple;">FromData</span>, <span style="color: purple;">UnsafeFromData</span>, and
<span style="color: purple;">HasBlueprintSchema</span> instances for our custom type. As stated in
a previous lesson, we use Template Haskell, which requires adding two single
quotes in front of the type to return the type's name.

Next comes the code for the validator. The validation logic says
that the funds can be unlocked only when the deadline has been
reached and the transaction is signed by the beneficiary. The helper
variables <span style="color: blue;">checkBeneficiary</span> and <span style="color: blue;">checkDeadline</span>
are of type <span style="color: purple;">Bool</span>. In the first variable, we use the helper
function <span style="color: blue;">txSignedBy</span> that takes a transaction info and a public key
hash and checks whether or not this transaction has been signed with the correct key
that belongs to the hash. In the second variable, we access the transaction
validity range and check whether it is contained inside the interval
starting with the deadline and going to infinity. As a side note we state
when the validity range for a transaction is being defined,
the transaction gets processed by a node only if the time of processing
for this transaction falls into the validity range of the transaction.

In the validator code, the datum gets extracted from the script context and
converted to typed form. If the script purpose is incorrect, the datum
is not attached, or has an incorrect form, we raise an error and log a message.
At the end we wrap, compile, and serialize the validator function.

In the examples we have seen so far, the validators took in a single parameter,
the script context, and returned a <span style="color: purple;">Bool</span> or a <span style="color: purple;">BuiltinUnit</span>. If
there is any variability in the contract, we model that by using the datum as in
the vesting example, which contained the beneficiary and the deadline. An alternative
approach is to use parameterized contracts,
where variability is integrated into the contract
by adding a parameter variable to the validator function. The code below shows this,
containing a modified version of the previous vesting code example.

```haskell
{- ------------------------------------------------------------------------------ -}
{- ---------------------------- PARAMETERIZED TYPES ----------------------------- -}

data VestingParams = VestingParams
  { beneficiaryParam :: PubKeyHash
  , deadlineParam    :: POSIXTime
  }
  deriving stock (Generic)
  deriving anyclass (HasBlueprintDefinition)

makeLift ''VestingParams
makeIsDataSchemaIndexed ''VestingParams [('VestingParams, 0)]

{- ------------------------------------------------------------------------------ -}
{- -------------------------- PARAMETERIZED VALIDATOR --------------------------- -}

{-# INLINEABLE paramVestingVal #-}
paramVestingVal :: VestingParams -> ScriptContext -> Bool
paramVestingVal vp ctx =
  traceIfFalse "Is not the beneficiary" checkBeneficiary
    && traceIfFalse "Deadline not reached" checkDeadline
 where
  checkBeneficiary :: Bool
  checkBeneficiary = txSignedBy info (beneficiaryParam vp)

  checkDeadline :: Bool
  checkDeadline = from (deadlineParam vp) `contains` txInfoValidRange info

  info :: TxInfo
  info = scriptContextTxInfo ctx

{- ------------------------------------------------------------------------------ -}
{- ---------------------------------- HELPERS ----------------------------------- -}

compiledParamVestingVal :: CompiledCode (BuiltinData -> BuiltinData -> BuiltinUnit)
compiledParamVestingVal = $$(compile [||wrappedVal||])
 where
  wrappedVal :: BuiltinData -> BuiltinData -> PlutusTx.Prelude.BuiltinUnit
  wrappedVal params ctx = check $ paramVestingVal (unsafeFromBuiltinData params)
                                                  (unsafeFromBuiltinData ctx)

serializedParamVestingVal :: SerialisedScript
serializedParamVestingVal = serialiseCompiledCode compiledParamVestingVal
```

First, we create the <span style="color: purple;">VestingParams</span> type, which was previously called
<span style="color: purple;">VestingDatum</span>. It holds the beneficiary's public key hash and the
deadline after which the beneficiary can claim the funds. Then we again use
Template Haskell and generate the necessary instances for our custom type.
We also use the <span style="color: blue;">makeLift</span> function that generates for our custom data
type an instance of the <span style="color: purple;">Lift</span> type class. This line only compiles if
the <span style="color: purple;">MultiParamTypeClasses</span> and <span style="color: purple;">ScopedTypeVariables</span> language
extensions are enabled. An instance of the <span style="color: purple;">Lift</span> type class is needed
so that a validator containing a parameter can be compiled even though the
parameter is not known at the time of compilation.

```haskell
class Lift uni a where
    -- | Get a Plutus IR term corresponding to the given value.
    lift :: a -> RTCompile uni fun (Term TyName Name uni fun ())
```

It contains only the <span style="color: blue;">lift</span> method, but we will not use that directly.
There are a lot of instances for existing Plutus type in this type class such as
<span style="color: purple;">BuiltinData</span>, <span style="color: purple;">BuiltinString</span>, <span style="color: purple;">BuiltinInteger</span> and
<span style="color: purple;">Bool</span>. However, this is not used for functions, as they cannot be
used to compile Haskell to Plutus validators.
The reason it is possible to compile a parameterized validator in Plutus is
that the input parameter is not some arbitrary Haskell function, it is static
data that you can pass at runtime to a script function if you create an instance
of the <span style="color: purple;">Lift</span> type class.

Next comes the validator code. The type signature of the validator function
changes so it takes the additional vesting parameter. While our example only uses one parameter, it's worth noting note that a
validator function can take any number of parameters. In the body of the validator function, we now read the deadline and
the beneficiary's public key hash from the vesting parameter. Apart from that,
the logic of the validator stays the same. Then the validator gets compiled and
serialized. When compiling the validator, another type parameter needs to be
added to the type signatures, and we also need to apply the <span style="color: blue;">unsafeFromBuiltinData</span>
function to the vesting parameter in order to wrap the validator before compiling it.

This concludes the procedure of writing a parameterized contract. In the next lesson
we look at off-chain code that interacts with the validators presented in this lesson.
