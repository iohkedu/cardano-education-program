# Setting up a Plinth development environment

For your development environment, you can use one of the following
options:

- Run a Nix shell that contains all the dependencies
- Run a local Docker container inside VSCode
- Use an online platform such as [Demeter.run](https://demeter.run/)
- Install system dependencies manually.

The [plinth-template](https://github.com/IntersectMBO/plinth-template/tree/main)
GitHub repository provides instructions for the above mentioned options.
The smart contract code presented throughout this module uses features
introduced in the Chang hard fork, which enabled PlutusV3. The
development environment you will use to run and test this code needs to
support these features. The smart contract code was compiled with a Nix
shell. Nix version `2.25.3` was used and a Nix shell provided by the
[plinth-template](https://github.com/IntersectMBO/plinth-template)
repository, commit `b9460088985331bb050f1782a32e4f92c4c00e67`.

The [Demeter.Run](https://demeter.run/) online platform offers various
tools and development environments for the Cardano ecosystem. One can
set up development environments for smart contract languages such as
Plinth and Aiken. Also, programming languages like Rust or Python, that
come with useful Cardano tools and libraries are available. The platform
offers backend hosting for DApps and allows integration testing within
its environments. It manages monitoring, security, and version upgrades.
Depending on development needs, the platform provides various starter
kits, including example code repositories from the community for
learning or project initiation. Its pricing model is based on service
usage, with users also able to access some free working time. Explore
also *Developer Tools* and *Infrastructure* sections on the [Cardano
developer map](https://www.cardanocube.com/cardano-ecosystem-interactive-map) for
more options.

To query various Plutus types, one can use the official [Plutus Haddock
documentation](https://plutus.cardano.intersectmbo.org/haddock/latest/),
which presents types in Haskell syntax. Press CTRL + S to search for a
keyword, such as a specific data type or function name. The search
engine might provide more options for a single data type, function or
type class you are querying. This is because implementations of types,
functions, and type classes can change with a new Plutus version and the
Haddock documentation keeps track of all of them. After locating the
desired item, click the *Source* icon next to its name to open the
corresponding Haskell source code. The software packages for the
libraries documented in the Plutus Haddock documentation are distributed
via the [Cardano Haskell package
repository](https://github.com/IntersectMBO/cardano-haskell-packages)
(CHaP), which contains packages not hosted on
[Hackage](https://hackage.haskell.org/) – the central archive for
Haskell packages. Other compiled languages provide their own libraries
that implement Plutus types. One example is the Aiken [standard
library](https://aiken-lang.github.io/stdlib/).

Plinth data types cannot be explored in the standard GHCi REPL. The GHC
compiler pipeline first compiles Plinth code to an intermediate language
called GHC Core. The Plutus compiler then takes this GHC Core and with
some intermediate steps compiles it to Untyped Plutus Core (UPLC).
Additionally, the Plinth libraries are not hosted on Hackage, which
means the only way to query Plinth types from a REPL is to build it with
a Cabal file that imports those libraries.
