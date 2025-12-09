# Simple validation scripts

In this lesson, we will look at basic Plinth validation scripts. All
validation scripts and data types presented in this lesson are PlutusV3
scripts and data types. An exception are PlutusV1
and V2 data types that were not modified with the introduction of PlutusV3
and can be still used in PlutusV3 scripts. A validation script or
validator is the smart contract program that checks whether funds at a
script address are allowed to be spent by a given transaction. A validation
script in EUTXO cannot see the entire state of
the blockchain; instead, it can view the entire transaction being validated.
The script uses a single parameter: the script context. It returns a value
that indicates whether the validation logic has passed or not. Depending on
the type of the script context, there are two possible implementations of
a Plinth validation script:

* In the low-level implementation, the script context is represented
using the <span style="color: purple;">BuiltinData</span> type, and the return value is of type
<span style="color: purple;">BuiltinUnit</span>.
* In the high-level implementation, the script context is represented as
a predefined Haskell type, and the return value is of type <span style="color: purple;">Bool</span>.

Below you can see two example validation script type signatures, one
low-level and one high-level:

```haskell
validatorName :: BuiltinData -> BuiltinUnit
validatorName :: ScriptContext -> Bool
```

Both implementations can be used in smart contract code. The main
difference lies in code performance, with the low-level implementation
offering better performance. Low-level validation scripts are referred
to as _untyped validation scripts_, while high-level scripts are known as
_typed validation scripts_.

The <span style="color: purple;">BuiltinData</span> doesn't have its constructors exposed. The module
that defines <span style="color: purple;">BuiltinData</span> contains two conversion functions:
<span style="color: blue;">builtinDataToData</span> and <span style="color: blue;">dataToBuiltinData</span>, that can
convert <span style="color: purple;">BuiltinData</span> back and forth to the <span style="color: purple;">Data</span> type. These functions
can be used in off-chain code, but not in on-chain code. The <span style="color: purple;">Data</span> type has
its constructor exposed, as illustrated in the code below:

```haskell
data Data
    = Constr Integer [Data]
    | Map [(Data, Data)]
    | List [Data]
    | I Integer
    | B BS.ByteString
    deriving stock (Show, Read, Eq, Ord, Generic, Data.Data.Data)
    deriving anyclass (Hashable, NFData, NoThunks)
```

It is a recursive algebraic data type that can represent integers, byte strings,
lists, and maps. Next, we show the Haskell implementation of the script context data type:

```haskell
data ScriptContext = ScriptContext
  { scriptContextTxInfo     :: TxInfo
  , scriptContextRedeemer   :: V2.Redeemer
  , scriptContextScriptInfo :: ScriptInfo
  }
  deriving stock (Generic, Haskell.Eq, Haskell.Show)
  deriving anyclass (HasBlueprintDefinition)
```

The script context contains:

* transaction information (inputs, outputs, validity interval, etc.)
* redeemer (arbitrary data defined by the user)
* script information (defines the purpose of the script, such as spending or minting;
for a spending script, the script information potentially contains a datum).

We will look into those data types in more detail in lesson
_Script context explained_. If a transaction tries to spend multiple UTXOs
at a script address, the spending script is run for every UTXO individually.
The redeemer and the script information are individually assigned for every
UTXO in that transaction. The transaction information is only one and is
accessible to every script instance that is being triggered by a single transaction.

Let us now examine a simple untyped validator script that always succeeds:

```haskell
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ImportQualifiedPost        #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE PatternSynonyms            #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE Strict                     #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE ViewPatterns               #-}
{-# LANGUAGE NoImplicitPrelude          #-}
{-# OPTIONS_GHC -fno-full-laziness #-}
{-# OPTIONS_GHC -fno-ignore-interface-pragmas #-}
{-# OPTIONS_GHC -fno-omit-interface-pragmas #-}
{-# OPTIONS_GHC -fno-spec-constr #-}
{-# OPTIONS_GHC -fno-specialise #-}
{-# OPTIONS_GHC -fno-strictness #-}
{-# OPTIONS_GHC -fno-unbox-small-strict-fields #-}
{-# OPTIONS_GHC -fno-unbox-strict-fields #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:target-version=1.1.0 #-}

module Week02.Validators where

import GHC.Generics                  (Generic)
import PlutusLedgerApi.Common        (FromData (fromBuiltinData),
                                      SerialisedScript,
                                      serialiseCompiledCode)
import PlutusLedgerApi.V3            (Redeemer (getRedeemer),
                                      ScriptContext (..))
import PlutusTx                      (BuiltinData, CompiledCode,
                                      UnsafeFromData (unsafeFromBuiltinData),
                                      compile, makeIsDataSchemaIndexed)
import PlutusTx.Builtins             (unsafeDataAsI)
import PlutusTx.Bool                 (Bool (..))
import PlutusTx.Prelude              (BuiltinUnit, Eq (..), Integer,
                                      Maybe (..), check, traceError,
                                      traceIfFalse, ($), otherwise,
                                      (.))
import PlutusTx.Blueprint            (HasBlueprintDefinition)
import PlutusTx.Blueprint.Definition (definitionRef)
import qualified PlutusTx.Builtins.Internal as BI (
                                      BuiltinList, BuiltinInteger,
                                      head, snd, tail, unitval,
                                      unsafeDataAsConstr)

{- ----------------------------------------------------------------------------- -}
{- --------------------------- Always True validator --------------------------- -}

{-# INLINEABLE mkGiftValidator #-}
mkGiftValidator :: BuiltinData -> BuiltinUnit
mkGiftValidator _ctx = check True

compiledMkGiftValidator :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledMkGiftValidator = $$(compile [||mkGiftValidator||])

serializedMkGiftValidator :: SerialisedScript
serializedMkGiftValidator = serialiseCompiledCode compiledMkGiftValidator
```

The long list of language pragmas, GHC compiler options, and import statements
is necessary to cover the functionality for all validators presented in this 
lesson. From the language pragmas, we note that
we add the <span style="color: purple;">NoImplicitPrelude</span> extension that prevents the standard
`Prelude` module from being imported. The `PlutusTx` module defines a custom
prelude where all functions use strict evaluation rather than lazy evaluation.
This also applies to all other functions defined in any module used for
Plinth coding. One can read more about GHC language pragmas at the
[Haskell wiki](https://wiki.haskell.org/Language_Pragmas), which provides
links to official GHC documentation. The
[GHC docs](++https://downloads.haskell.org/ghc/latest/docs/users_guide/using-optimisation.html#ghc-flag--ffull-laziness++)
also cover various GHC compiler options. We name our module `Week02.Validators`.
The naming of modules in the code examples follows the naming from the
[fourth iteration](https://github.com/input-output-hk/plutus-pioneer-program/tree/fourth-iteration)
of the Plutus pioneer program.
Next, we import several submodules from the `PlutusLedgerApi` and the `PlutusTx`
modules that define functions for working with PlutusV3 scripts.

After that, the on-chain validator code follows. We name the validator function
<span style="color: blue;">mkGiftValidator</span> – which means _make gift validator_. It is an untyped validator
that always succeeds. It takes in the script context as the only argument, which is
of type <span style="color: purple;">BuiltinData</span>, and returns something of type <span style="color: purple;">BuiltinUnit</span>.
In the body of the function, the script context is ignored, and we use the <span style="color: blue;">check</span>
function which takes a value of type <span style="color: purple;">Bool</span>, and returns a value of type
<span style="color: purple;">BuiltinUnit</span> if the input argument is true, or raises an error if it is false.

```haskell
check :: Bool -> BI.BuiltinUnit
check b = if b then BI.unitval else traceError checkHasFailedError

unitval :: BuiltinUnit
unitval = BuiltinUnit ()

data BuiltinUnit = BuiltinUnit ~() deriving stock Data
```

The <span style="color: blue;">check</span> function returns the <span style="color: blue;">unitval</span> variable that is a
wrapper around the unit (empty tuple) type. The unit type in Haskell (`()`)
indicates that a function returns no specific meaningful value, similar to `void`
in languages like Java or C++. If an untyped validator returns the <span style="color: purple;">BuiltinUnit</span>
type the validation logic passes, and if an error is raised, the validation
logic fails. It is now clear why this validator is called `Gift` – anyone can
claim funds from this address, since the validation will always succeed.

Next, we compile the validator. We use the <span style="color: blue;">PlutusTx.compile</span> function
that takes a syntax tree of a function as input, which we can get if we put the
Oxford brackets <span style="color: blue;">[||mkGiftValidator||]</span> around the validator function. The
<span style="color: blue;">compile</span> function produces another syntax tree written in the Plutus
language. Then the <span style="color: blue">$$</span> symbol, called splice, takes a syntax tree and splices
it back to Haskell source code. The splice operator and the Oxford
brackets can be used because we added the <span style="color: purple;">TemplateHaskell</span> language
pragma, which enables this language extension.

It is important to note that normally in Oxford brackets, you cannot
reference anything defined outside of them. This can become an issue
when validator functions are long expressions or when library functions
are called within their body. A workaround is to make the function
inlinable. By adding the <span style="color: purple;">INLINABLE</span> pragma statement before or
after the function definition, the GHC compiler replaces the function call
in the Oxford brackets with the actual function body.

This completes the on-chain code. Next, we use the <span style="color: blue;">serialiseCompiledCode</span>
helper function that returns something of type <span style="color: purple;">ShortByteString</span>, which
is a compact representation of a <span style="color: purple;">Word8</span> vector (8-bit unsigned integer type).
At the end of this lesson, we present the code that lets us generate
[Plutus blueprints](https://cips.cardano.org/cip/CIP-57)
for the validators presented in this lesson. Plutus blueprints allow documenting
Plutus validators in `JSON` format and include the compiled validator code that is
represented as a `CBORHEX`. The 
[Concise Binary Object Representation](https://en.wikipedia.org/wiki/CBOR) (`CBOR`) is a binary data serialization format loosely based
on `JSON`. The `CBORHEX` is a hexadecimal representation of this data format.
For our <span style="color: blue;">mkGiftValidator</span> the blueprint will show the following `CBORHEX`:

```json
"compiledCode": "450101002499"
```

Since our contract is simple, the `CBORHEX` value is short. For more complex
contracts, this value would increase in length. This compiled code can then be
used in off-chain code when attaching the validator to a transaction. Let us now
explore an example where the validation logic always fails, regardless of the input.

```haskell
{- ------------------------------------------------------------------------------ -}
{- --------------------------- Always False validator --------------------------- -}

{-# INLINEABLE mkBurnValidator #-}
mkBurnValidator :: BuiltinData -> BuiltinUnit
mkBurnValidator _ctx = traceError "it burns!!!"

compiledMkBurnValidator :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledMkBurnValidator = $$(compile [||mkBurnValidator||])

serializedMkBurnValidator :: SerialisedScript
serializedMkBurnValidator = serialiseCompiledCode compiledMkBurnValidator
```

We call the validator <span style="color: blue;">mkBurnValidator</span>, since no funds can be reclaimed from
the contract once sent. The <span style="color: blue;">traceError</span> function can produce an
error and log a message displayed by the failed off-chain code transaction
that tries to claim any funds from this script address. Also, in this case, we ignore
the entire script context. Then we compile the validator and serialize it. We could
also use the <span style="color: blue;">check</span> function with a `False` argument; in that scenario, the
validation would still fail, but no custom error message would be logged.

Next, we show an example where we make use of the redeemer in the validation logic.
The redeemer type is defined as a wrapper around the <span style="color: purple;">BuiltinData</span> data type:

```haskell
newtype Redeemer = Redeemer {getRedeemer :: BuiltinData}
  deriving stock (Generic, Haskell.Show, Typeable)
  deriving newtype (Haskell.Eq, Haskell.Ord, Eq, ToData, FromData,
                    UnsafeFromData, Pretty)
  deriving anyclass (NFData, HasBlueprintDefinition)
```

We define an untyped validator that says the validation logic passes if the redeemer
is an integer with the value 42; otherwise, it fails:

```haskell
{- ------------------------------------------------------------------------------ -}
{- ----------------------- 42 validator untyped large CBOR ---------------------- -}

{-# INLINEABLE mk42ValidatorLarge #-}
mk42ValidatorLarge :: BuiltinData -> BuiltinUnit
mk42ValidatorLarge ctx
    | r == 42   = BI.unitval
    | otherwise = traceError "Expected 42 integer redeemer"
 where
  ctxTyped = case fromBuiltinData ctx of
    Just @ScriptContext c -> c
    Nothing -> traceError "ScriptContext could not be converted from BuiltinData"
  r = case fromBuiltinData $ getRedeemer (scriptContextRedeemer ctxTyped) of
    Just @Integer n -> n
    Nothing -> traceError "Redeemer is not a number"

compiledMk42ValidatorLarge :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledMk42ValidatorLarge = $$(compile [||mk42ValidatorLarge||])

serializedMk42ValidatorLarge :: SerialisedScript
serializedMk42ValidatorLarge = serialiseCompiledCode compiledMk42ValidatorLarge
```

In the example above, we first convert the untyped script context to its
typed form using the <span style="color: blue;">fromBuiltinData</span> function. It takes in
a variable of type <span style="color: purple;">BuiltinData</span> and returns a <span style="color: purple;">Maybe</span> type parameterized
with a type variable. If that type variable is a type that has an instance of the
<span style="color: purple;">FromData</span> type class, then the conversion will succeed. Otherwise, the function returns
<span style="color: purple;">Nothing</span>. You can find class instances for various Plutus types in the Plutus
[Haddock documentation](https://plutus.cardano.intersectmbo.org/haddock/latest/).
There also exists the <span style="color: blue;">unsafeFromBuiltinData</span> function that is defined in the
<span style="color: blue;">UnsafeFromData</span> type class. This function directly returns a type variable
instead of wrapping it in a <span style="color: purple;">Maybe</span> type. If the conversion fails,
the function raises an error, and the validation logic fails. We call it _unsafe_
since the conversion might fail with an error. Below
you can see the <span style="color: purple;">FromData</span> and <span style="color: purple;">UnsafeFromData</span> type classes.

```haskell
class FromData a where
  fromBuiltinData :: BuiltinData -> Maybe a

class UnsafeFromData a where
  unsafeFromBuiltinData :: BuiltinData -> a
```

Once we have the script context in typed form, we can access the redeemer,
a wrapper around the <span style="color: purple;">BuiltinData</span> type. Then we again try to convert
that type, in this case to an <span style="color: purple;">Integer</span>. Now that the redeemer is in the
correct form, we can simply check if it is equal to 42 and return the <span style="color: blue;">unitval</span>
variable or raise an error and log a message. We could also use the <span style="color: blue;">check</span>
function as we did in our previous examples. After that, we compile and serialize
the validator.

The reason why we stated _"large CBOR"_ in the comment above the code is that
converting the script context into a typed form is a costly operation and produces
a large CBOR. Next, let us look at the same validator in untyped form, where
we decode the script by keeping it in the form of the <span style="color: purple;">BuiltinData</span> type.
At the end of this lesson, we will compare `CBORHEX` lengths for
all validators presented in this lesson that check if the redeemer equals 42.

```haskell
{- ------------------------------------------------------------------------------ -}
{- ----------------------- 42 validator untyped small CBOR ---------------------- -}

{-# INLINEABLE mk42ValidatorSmall #-}
mk42ValidatorSmall :: BuiltinData -> BuiltinUnit
mk42ValidatorSmall ctx
    | redeemerInt == 42 = BI.unitval
    | otherwise         = traceError "Expected 42 integer redeemer"
 where
    -- Lazily decode script context up to redeemer;
    -- is less expensive and results in much smaller tx size
    constrArgs :: BuiltinData -> BI.BuiltinList BuiltinData
    constrArgs = BI.snd . BI.unsafeDataAsConstr

    scriptContextBL :: BI.BuiltinList BuiltinData
    scriptContextBL = constrArgs ctx

    redeemerBD :: BuiltinData
    redeemerBD = BI.head . BI.tail $ scriptContextBL

    redeemerInt :: BI.BuiltinInteger
    redeemerInt = unsafeDataAsI redeemerBD

compiledMk42ValidatorSmall :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledMk42ValidatorSmall = $$(compile [||mk42ValidatorSmall||])

serializedMk42ValidatorSmall :: SerialisedScript
serializedMk42ValidatorSmall = serialiseCompiledCode compiledMk42ValidatorSmall
```

First, we define a function called <span style="color: blue;">constrArgs</span> that helps us to
convert the <span style="color: purple;">BuiltinData</span> to the <span style="color: purple;">BuiltinList</span> type. We
recall that the script context is an algebraic product data type that
combines the transaction information, redeemer, and script information types.
Once we have converted the script context to a built-in list, we can use the
<span style="color: blue;">tail</span> and <span style="color: blue;">head</span> functions to extract the needed element.
In the case of the script context, the redeemer is in the second place, so
we first apply the <span style="color: blue;">tail</span> function and then the <span style="color: blue;">head</span> function.
Once we have the redeemer in the form of <span style="color: purple;">BuiltinData</span>, we can use
the <span style="color: blue;">unsafeDataAsI</span> that converts it to an integer. It is called
_unsafe_ because it raises an error if the conversion fails. Next, we
compile and then serialize the validator.

We note that if the redeemer were a more structured algebraic
data type, we could further decode it with the <span style="color: blue;">constrArgs</span>, <span style="color: blue;">tail</span>
and <span style="color: blue;">head</span> functions, or we could use the <span style="color: blue;">fromBuiltinData</span> function
to convert it to its typed form and access the elements we need.

Let us look now at the same validator that is written in a typed form.

```haskell
{- ------------------------------------------------------------------------------ -}
{- ----------------------------- 42 validator typed ----------------------------- -}

{-# INLINEABLE mk42TypedValidator #-}
mk42TypedValidator :: ScriptContext -> Bool
mk42TypedValidator ctx = traceIfFalse "Redeemer is a number different than 42"
                                      $ 42 == r
 where
  r = case fromBuiltinData $ getRedeemer (scriptContextRedeemer ctx) of
    Just @Integer n -> n
    Nothing -> traceError "Redeemer is not a number"

compiledMk42TypedValidator :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledMk42TypedValidator = $$(compile [||wrappedVal||])
 where
  wrappedVal :: BuiltinData -> BuiltinUnit
  wrappedVal ctxUntyped = check $ mk42TypedValidator (unsafeFromBuiltinData ctxUntyped)

serializedMk42TypedValidator :: SerialisedScript
serializedMk42TypedValidator = serialiseCompiledCode compiledMk42TypedValidator
```

The type signature now changes to `ScriptContext -> Bool`, which means
the validator succeeds if the logic returns `True` and fails if it returns
`False`. We can now access the redeemer directly from the script context
in its typed form and then try to convert the data inside the redeemer from
<span style="color: purple;">BuiltinData</span> to <span style="color: purple;">Integer</span>. To compile this typed validator,
we need to wrap it with a function that accepts <span style="color: purple;">BuiltinData</span> for its
argument. We use the <span style="color: blue;">unsafeFromBuiltinData</span> that converts the
script context from its untyped form to typed, and then apply the
<span style="color: blue;">mk42TypedValidator</span> and <span style="color: blue;">check</span> functions. After that, we can
compile the wrapped validator and serialize it.

At the end, we can look at one final validator example where we define
a custom redeemer type that is a wrapper around an <span style="color: purple;">Integer</span> type.
In the body of the validator we again match the integer number to 42.

```haskell
{- ------------------------------------------------------------------------------ -}
{- -------------------------- 42 validator custom type -------------------------- -}

-- Custom data types for our redeemer
data MySillyRedeemer = MkMySillyRedeemer Integer
  deriving stock (Generic)
  deriving anyclass (HasBlueprintDefinition)

makeIsDataSchemaIndexed ''MySillyRedeemer [('MkMySillyRedeemer, 0)]

{-# INLINEABLE mk42CustomValidator #-}
mk42CustomValidator :: ScriptContext -> Bool
mk42CustomValidator ctx = traceIfFalse "Redeemer is a number different than 42"
                                       $ 42 == r
 where
   r = case fromBuiltinData @MySillyRedeemer . getRedeemer $
                            scriptContextRedeemer ctx of
     Just (MkMySillyRedeemer rInt) -> rInt
     Nothing -> traceError "Redeemer is not of MySillyRedeemer type."

compiledMk42CustomValidator :: CompiledCode (BuiltinData -> BuiltinUnit)
compiledMk42CustomValidator = $$(compile [||wrappedVal||])
 where
  wrappedVal :: BuiltinData -> BuiltinUnit
  wrappedVal ctx = check $ mk42CustomValidator (unsafeFromBuiltinData ctx)

serializedMk42CustomValidator :: SerialisedScript
serializedMk42CustomValidator = serialiseCompiledCode compiledMk42CustomValidator
```

Here, we first define the custom data type <span style="color: purple;">MySillyRedeemer</span>
which is a wrapper around the <span style="color: purple;">Integer</span> type. Then we use the
<span style="color: blue;">makeIsDataSchemaIndexed</span> function that generates the <span style="color: purple;">ToData</span>,
<span style="color: purple;">FromData</span>, <span style="color: purple;">UnsafeFromData</span> and <span style="color: purple;">HasBlueprintSchema</span>
instances for our custom type, which contain functions for converting our custom
data type to the <span style="color: purple;">Data</span> type back and forth. We use template Haskell,
which requires adding two single quotes in front of the type to refer to the
type itself, allowing Template Haskell to generate the necessary instances.
After we have defined our redeemer type, we write the
validator logic in the same way as in the previous example, just that we now
convert the redeemer from <span style="color: purple;">BuiltinData</span> to the <span style="color: purple;">MySillyRedeemer</span>
type. We compile and serialize the validator in the same way as in the previous example.

Altogether, we have defined four different variants for the validator that 
matches the redeemer to the number 42. We note that if we were to import the
<span style="color: purple;">ScriptContext</span> data type from the
`PlutusLedgerApi.Data.V3` module instead of the `PlutusLedgerApi.V3` module,
the `CBORHEX` lengths decrease by around 10%. The table below shows compiled
code lengths for the four validators and for the two different `PlutusLedgerApi`
modules we can use.

|     |     |     |     |
| --- | :-: | :-: | :-: |
| 42 validator | PlutusLedgerApi.V3 | PlutusLedgerApi.Data.V3 | Reduction |
| Untyped (converting ScriptContext to typed form) | 13842 | 12362 | 10.7% |
| Untyped (decoding ScriptContext as BuiltinData) | 64 | 64 | 0% |
| Typed (Integer type redeemer) | 5887 | 5248 | 10.8% |
| Typed (custom type redeemer) | 6066 | 5428 | 10.5% |

We see that we get, by far, the most compact compiled code if we decode the
<span style="color: purple;">ScriptContext</span> in its untyped form and then convert the part we need
to typed form. We call that lazy decoding. This also brings an on-chain code
performance advantage. We get the largest `CBORHEX` for the untyped
validator, where we convert the entire <span style="color: purple;">ScriptContext</span> into typed form
in the body of the validator. The reason is this type carries much information
and converting the whole type into typed form is a costly operation.

The reason the compiled code is shorter if we import the <span style="color: purple;">ScriptContext</span>
from the `PlutusLedgerApi.Data.V3` module is that module provides an alternative
interface that works directly with the Plutus Core <span style="color: purple;">Data</span>
type under the hood. Due to Plutus updates, data types can now be thin wrappers
over the <span style="color: purple;">BuiltinData</span>
type, which allows retaining the user-friendliness of the data type version while also
avoiding the upfront cost of decoding the <span style="color: purple;">BuiltinData</span> into sums of products.
We call a data type _data-backed_ if it is representationally equivalent to <span style="color: purple;">BuiltinData</span>.

Since Plutus now provides a way to deal directly with the <span style="color: purple;">Data</span> type
for all Plutus script versions (V1, V2, and V3), developers can move away from sums of
products or Scott encoding. The
[Plinth user guide](https://plutus.cardano.intersectmbo.org/docs/working-with-scripts/optimizing-scripts-with-asData)
provides instructions on how to optimize scripts with the `PlutusTx.asData`
module that contains Template Haskell (TH) code for encoding algebraic data
types (ADTs) as `Data` objects in Plutus Core such that they become _data-backed_
types. The `PlutusLedgerApi.Data.V3` module already contains the <span style="color: purple;">ScriptContext</span>
in the form of a _data-backed_ type. Also, one can look at the
[Simplifying code before compilation](https://plutus.cardano.intersectmbo.org/docs/working-with-scripts/simplifying-before-compilation)
and [Other optimization techniques](https://plutus.cardano.intersectmbo.org/docs/working-with-scripts/other-optimization-techniques) guidelines.

We state the various possibilities that a redeemer can be used for
in smart contracts:

* Indicating the purpose of interacting with a script, e.g., placing a bet,
paying a fee, or claiming a reward
* Providing information known only to a specific party, which can be used
to unlock funds held at a script address
* Supplying a value that modifies the current datum value.

Finally, we show the code for generating Plutus blueprints for two of the
six validators we have defined in this lesson to shorten the code. We choose
the gift validator and the untyped 42 validator that generates a small CBOR.

```haskell
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DerivingStrategies    #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE UndecidableInstances  #-}

module Main where

import qualified Data.ByteString.Short       as Short
import qualified Data.Set                    as Set
import           PlutusTx.Blueprint
import qualified Week02.Validators           as Week02

{- ------------------------------------------------------------------------------ -}
{- --------------------------------- ENTRY POINT -------------------------------- -}

main :: IO ()
main = writeBlueprint "blueprint.json" blueprint

{- ------------------------------------------------------------------------------ -}
{- ------------------------------------- SHARED --------------------------------- -}

blueprint :: ContractBlueprint
blueprint =
  MkContractBlueprint
    { contractId = Just "plutus-pioneer-program"
    , contractPreamble = preamble
    , contractValidators =
        Set.fromList
          [ mkGiftVal
          , mk42ValSmall
          ]
    , contractDefinitions =
        deriveDefinitions
          @[ ()
           , Integer
           ]
    }

preamble :: Preamble
preamble =
  MkPreamble
    { preambleTitle = "Plutus Pioneer Program Blueprint"
    , preambleDescription = Just "Blueprint for the Plutus Pioneer Program validators"
    , preambleVersion = "1.0.0"
    , preamblePlutusVersion = PlutusV3
    , preambleLicense = Just "MIT"
    }
```

We first define all language pragmas and import the necessary modules, including the
`Week02.Validators` module, where we have defined our validators from this lesson.
In the <span style="color: blue;">main</span> function, we write the blueprint to a `JSON` file, and after
that, the blueprint definition. It contains the contract ID, the preamble
that defines some general information, the contract validators, defined next,
and the contract definitions. The definitions include a list of types
that we have used in the validator code. After that, we see the <span style="color: blue;">preamble</span>
definition. Next, we show the validator blueprint
definitions for two validators that we have chosen.

```haskell
{- ------------------------------------------------------------------------------ -}
{- ----------------------------- VALIDATORS - WEEK02 ---------------------------- -}

mkGiftVal :: ValidatorBlueprint referencedTypes
mkGiftVal =
  MkValidatorBlueprint
    { validatorTitle = "Always True Validator"
    , validatorDescription = Just "Validator that always returns True (always succeeds)"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the always true validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @()
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Week02.serializedMkGiftValidator
    }

mk42ValSmall :: ValidatorBlueprint referencedTypes
mk42ValSmall =
  MkValidatorBlueprint
    { validatorTitle = "42 Validator untyped - small CBOR"
    , validatorDescription = Just "Validator that returns true only
                                   if the redeemer is 42"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the 42 validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @Integer
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Week02.serializedMk42ValidatorSmall
    }
```

For every validator we can use boilerplate code to define a blueprint. The
blueprint defines the validator title, description, parameters that are defined
if we have a parameterized validator, redeemer information, datum information,
and the compiled code, which we reference from the `Week02.Validators` module
that we have imported. One can extend the blueprint code such that it generates
the data and compiled code for all six validators that we defined in this lesson.
All validators presented in this module can be found in the _code/_
folder of this module, which also contains a `blueprint.json` file
with all compiled validator code. Below is an example blueprint for the blueprint
code we have defined in this lesson. The compiled validator code is contained in
the `"compiledCode"` fields.

```json
{
  "$id": "plutus-pioneer-program",
  "$schema": "https://cips.cardano.org/cips/cip57/schemas/plutus-blueprint.json",
  "$vocabulary": {
    "https://cips.cardano.org/cips/cip57": true,
    "https://json-schema.org/draft/2020-12/vocab/applicator": true,
    "https://json-schema.org/draft/2020-12/vocab/core": true,
    "https://json-schema.org/draft/2020-12/vocab/validation": true
  },
  "preamble": {
    "title": "Plutus Pioneer Program Blueprint",
    "description": "Blueprint for the Plutus Pioneer Program validators",
    "version": "1.0.0",
    "plutusVersion": "v3",
    "license": "MIT"
  },
  "validators": [
    {
      "title": "Always True Validator",
      "description": "Validator that always returns True (always succeeds)",
      "redeemer": {
        "title": "Redeemer",
        "description": "Redeemer for the always true validator",
        "purpose": {
          "oneOf": [
            "spend",
            "mint",
            "withdraw",
            "publish"
          ]
        },
        "schema": {
          "$ref": "#/definitions/Unit"
        }
      },
      "compiledCode": "450101002499",
      "hash": "acec2df7c07075dc7618ffc17c4d86aa786509e646057bd2bdab4cfc"
    },
    {
      "title": "42 Validator untyped - small CBOR",
      "description": "Validator that returns true only if the redeemer is 42",
      "redeemer": {
        "title": "Redeemer",
        "description": "Redeemer for the 42 validator",
        "purpose": {
          "oneOf": [
            "spend",
            "mint",
            "withdraw",
            "publish"
          ]
        },
        "schema": {
          "$ref": "#/definitions/Integer"
        }
      },
      "compiledCode": "581e010100255333573466e1d2054375a6ae84d5d11aab9e3754002229308b01",
      "hash": "6828334183fe0deb5576416c73448fdf40cf1c158195b8a24fe9bc45"
    }
  ],
  "definitions": {
    "Integer": {
      "dataType": "integer"
    },
    "Unit": {
      "dataType": "constructor",
      "fields": [],
      "index": 0
    }
  }
}
```

We also show the `cabal.project` and `.cabal` files we use to compile the code.
Let's look at the `cabal.project` file.

```haskell
repository cardano-haskell-packages
  url: https://chap.intersectmbo.org/
  secure: True
  root-keys:
    3e0cce471cf09815f930210f7827266fd09045445d65923e6d0238a6cd15126f
    443abb7fb497a134c343faf52f0b659bd7999bc06b7f63fa76dc99d631f9bea1
    a86a1f6ce86c449c46666bda44268677abf29b5b2d2eb5ec7af903ec2f117a82
    bcec67e8e99cabfa7764d75ad9b158d72bfacf70ca1d0ec8bc6b4406d1bf8413
    c00aae8461a256275598500ea0e187588c35a5d5d7454fb57eac18d9edb86a56
    d4a35cd3121aa00d18544bb0ac01c3e1691d618f462c46129271bccf39f7e8ee

index-state:
  -- Bump both the following dates if you need newer packages from Hackage
  , hackage.haskell.org 2024-09-10T13:49:28Z
  -- Bump this if you need newer packages from CHaP
  , cardano-haskell-packages 2024-09-10T13:49:28Z

packages:
  ./.
```

In the file, we define the
[CHAP repository](https://github.com/IntersectMBO/cardano-haskell-packages)
that contains all Haskell packages used by Cardano that are not hosted on
[Hackage](https://hackage.haskell.org/), the Haskell community's central package
archive. When compiling the project, the `cabal` tool can then
download the Plutus packages defined in the `.cabal` file. Next, we look at the
`.cabal` file.

```haskell
cabal-version:   3.0
name:            plinth-plutusV3
version:         0.1.0.0
license:
build-type:      Simple
extra-doc-files: README.md

common options
  ghc-options: -Wall
  default-language: Haskell2010

library scripts
  import:         options
  hs-source-dirs: src
  exposed-modules:
    Week02.Validators

  build-depends:
    , base
    , plutus-core        ^>=1.34
    , plutus-ledger-api  ^>=1.34
    , plutus-tx          ^>=1.34

  if !(impl(ghcjs) || os(ghcjs))
    build-depends: plutus-tx-plugin

executable gen-blueprint
  import:           options
  hs-source-dirs:   app
  main-is:          GenBlueprint.hs
  build-depends:
    , base
    , bytestring
    , containers
    , plutus-core ^>=1.34.0.0
    , plutus-ledger-api ^>=1.34.0.0
    , plutus-tx ^>=1.34.0.0
    , plutus-tx-plugin ^>=1.34.0.0
    , scripts
```

In `.cabal`, we define our compiler options, the library where our validator
code resides, and the build dependencies that list Plutus packages needed by our validator
code. At the end, we define the executable project, which tells Cabal which file is the
entry point for compiling the project, and we also list the build dependencies. We name
the file with the code for generating blueprints `GenBlueprint.hs`. Our project should
be structured in the following way:

```console
.
├── app
│   └── GenBlueprint.hs
├── src
│   └── Week02
│       └── Validators.hs
├── cabal.project
├── validators.cabal
└── blueprint.json
```

The `blueprint.json` file will only be there after we have compiled the project.
We can do this by running the following commands from the top of our project directory:

```console
cabal update
cabal run
```

At the end, we note that the `.cabal` file shown here lists all Plutus libraries
needed to compile any Plutus code presented in the Plinth module.
It can be reused when compiling code from other lessons that follow this one.
One only needs to add the module names under the `exposed-modules:`
section and update the `GenBlueprint.hs` file with additional blueprint
definitions. As already mentioned, all Plinth validator code presented in this
module, including blueprint and cabal configuration files, can be found at the
_code/_ folder of the Plinth module.
