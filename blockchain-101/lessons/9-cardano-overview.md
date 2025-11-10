## Cardano overview

Cardano was founded by Ethereum co-founder Charles Hoskinson and Jeremy Wood, and was initially developed by [IOHK](https://iohk.io/) (now Input | Output). The project began in 2015, employing a research-driven and scientific approach to development – a philosophy that distinguishes it from most other blockchain projects.

Cardano’s development is based on five distinct development phases: 

* **Byron**  
Focused on **establishing the foundation** of the Cardano blockchain. This phase enabled the trade and transfer of ada, Cardano’s native cryptocurrency.

* **Shelley**  
Dedicated to decentralization. The network transitioned from a federated model to a distributed one, allowing users to stake their ada and participate in network consensus.

* **Goguen**  
Focused on the integration of **smart contracts**, enabling the development of decentralized applications (DApps) and making Cardano a more attractive platform for developers.

* **Basho**  
This is the **optimization** phase, which improved the **scalability** and **interoperability** of the network. Whereas previous development phases focused on decentralization and new functionality, Basho was about improving the underlying performance of the Cardano network.

* **Voltaire**  
This development phase provided the final pieces required for the Cardano network to become a self-sustaining system. With the introduction of a **voting and treasury system**, network participants can now use their stake and voting rights to further influence the future development of the network.

### Key features

#### Measure twice, cut once

An intrinsic part of Cardano’s philosophy is doing things right from the start. For example, at IO:

* **Research**: every decision is grounded in peer-reviewed academic research; as evidence, IO has published over [250 research papers](https://iohk.io/en/research/library/) to date
* **Implement**: when research produces a viable result, it is implemented using robust, reliable tools (ie, Haskell)
* **Validate**: formal methods are applied to mathematically verify that implementations behave as intended.

This philosophy extends across the wider Cardano community. It is one of the ecosystem’s core strengths, enabling continuous improvement and helping avoid the kinds of errors or trade-offs often seen in other blockchains.

#### Ouroboros consensus protocol

Cardano employs the Ouroboros proof-of-stake (PoS) protocol:

* An **energy-efficient** and **scalable** alternative to the proof-of-work (PoW) protocol used by other blockchains
* The first **provably secure PoS protocol**, assuming that at least 51% of the stake is held by honest participants
* The first blockchain protocol founded on **peer-reviewed academic research**
* Time is divided into *slots*. For each slot, a stake pool is randomly chosen as the slot leader and rewarded for adding a block to the chain
* Ada holders may delegate their stake (ada) to a specific stake pool **without any risk** to help secure the network and earn rewards.

#### Extended unspent transaction output (EUTXO)

Cardano employs the EUTXO accounting model:

* All blockchain transactions can be viewed as a series of **inputs being consumed and outputs being created**
* An extension of Bitcoin’s UTXO, providing the same level of **security** as Bitcoin while enabling **powerful smart contracts** as on Ethereum
* Combined with Cardano’s handling of time, it enables **fully deterministic transactions**, so users can predict in advance the effect of their transactions on the blockchain
* Simplifies the development of **secure smart contracts** and reduces the effort required to audit them.

#### Decentralized governance

Cardano uses several mechanisms to enable the community to guide its development:

* **On-chain governance**: involves the constitutional committee, delegated representatives (DReps), and stake pool operators (SPOs) to manage and vote on network decisions
* **CIPs and CPSs**: Cardano Improvement Proposals (CIPs) and Problem Statements (CPSs) define, discuss, and agree on protocol evolutions, standards, and other technical aspects (eg, CIP-1694).
* **Project Catalyst**: while not strictly part of protocol governance, it allows community members to vote on which projects receive funding and support.

This community-based approach means that changes to the protocol are proposed, discussed, and agreed upon by the community.

### What is ada?

Ada is the native cryptocurrency of the Cardano blockchain. It's named after Ada Lovelace, a 19th-century mathematician who is recognized as the first computer programmer.  
1 ada = 1,000,000 lovelace.

### Native tokens

Cardano **natively** supports **user-defined tokens**, enabling businesses and developers to create and distribute their own tokens:

* This includes both **fungible (identical) tokens** and **non-fungible tokens (NFTs)**, offering broad utility for a variety of applications
* Unlike other blockchains, these tokens can be transferred **without the need for smart contracts**
* Tokens in Cardano behave **almost exactly like ada**, Cardano's native cryptocurrency, except that they can be minted or burned by following their respective minting policies.

### Wallets

As with any other cryptocurrency, you can store and save ada using a wallet. Some examples include but are not limited to:

* [Lace](https://www.lace.io/)
* [Daedalus](https://daedaluswallet.io/)
* [Yoroi](https://yoroi-wallet.com/).

### Developing in Cardano

#### DApps

Cardano supports programmable validators (smart contracts) that enforce decentralized application rules:
* Most of the code (around 90%) is like traditional software development – building websites, mobile apps, and infrastructure
* However, on top of this, there are extra steps that define the application’s **interaction with the blockchain**:
  * Defining a **protocol**
  * Coding a **validator** (smart contract) that will **enforce** the protocol rules 
  * Building and sending **transactions** defined in your protocol
* By combining many simple validators, developers can create **complex protocols** and DApp functionality.

Smart contracts on Cardano allow for applications such as:

* NFT marketplaces and platforms
* Decentralized exchanges (DEXs)
* Automated lending and borrowing platforms
* Digital identity management platforms
* Decentralized, blockchain-powered mobile networks
* Decentralized artificial intelligence systems
* Decentralized autonomous organizations (DAOs)
* Decentralized prediction markets
* Decentralized cloud storage systems
* And more...

### Further reading

* Back to lesson 8: [Blockchain evolution](./8-blockchain-evolution.md)
* [Index](../README.md).
