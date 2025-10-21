## **Cardano overview**

Cardano was founded by Ethereum co-founder Charles Hoskinson and Jeremy Wood, and initially developed by IOG (Input Output Group). The project started in 2015, and its development was based on academic research and a scientific philosophy, a distinct approach compared to other blockchain projects.

Cardano's development plan is divided into five distinct phases or "eras":
* **Byron**  
Focused on the **establishment** of the Cardano blockchain's foundation, enabling the trade and transfer of ADA, Cardano's native cryptocurrency.

* **Shelley**  
This era was about **decentralization**. During this phase, the network began its transformation from a federated model to a decentralized one, allowing users to stake their ADA and participate in the network consensus.

* **Goguen**  
Focused on the integration of **smart contracts**, enabling the development of decentralized applications (DApps) and making Cardano a more attractive platform for developers.

* **Basho**  
This is an era of **optimization**, improving the **scalability** and **interoperability** of the network. Whereas previous development eras focused on decentralization and new functionality, Basho is about improving the underlying performance of the Cardano network.

* **Voltaire**  
This era provided the final pieces required for the Cardano network to become a self-sustaining system. With the introduction of a **voting and treasury system**, network participants are able to use their stake and voting rights to further influence the future development of the network.

### Key Features

#### Measure twice, cut once

An intrinsic part of Cardano’s philosophy is doing things right from the start. For example, at IOG:
* **Research**: For everything we do, we make sure to do proper peer-review research before making decisions. As proof of this, IOG has published **over 250 research papers** as of today.
* **Implement**: Once the research yields a useful result, we make sure to implement it using the best tools available (e.g., Haskell)
* **Validate**: We use formal methods to formally prove that our implementations actually do what the research says they should do.

Most of the Cardano community follows a similar philosophy at their own scale. We believe this is one of the core strengths that allows Cardano to continuously improve and avoid major mistakes or tradeoffs common in other blockchains.

#### Ouroboros consensus protocol

Cardano employs the Ouroboros Proof-of-Stake (PoS) protocol
* **Energy-efficient** and **scalable** alternative to the Proof-of-Work (PoW) protocol used by other blockchains.
* The first **provably secure proof-of-stake protocol**, (secure so long as 51% of the stake is held by honest participants).
* The first blockchain protocol to be based on **peer-reviewed research**. 
* Time is measured in slots. For each slot, a stake pool is assigned as the slot leader, and is rewarded for adding a block to the chain. 
* Ada holders may delegate their stake (ADA) to a specific stake pool **without any risk** to help secure the network and earn rewards.

#### Extended Unspent Transaction Output (EUTxO)

Cardano employs the EUTxO accounting model

* All transactions in the blockchain can be thought of as a series of **inputs being consumed an outputs being generated**.
* An extension of Bitcoin’s UTxO that allows Cardano accounting model to have the same level of **security** as Bitcoin but with the flexibility to have **powerful smart contracts** as Ethereum.
* Combined with how Cardano handles time, it allows for **fully deterministic transactions** (you know in advance the effect your transaction will have on the blockchain).
* It makes it easier to write **secure smart contracts** and reduces the work to audit them.

#### Decentralized Governance

Cardano uses different mechanisms to allow the community to steer the boat:
* **On-chain governance**: Constitutional Committee, DReps, and SPOs.
* **CIPs and CPSs**: Cardano Improvement Proposals (CIPs) and Problem Statements (CPSs) are used define and discuss evolutions, standards, and other technical aspects of how the blockchain should operate (E.g., CIP-1694).
* **Catalyst**: Not strictly part of Cardano governance, but a way for community members to decide on which projects are worth investing in.

This community-based approach means that changes to the protocol are proposed, discussed, and agreed upon by the community.

### What is ADA?

ADA is the native cryptocurrency of the Cardano blockchain. It's named after Ada Lovelace, a 19th-century mathematician who is recognized as the first computer programmer.  
1 ADA = 1,000,000 Lovelace

### Native Tokens

Cardano **natively** supports **user-defined tokens**, making it possible for businesses and developers to create and distribute their own tokens.
* This includes both **fungible (identical) tokens** and **non-fungible tokens (NFTs)**, offering broad utility for a variety of applications.
* Unlike other blockchains, these tokens can be transferred **without the need for smart contracts**.
* Tokens in Cardano behave **almost exactly like ADA**, Cardano's native cryptocurrency, except that they can be minted or burned by following their respective minting policies.

### Wallets

As any other cryptocurrency, you can store and save ada using a wallet.

* [Lace](https://www.lace.io/)
* [Daedalus](https://daedaluswallet.io/)
* [Yoroi](https://yoroi-wallet.com/)

### Developing in Cardano

#### Decentralized Applications (DApps)

Cardano supports programmable validators (smart contracts) that enforce the rules of decentralized applications (DApps):
* 90% the code is traditional software development (websites, mobile applications, infrastructure, etc)
* However, on top of this, there are extra steps that define the application’s **interaction with the blockchain**:
  * Defining a **protocol**.
  * Coding a **validator** (smart contract) that will **enforce** the rules of the protocol.
  * Building and sending the **transactions** defined in your protocol.
* By combining many simple validators, you can create complex protocols

Smart contracts on Cardano allow for applications such as:

* NFT marketplaces and platforms
* Decentralized exchanges (DEX)
* Automated lending and borrowing platforms
* Digital identity management platforms
* Decentralized, blockchain-powered mobile networks
* Decentralized artificial intelligence systems
* Decentralized autonomous organizations (DAO)
* Decentralized prediction markets
* Decentralized cloud storage systems
* And more...

#### **Where to go?**

* Back to lesson 8: [Blockchain Evolution](./8-blockchain-evolution.md)
* [Index](./0-index.md)