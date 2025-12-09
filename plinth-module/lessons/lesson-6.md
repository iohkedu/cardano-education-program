# Off-chain code with MeshJS

The blockchain is passive – it only acts when a user interacts with it.
The code that queries the blockchain, builds, and submits transactions
is called off-chain code. Off-chain code does not need to have the same
performance and security standards as on-chain code. In this lesson,
we will showcase how to write off-chain code for the on-chain code example
presented in the previous lesson.

After the Alonzo era, when smart contracts became available on Cardano,
the [Plutus application platform](https://github.com/IntersectMBO/plutus-apps)
provided a way to write off-chain code.
Developed by IO and implemented as a set of Haskell libraries, it
allowed users to write and submit transactions using the Contract monad.
A single Haskell file could contain on- and off-chain code.
Currently, the platform is in maintenance mode and no longer under
active development.

Another way for constructing off-chain transactions is by using the
[Cardano CLI](https://github.com/IntersectMBO/cardano-cli). You can
find examples and read more about the Cardano CLI on the
[Cardano developers](https://developers.cardano.org/docs/get-started/cardano-cli/basic-operations/get-started)
webpage. There are also several community-built tools for writing off-chain code in
various programming languages. Some of them are: 

* [Blockfrost SDK](https://blockfrost.dev/sdks): enables access to the
Blockfrost API layer for Cardano. The SDK is provided in various
programming languages such as Arduino, .NET, Crystal, Elixir, Go,
Haskell, Java, JavaScript, Kotlin, PHP, Python, Ruby, Rust, Scala, and
Swift.
* [MeshJS](https://meshjs.dev/): a NodeJS-based open-source library
providing numerous tools to easily build DApps on Cardano. It also
integrates the popular [React](https://react.dev/) library.
* [Lucid](https://lucid.spacebudz.io/): a popular JavaScript/TypeScript
library for off-chain code, which is further developed by the
[Lucid Evolution](https://anastasia-labs.github.io/lucid-evolution/)
project.
* [Atlas](https://atlas-app.io/): an all-in-one, Haskell-native
application backend for writing off-chain code for Plutus smart
contracts.

Explore other Cardano tools that can be used for building DApps at:

* The [Builder Tools](https://developers.cardano.org/tools/) page on the
Cardano Developer portal. You can filter the tools by language/technology
or by domain. Every tool contains a short description.
* The Cardano community-built
[developer tools](https://www.essentialcardano.io/article/a-list-of-community-built-developer-tools-on-cardano) list hosted on Essential Cardano.

This lesson showcases the [MeshJS](https://meshjs.dev/) tool, developed by
the [Mesh team](https://meshjs.dev/about). It can be used as a NodeJS package
to construct and submit transactions interacting with a smart contract by
writing JavaScript or TypeScript code. To run the off-chain code in this and
other lessons, you can use [Deno](https://deno.com/) – which is a runtime
environment for JavaScript and TypeScript. All off-chain code presented in
this lesson was tested with Deno version `2.1.9` and
MeshSDK packages version `1.9.0-beta.3`. To install the MeshSDK packages
that are needed by the off-chain code, the
[npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
package manager for the Node.js JavaScript runtime environment
can be used. To specify a package version, one can create the `package.json`
file before installing the packages. Below is an example of this file.

```json
{
  "dependencies": {
    "@meshsdk/core": "1.9.0-beta.3",
    "@meshsdk/common": "1.9.0-beta.3",
    "@meshsdk/core-cst": "1.9.0-beta.3",
    "deno": "2.1.9" }
}
```

The package that installs other MeshSDK packages required by
our code is `@meshsdk/core`. The official
[npm page](https://www.npmjs.com/package/@meshsdk/core) for this package
lists the MeshSDK packages that will get installed as dependencies.
To install all MeshJS packages locally, `cd` to the root location of your
project, create the `package.json` file, and run:

```console
npm install @meshsdk/core
```

If no `package.json` file is present, `npm` will create one and install
the latest version of MeshSDK packages. For more information on how to
install npm packages and manage the `package.json` file, you can read the
[Getting packages from the registry](https://docs.npmjs.com/packages-and-modules/getting-packages-from-the-registry) and
[Creating a package.json file](https://docs.npmjs.com/creating-a-package-json-file)
npm documentation pages. The `deno` tool can be
installed globally. From the location of the `package.json` file run:

```console
npm install -g deno
```

Let us look now at off-chain code that interacts with the vesting smart
contract `vestingVal` that we defined in the previous lesson. Our code
will reside in a TypeScript file to leverage some of the type system's features.

```typescript
import {
    BlockfrostProvider,
    MeshWallet,
    Transaction,
    PlutusScript,
    resolvePlutusScriptAddress,
    applyCborEncoding,
    deserializeAddress,
    resolveSlotNo,
    mConStr0,
    Action
  } from "@meshsdk/core";
import { UTxO } from "@meshsdk/common";
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
```

First, we import the necessary components from the `@meshsdk/core` and
the `@meshsdk/common` libraries. Then we import the seed phrase of our
Cardano wallet. The `seed.ts` file should be in the following format:

```typescript
export const secretSeed = ["seed1", "seed2", ... ];
```

For instructions on how to create a wallet and generate a seed phrase, see
[lesson 2](https://github.com/iohkedu/cardano-education-program/blob/main/lace-course/lessons/02-installing-lace/README.md)
of the Lace module that showcases how to install a Lace wallet and generate
a seed phrase. For more information on wallets check out the chapter
[Cardano digital wallets](https://github.com/input-output-hk/mastering-cardano/blob/main/chapters/chapter-06-wallets-in-the-world-of-cardano.adoc) from the Mastering Cardano book.

Next, we define a provider to help us query the blockchain and
submit transactions. We use [BlockFrost](https://blockfrost.io/). For the
code to work, one has to provide their BlockFrost key, which users can get
for free at the official website. The key is tied to a specific network
(mainnet, preprod, preview, or SanchoNet). The off-chain code we will
present in this and other lessons was tested on the _preview_ network.
There is a daily limit of how many requests a user can make with a free
BlockFrost account. At the time of writting, it is set to 50.000.
One can also pick another provider. MeshJS can connect to various
providers. Examples can be found at the MeshJS
[Providers](https://meshjs.dev/providers) documentation page.

After defining our provider, we initiate a Mesh wallet where we
input the provider and our secret seed. We also define on which network
we will work (zero stands for testnet, which is both preview or preprod).
Mesh also allows providing the key in other forms. One can define the
type of the key as `"root"` and then provide the root key in `bech32`
format. Another option is to define the type of key as `"cli"`
and then provide the payment and staking keys. To see all options,
you can look at the source code in the official mesh GitHub repository
that defines the
[MeshWallet](https://github.com/MeshJS/mesh/blob/main/packages/mesh-wallet/src/mesh/index.ts)
class. Next we read out some wallet information and define our vesting
script.

```typescript
// Define address and its public key hash
const walletAddress: string = await wallet.getChangeAddress();
const signerHash: string = deserializeAddress(walletAddress).pubKeyHash;

// Set the vesting deadline
const deadlineDate: Date = new Date("2025-03-05T12:30:10Z")
const deadlinePOSIX: bigint = BigInt(deadlineDate.getTime());

// Defining our vesting script
const vestingScript: PlutusScript = {
    code: applyCborEncoding("590ed20101003232323232323232323232323232259..."),
    version: "V3"
};
const vestingAddr: string = resolvePlutusScriptAddress(vestingScript, 0);
```

First, we define the wallet address and the public key hash that
belongs to that address. We will set the beneficiary to our own
public key hash so we can claim the funds back ourselves. Then we define
the deadline, which sets the time after which the funds can be claimed
from the script address. We set the time in ISO UTC format and then
convert it to `POSIX` time in milliseconds.

After defining our data that we will attach in the datum, we can
define our vesting script and compute the address of this script. We
note that we have to apply the function <span style="color: blue;">applyCborEncoding</span> that
takes the raw script `CBORHEX` from the blueprint and formats it in
the correct way. The compiled code in our code snippet is shortened.
When running this off-chain code, the full compiled code of the validator
has to be provided. That can be found in the `blueprint.json` file in the
_code/_ folder of this module. Now we can send some funds to the vesting script.

```typescript
// Function for creating UTXO at vesting script
async function sendFunds(amount: string): Promise<string> {
    const tx = new Transaction({ initiator: wallet })
        .setNetwork("preview")
        .sendLovelace(
        { address: vestingAddr,
          datum: {value: mConStr0([signerHash, deadlinePOSIX]), inline: true }},
        amount)
        .setChangeAddress(walletAddress);

    const txUnsigned = await tx.build();
    const txSigned = await wallet.signTx(txUnsigned);
    const txHash = await wallet.submitTx(txSigned);
    return txHash
}
```

The <span style="color: blue;">sendFunds</span> function takes an amount of lovelace provided as a string,
and creates a transaction that sends the specified amount to the vesting
script address. When creating a transaction, we use the <span style="color: purple;">Transaction</span>
class where we provide our wallet as initiator. Then we set the network.
The Mesh source code states that setting the network is mainly used to know the
cost models to be used to calculate script integrity hash. After that we
use the <span style="color: blue;">sendLovelace</span> function, where we specify our script address,
the datum that we want to attach, if we want to inline it, and in the end
the amount we want to send. We create the datum with the <span style="color: blue;">mConStr0</span>
function that helps us to create a Mesh Data index 0 constructor object.
At the end of the transaction we set the change address to our address – which
means that the lovelace change amount of the UTXOs we will spend will go back
to our wallet. Once we have our transaction we build it, sign it, and submit it.
The <span style="color: blue;">sendFunds</span> function in the end then returns the transaction hash
of the submitted transaction.

Let us look again at the custom vesting data type we use in our validator code:

```haskell
data VestingDatum = VestingDatum
  { beneficiary :: PubKeyHash
  , deadline    :: POSIXTime
  }
  deriving stock (Generic)
  deriving anyclass (HasBlueprintDefinition)

makeIsDataSchemaIndexed ''VestingDatum [('VestingDatum, 0)]
```

We imagine for a moment that we define the above data type as an algebraic
sum data type so it flips the order of the arguments for the second
data constructor.

```haskell
data VestingDatumMix = VestingDatum1 { beneficiary1 :: PubKeyHash,
                                       deadline1 :: POSIXTime }
                     | VestingDatum2 { deadline2 :: POSIXTime,
                                       beneficiary2 :: PubKeyHash }
                     deriving stock (Generic)
                     deriving anyclass (HasBlueprintDefinition)

makeIsDataSchemaIndexed ''VestingDatumMix [('VestingDatum1, 0), ('VestingDatum2, 1)]
```

When we make the data schema, we then assign the numbers zero and one to the data
constructors in the same order we have defined them. Now that we have our datum
type, we can modify our validator so it can work with this type.

```haskell
{-# INLINEABLE vestingValMix #-}
vestingValMix :: ScriptContext -> Bool
vestingValMix ctx =
  traceIfFalse "Is not the beneficiary" checkBeneficiary
    && traceIfFalse "Deadline not reached" checkDeadline
 where
  checkBeneficiary :: Bool
  checkBeneficiary = txSignedBy info beneficiaryMix

  checkDeadline :: Bool
  checkDeadline = from deadlineMix `contains` txInfoValidRange info

  vestingDatum :: VestingDatumMix
  vestingDatum = case scriptContextScriptInfo ctx of
    SpendingScript _txRef (Just datum) ->
      case (fromBuiltinData @VestingDatumMix . getDatum) datum of
        Just d  -> d
        Nothing -> traceError "Expected correctly shaped datum"
    _ -> traceError "Expected SpendingScript with datum"

  variables :: (PubKeyHash, POSIXTime)
  variables@(beneficiaryMix, deadlineMix) = case vestingDatum of
    VestingDatum1 b d  -> (b, d)
    VestingDatum2 d b  -> (b, d)

  info :: TxInfo
  info = scriptContextTxInfo ctx
```

If we construct a transaction that creates a UTXO at the script address
of the above script, we now have two options to attach the datum. In the
case of the <span style="color: purple;">VestingDatum1</span> data constructor, we would attach
the datum the same way we have shown in the <span style="color: blue;">sendFunds</span> function. For
the second case, if we would want to provide the datum as the second option where
the arguments are flipped, we would do that thus:

```typescript
mConStr1([deadlinePOSIX, signerHash])
```

Notice that, besides flipping the arguments, we use now the function <span style="color: blue;">mConStr1</span>
instead of <span style="color: blue;">mConStr0</span>. With it, we create a Mesh Data index one constructor object
that corresponds to the second data constructor <span style="color: purple;">VestingDatum2</span>. If our vesting
type would have a third data constructor, we could use the function <span style="color: blue;">mConStr2</span>.
The MeshJS library currently provides these functions up to <span style="color: blue;">mConStr3</span>.

Next we define the functions needed to claim the vested funds.

```typescript
// Returns a UTXO at a given address that contains the given transaction hash
async function getUtxo(scriptAddress: string, txHash: string): Promise<UTxO> {
const utxos = await provider.fetchAddressUTxOs(scriptAddress);
    if (utxos.length == 0) {
        throw 'No listing found.';
    }
    let filteredUtxo = utxos.find((utxo: any) => {
        return utxo.input.txHash == txHash;
    })!;
    return filteredUtxo
}

// Function for claiming funds
async function claimFunds(txHashVestedUTXO: string): Promise<string> {
    const assetUtxo: UTxO = await getUtxo(vestingAddr, txHashVestedUTXO);
    const redeemer: Pick<Action, "data"> = { data: { alternative: 0, fields: [] } };
    const slot: string = resolveSlotNo('preview', Date.now() - 40000);

    const tx = new Transaction({ initiator: wallet, fetcher: provider })
        .setNetwork("preview")
        .redeemValue({ value: assetUtxo,
                       script: vestingScript,
                       redeemer: redeemer})
        .setTimeToStart(slot)
        .sendValue(walletAddress, assetUtxo)
        .setRequiredSigners([walletAddress]);

    const txUnsigned = await tx.build();
    const txSigned = await wallet.signTx(txUnsigned);
    const txHash = await wallet.submitTx(txSigned);
    return txHash
}

// Function calls
//console.log(await sendFunds("5000000"));
//console.log(await claimFunds("<txHash>"));
```

First, we define the <span style="color: blue;">getUtxo</span> function. It takes in a script address
and a transaction hash both of type <span style="color: purple;">string</span>. It then checks if,
at the given address, a UTXO exists that contains the provided transaction
hash and then returns this UTXO. After that we define our function for
claiming funds from the vesting script address.

The <span style="color: blue;">claimFunds</span> function takes in a transaction hash, which should
correspond to the UTXO we want to claim at the vesting address. We then
first look up that UTXO. Then we define an empty redeemer. We note that
if the redeemer would need to represent a custom data type that has more
than one data constructor, we would state which data constructor we are
using with the number provided in the `"alternative:"` field, and we
would input the actual data in the list that follows the `"fields:"`
keyword. If the redeemer does not represent a custom data type,
but rather a Plutus supported type as eg an <span style="color: purple;">Integer</span>, we would define the redeemer as:

```typescript
const redeemer: Pick<Action, "data"> = { data: BigInt(42) };
```

The number is, of course, code specific. You can find off-chain code for
the 42 validator example we have presented in a previous lesson in the _code/_
folder of this module. For more examples see the MeshJS resources listed at
the end of this lesson.

After defining the redeemer, we define the start slot for
the transaction. We use the <span style="color: blue;">resolveSlotNo</span>, which takes in the
network we work on and a timestamp in milliseconds. We use the
current time and subtract 40.000 milliseconds. Then we define our
transaction. We first set the network and then use the <span style="color: blue;">redeemValue</span>
function to redeem our vested UTXO. It takes in the UTXO we want to
redeem, the script at which the UTXO is residing, and the redeemer.
The redeemer is optional and could be skipped. The same goes for
the datum, which we haven't provided here because we have inlined
the datum to the UTXO we are claiming.

Next, we set the validity interval for the transaction with the
<span style="color: blue;">setTimeToStart</span> function. We provide the slot we have previously
defined and the function sets the validity interval from this slot
onwards to infinity. There is also a <span style="color: blue;">setTimeToExpire</span> function
that sets the time until which slot the transaction is still considered valid.
After that, we define that the lovelace carried by our vested UTXO should
go to our own address. Finally, we add the required signers for
the transaction and enter our own wallet address that is linked
with the public key hash we have set in the datum of the vested UTXO.

Once we have created our transaction, we again have to build it,
sign it, and submit it. Then we return the transaction hash. At the
end, we define the function calls for the <span style="color: blue;">sendFunds</span> function
that we call with five ada, and the <span style="color: blue;">claimFunds</span> function that
we call with the transaction hash the previous function call returns
and gets logged to the console. For a user to test this code, one
should first uncomment the first function call and run the code.
After the transaction is successfully submitted, we comment
the first command again, copy the logged transaction hash to the second
command, uncomment it, and run the code again. If we name our file
that contains the off-chain code `vesting.ts`, we can run the code
with the command below.

```console
deno run -A vesting.ts
```

After the transactions completes, the transaction hash is shown in the
console and can be used to check transaction details on the
[preview.cardanoscan.io](http://preview.cardanoscan.io/) webpage.

Now that we have seen the off-chain code for the vesting validator,
we can also look at the off-chain code that works with the parameterized vesting
validator `paramVestingVal` that we have also defined in the previous lesson.

```typescript
import {
    BlockfrostProvider,
    MeshWallet,
    Transaction,
    PlutusScript,
    resolvePlutusScriptAddress,
    applyCborEncoding,
    deserializeAddress,
    resolveSlotNo,
    Data,
    MeshTxBuilder,
    Action
  } from "@meshsdk/core";
import { applyParamsToScript } from "@meshsdk/core-cst";
import { UTxO } from "@meshsdk/common";
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
```

We first define the list of imports, which in addition contains the
<span style="color: purple;">Data</span> type, <span style="color: purple;">MeshTxBuilder</span> class and the <span style="color: blue;">applyParamsToScript</span>
function. Then we define our blockchain provider and initialize our wallet.
Next, we define the vesting parameters and scripts we will use.

```typescript
// Define address and public key hash of the wallet
const walletAddress: string = await wallet.getChangeAddress();
const beneficiaryPKH: string = deserializeAddress(walletAddress).pubKeyHash;

// Set the vesting deadline
const deadlineDate: Date = new Date("2025-03-05T12:30:10Z")
const deadlinePOSIX: bigint = BigInt(deadlineDate.getTime());

// Defining the parameter for the script
const scriptParameter: Data = { alternative: 0, fields: [beneficiaryPKH, deadlinePOSIX] };

// Defining our vesting script
const vestingParamScript: PlutusScript = {
    code: applyParamsToScript(
            applyCborEncoding("590e3801010032323232323232323232323232322259..."),
            [scriptParameter]),
    version: "V3"
};
const vestingParamAddr: string = resolvePlutusScriptAddress(vestingParamScript, 0);

// Defining burn address
const burnScript: PlutusScript = {
    code: applyCborEncoding("450101002601"),
    version: "V3"
};
const burnAddr: string = resolvePlutusScriptAddress(burnScript, 0);
```

As before, we define our wallet address, public key hash, and
the deadline in POSIX milliseconds time. Then we define the script parameter
that we will apply to the parameterized script and that contains our own
public key hash and the deadline we have defined. Next we define our
parameterized vesting script. We again shorten the `CBORHEX` compiled
code. The full compiled code can be found in the `blueprint.json` file that
resides in the _code/_ folder of this module.
We now use the function <span style="color: blue;">applyParamsToScript</span> and add the
script parameter we have previously defined. If there were more
than one parameter, we would enter all of them in the list in the
correct order. Then we compute the script address. We also define
the burn script, from which no funds can be retrieved. The reason for
this is that we will later show in the code how to deploy our vesting
script to a UTXO that we create at the burn script. And we will then
reference the script from that UTXO when claiming our vested funds.
Next, we can send some funds to the parameterized vesting script.

```typescript
// Function for creating UTXO at vesting script
async function sendFunds(amount: string): Promise<string> {
    const tx = new Transaction({ initiator: wallet })
        .setNetwork("preview")
        .sendLovelace({ address: vestingParamAddr }, amount)
        .setChangeAddress(walletAddress);

    const txUnsigned = await tx.build();
    const txSigned = await wallet.signTx(txUnsigned);
    const txHash = await wallet.submitTx(txSigned);
    return txHash
}
```

We define the <span style="color: blue;">sendFunds</span> function similar to the previous
vesting example. The difference is that this time we don't specify a
datum in the <span style="color: blue;">sendLovelace</span> function. This means we will create
a UTXO without a datum. After that, we can deploy our parameterized
vesting script to a UTXO.

```typescript
// Deploy a reference script
async function deployRefScript(lovelaceAmount: string): Promise<string> {
    const utxos = await wallet.getUtxos();
    const txBuilder = new MeshTxBuilder({
      fetcher: provider
    });

    const unsignedTx = await txBuilder
      .txOut(burnAddr, [{ unit: "lovelace", quantity: lovelaceAmount }])
      .txOutReferenceScript(vestingParamScript.code, vestingParamScript.version)
      .changeAddress(walletAddress)
      .selectUtxosFrom(utxos)
      .complete();

    const signedTx = await wallet.signTx(unsignedTx);
    const txHash = await wallet.submitTx(signedTx);
    return txHash
}
```

The <span style="color: blue;">deployRefScript</span> function takes in a lovelace amount in the form of a
string that will be used to deploy the reference script. First we look
up the UTXO at our wallet. Then we define a transaction builder that we
will use to build the transaction. After that, we define our transaction.
We first specify that we want to deploy our vesting script at the burn
address and the amount of lovelace we will spend. Then we specify the
parameterized script we want to deploy and its Plutus version. After
that we define our change address and from which UTXOs we want to
select our funds. We complete the transaction, sign, submit it,
and return the transaction hash. Next, we can define our functions
for claiming the vested funds.

```typescript
// Returns a UTXO at a given address that contains the given transaction hash
async function getUtxo(scriptAddress: string, txHash: string): Promise<UTxO> {
    const utxos = await provider.fetchAddressUTxOs(scriptAddress);
    if (utxos.length == 0) {
        throw 'No listing found.';
    }
    let filteredUtxo = utxos.find((utxo: any) => {
        return utxo.input.txHash == txHash;
    })!;
    return filteredUtxo
}

// Function for claiming funds
async function claimFunds(txHashVestedUTXO: string,
                          txHashRefUTXO: string): Promise<string> {
    const assetUtxo: UTxO = await getUtxo(vestingParamAddr, txHashVestedUTXO);
    const refScriptUtxo: UTxO = await getUtxo(burnAddr, txHashRefUTXO);
    const redeemer: Pick<Action, "data"> = { data: { alternative: 0, fields: [] } };
    const slot: string = resolveSlotNo("preview", Date.now() - 40000);

    const tx = new Transaction({ initiator: wallet, fetcher: provider })
        .setNetwork("preview")
        .redeemValue({ value: assetUtxo,
                       script: refScriptUtxo,
                       redeemer: redeemer})
        .setTimeToStart(slot)
        .sendValue(walletAddress, assetUtxo)
        .setRequiredSigners([walletAddress]);

    const txUnsigned = await tx.build();
    const txSigned = await wallet.signTx(txUnsigned);
    const txHash = await wallet.submitTx(txSigned);
    return txHash
}

// Function calls
//console.log(await sendFunds("3000000"));
//console.log(await deployRefScript("20000000"));
//console.log(await claimFunds("<tx-hash>", "<tx-hash>"));
```

The <span style="color: blue;">getUtxo</span> function is defined the same way as in our previous off-chain
code example. The <span style="color: blue;">claimFunds</span> function is defined in a similar way
as in the previous code. It takes in the transaction hash of our
UTXO we have vested at the script, and also the transaction
hash of the UTXO that contains our deployed vesting script. In the body
of the function, we first define our UTXO that we want to claim. Then
we define the UTXO that contains our script. After that we again define
the redeemer and slot, as in the previous off-chain code.

The transaction to claim the funds is also structured similarly
to the previous example. The only difference is that now the <span style="color: blue;">redeemValue</span>
function takes in the reference UTXO that contains the parameterized vesting
script instead of the actual script. We again set the validity interval
and the required signature to the transaction. After that we build, sign,
and submit the transaction and return the transaction hash.

At the end, we define the function calls by logging their return values.
We send three ada to the parameterized vesting script. Then we deploy the
script to the burn address and use 20 ada for that. The amount cannot
be too low and depends on the script size we are deploying. Lastly, we
claim the funds. There we have to enter the transaction hashes that the
previous two function calls returned. As in our previous off-chain code
example, we have to uncomment only one line at a time and execute the
code. If we name our file `vesting-param.ts` we can again execute it
with Deno as:

```console
deno run -A vesting-param.ts
```

We can again check the transaction details by entering the hashes at the
[preview.cardanoscan.io](http://preview.cardanoscan.io/) webpage.

We note that the reason that it would make sense to deploy a script to
an unredeemable UTXO is that _referencing_ a script from a UTXO is cheaper
than _attaching_ it to the transaction. Of course, the upfront cost is
larger because we need to pay fees for deploying the script. So this
use case pays off if we need to reference this script many times, which
could be the case for a DApp. Also, if the UTXO is created at a script
address where funds are burned, it becomes unspendable and permanently
accessible.

We make an important distinction between off- and on-chain code.
Because Cardano uses the hard fork combinator technology, all Plutus
script versions are supported by the blockchain (read more in Mastering
Cardano section
[Consensus and storage layer](https://github.com/input-output-hk/mastering-cardano/blob/main/chapters/chapter-04-how-cardano-works/cardano-node-and-system-layers.adoc#consensus-and-storage-layer)). Once you have written on-chain code that works,
it will work indefinitely. That is _not_ the case for off-chain code.

Because the ledger rules can be updated, it can happen that conditions which
a transaction needs to fulfill may change. An example is the required ada fee
when attaching a reference script to a transaction. Some off-chain code libraries
may calculate this fee automatically. This calculation then holds true for a
specific Cardano era and may not work in future eras if blockchain parameters change.
For this reason, it is good practice to upgrade the off-chain code library versions
your code is using and test the code when upgrades to the Cardano ledger happen.

More information about MeshJS is available at:

* [MeshJS guides](https://meshjs.dev/guides)
* [MeshJS documentation](https://docs.meshjs.dev/)
* [MeshJS examples repository](https://github.com/MeshJS/examples/tree/main)
* [Mesh project based learning page](https://pbl.meshjs.dev/course/mesh)

In the next lesson, we show how to write a minting policy and off-chain code
that interacts with the policy.
