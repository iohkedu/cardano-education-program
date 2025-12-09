# Plinth introduction and features

Cardano smart contract languages can be grouped into three categories:
* Native languages that run on the Cardano node
* Compiled languages that can be compiled to a native language
* Interpreted languages that are interpreted by a compiled language.

The Cardano node can only process native languages. Currently, there are two available: simple scripts and Untyped Plutus Core (UPLC). We refer to UPLC in short Plutus. Smart contract developers do not write code directly in Plutus. Instead, they use compiled or interpreted languages that are compiled into Plutus. The language developed by [Input | Output](https://iohk.io/) that compiles to Plutus is called Plinth, previously known as PlutusTx. Plinth is a Turing-complete subset of the [Haskell](https://www.haskell.org/) programming language.

Plutus scripts can be generated using Plinth, a GHC plug-in that runs during the GHC compilation process. It modifies the program that GHC is compiling however it likes. Under the hood, though, the compilation process is more complex. The image below shows the compilation process of the on-chain validation code.

<p align="center">
  <img src="images/01-01.png" alt="Plutus compilation pipeline" width="600" />
</p>

It is wise to break down compilation pipelines by introducing intermediate languages to ensure no step is too large, and to test each step independently. For more information about the compilation process, refer to this [IO blog](https://iohk.io/en/blog/posts/2021/02/02/plutus-tx-compiling-haskell-into-plutus-core/). The [Plutus](https://github.com/IntersectMBO/plutus) repository includes the Plinth compiler. 

Plinth lets developers build secure applications, forge new assets, and create smart contracts in a predictable, deterministic environment with the highest level of assurance. Furthermore, developers don't have to run a full Cardano node to test their work. The official [Plinth user guide](https://plutus.cardano.intersectmbo.org/docs/) provides developer-related information on Plutus and Plinth. 

## Other compiled smart contract languages

There are also other compiled smart contract languages developed by companies within the Cardano ecosystem. They are all domain-specific languages (DSL) as they target the smart contract domain. For a list of those languages see the 2024 [State of the Cardano Developer Ecosystem report](https://cardano-foundation.github.io/state-of-the-developer-ecosystem/2024/#what-do-you-use-or-plan-to-use-for-writing-plutus-script-validators-smart-contracts) that shows how much these languages are used in practice by developers. Languages that compile to Plutus generate scripts that have the same logic, but might be optimized differently for factors like size or performance. 

From the 2024 ecosystem report it is seen that Aiken is the most used Cardano smart contract language. Aiken is written in Rust and directly compiles to UPLC. It takes inspiration from many modern languages, such as Gleam, Rust, and Elm, which are known for friendly error messages and an overall excellent developer experience. It offers a more accessible and familiar syntax to developers, which makes it easy to learn. 

Aiken enables cost-efficient smart contract development and comes with a modern development environment that has a package manager, helpful error diagnostics, a language-server protocol (LSP) with auto-formatting, and popular editor integration (VSCode, NeoVim, Emacs). The language is well documented and offers a built-in testing framework that ensures proper and robust smart contract execution with property-based testing. Aiken's testing framework uses the same underlying virtual machine as in real smart contract execution, ensuring that memory consumption and contract behavior during testing are identical to those on the mainnet. To learn more about Aiken check out the [Further learning resources](https://github.com/iohkedu/cardano-education-program/tree/main/plinth-module/blob/main/lessons/learning-resources.md) section of this module.
