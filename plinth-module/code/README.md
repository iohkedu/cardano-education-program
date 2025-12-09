# Code for the Plinth module

This folder contains PlutusV3 validator code presented in the Plinth module.
The validator code is contained in the `src` folder.
The code in this branch can be compiled with a nix shell provided by the 
[plinth-template](https://github.com/IntersectMBO/plinth-template/tree/main) 
repository. Compilation was tested with Nix version `2.25.3` and `plinth-template`
repository commit: `b9460088985331bb050f1782a32e4f92c4c00e67`. 

Instructions how to setup a Plinth development environment with Nix, Docker or Demeter 
can be found at the [plinth-template](https://github.com/IntersectMBO/plinth-template/tree/main) 
repository. Once the environment is setup the validator code can be compiled with the 
following commands: 

```console
cabal update
cabal run 
```

The second command will generate the `blueprints.json` file that contains Plutus 
blueprints of this repository which include the compiled validator code. A compiled 
blueprint file is included in this folder. One can read more about Plutus blueprints 
in [CIP-57](https://cips.cardano.org/cip/CIP-57). 

## Off-chain code 

The off-chain code can be found in the `off-chain` folder. The code works on Cardano 
`preview` network. Comments in the code link the off-chain code to on-chain code and 
provide additional information. The code examples use two different libraries: 
[MeshJS](https://meshjs.dev/) and 
[Lucid Evolution](https://anastasia-labs.github.io/lucid-evolution/). Both libraries 
need to be installed together with [Deno](https://deno.com/), a runtime environment 
for JavaScript/TypeScript. 

The code was tested with Deno version `2.1.9`, MeshSDK package version `1.9.0-beta.3` 
and Lucid Evolution package version `0.4.22`. Use [npm](https://www.npmjs.com/) to install 
those packages. To fix a package version one can create the `package.json` file before 
installing the packages. Below is an example of this file: 

```console
{
  "dependencies": {
    "@meshsdk/core": "1.9.0-beta.3",
    "@meshsdk/common": "1.9.0-beta.3",
    "@meshsdk/core-cst": "1.9.0-beta.3",
    "@lucid-evolution/lucid": "0.4.22",
    "deno": "2.1.9"
  }
}
```

To run the off-chain code first create the `seed.ts` file that contains the seed of your 
test wallet. You can create a test wallet with [Lace](https://www.lace.io/) and fund it on test 
network with the [Cardano faucet](https://docs.cardano.org/cardano-testnets/tools/faucet). 
The wallet should have `ada` on `preview` network. The `seed.ts` file should contain the 
secret seed in the following form: 

* for MeshJS
```console
export const secretSeed = ["<seed1>", ..., "<seedN>"]
```
* for Lucid Evolution
```console
export const secretSeed = "<seed1> ... <seedN>"
```

Copy the `seed.ts` file into the folder from which you will run the off-chain code. The 
off-chain code uses the BlockFrost API. You will need to input a BlockFrost key for the 
preview network into the off-chain code instead of the `<blockfrost-key>` placeholder. 
One can get a free key at [BlockFrost](https://blockfrost.io/) web page when creating an 
account. 

After you have generated the seed and the API key, `cd` into the folder with the off-chain 
code you want to execute and run: 

```console
deno run -A <file_name>.ts
```
