# 1.1 Basic blockchain terms

Here, we provide a straightforward explanation of the basic terms related to cryptocurrency wallets and blockchain technology. The definitions are intentionally simplified for non-technical readers new to blockchain. For a more detailed introduction to blockchain basics, consider taking the following free courses:

* Blockchain 101 course on the [Cardano education program](https://github.com/iohkedu/cardano-education-program/)
* [Cardano academy](https://cardanofoundation.org/academy).

A **cryptocurrency** is a digital asset stored in a decentralized database. In this context, decentralization means the database is stored on multiple computers worldwide, which communicate with each other over the internet to maintain the database. The term 'cryptocurrency' (which derives from the word 'cryptography') is often shortened to 'crypto'.

**Cryptography** is a mathematical science of processing information for the purpose of keeping it secure and/or secret.

A **blockchain** is another name for the digital database that enables the creation and management of cryptocurrencies. The name is derived from the term *chain of blocks*. A blockchain database is also referred to as a *ledger*.  

A **block** contains a finite number of validated blockchain transactions and a cryptographic link to the previous block, creating a chain of blocks.

A **transaction** is a set of instructions that state how the blockchain database should be modified. It usually involves sending cryptocurrency from one address to another.  

A **node** is a computer program that enables a person to contribute to the growth of the blockchain. This means that the node processes transactions by creating and appending blocks to the blockchain. Some nodes are only used for submitting transactions and do not produce any blocks. The code that runs on a node defines key characteristics of a blockchain, such as the number of coins each block creates and the consensus algorithm the blockchain uses to grow the chain.  

A **consensus algorithm** is a set of rules that nodes use to agree on changes to the blockchain and to keep their data synchronized. **Proof of work** (PoW) and **proof of stake** (PoS) are the two most commonly used consensus algorithms. Cardano uses PoS while Bitcoin uses PoW. The *Staking with Lace* lesson further discussed PoS.  

**Block time** is the average time it takes for nodes to create blocks. For Cardano, the current block time is 20 seconds, while for Bitcoin it is approximately 10 minutes.  

**Node operators** are people who manage blockchain nodes. They are responsible for running the node, including keeping its software up to date. The operator does not manually process any transactions, the node software does it automatically. Node operators are incentivized to run and maintain nodes by receiving rewards for producing blocks. These rewards come from monetary expansion and transaction fees.

**Monetary expansion** refers to expanding the amount of the native cryptocurrency in existence. It happens when blockchain nodes receive a reward for creating a block and processing users' transactions. For the node that creates a block, an amount of cryptocurrency is simply added to its cryptocurrency address. Monetary expansion will be further discussed in the *Staking with Lace* lesson.

A **cryptocurrency address** is a sequence of [bytes](https://simple.wikipedia.org/wiki/Byte) of fixed size used to track the asset ownership of a cryptocurrency. Below is an example of a Cardano payment address. It starts with the prefix addr:

```shell
addr1q9k2zv0dfp6wn3eqcjhtmqa5dxl6dnsf94ztx9pp66gmckdrpcksnjuxyyw4rlynsnv89rp6wrzhrvvpfgpeh0k4hj9qwl3v2g
```

A **cryptocurrency exchange** is an organization that provides an online service for trading cryptocurrencies against other cryptocurrencies or fiat currencies (eg, dollars, euros, etc). The price of a cryptocurrency is determined by market demand and supply.

A **token** is a digital representation of an asset, value, access, ownership, and much more. Its value depends on its usability, and its price is determined by the market. The primary difference between tokens and cryptocurrencies is that anyone with the necessary knowledge can create tokens using a simple computer program. A cryptocurrency can only be created with a blockchain protocol that requires the development of sophisticated node software. Sometimes we refer to tokens as cryptocurrency, since they are created on the blockchain as digital assets.  

Tokens can be **fungible** or **non-fungible**. Fungible means there are more tokens of the same type, and they are interchangeable. There is often some functionality associated with such tokens, influencing their price. A non-fungible token (NFT) is a unique token stored on a blockchain. NFTs can represent digital ownership rights of real-world assets, such as a painting or a building.  

A **stablecoin** is a cryptocurrency whose value is held constant against one or more other assets. The assets may be a ‘basket’ of currencies, a single currency (eg, the US dollar or the euro), commodities such as gold or silver, stocks, or other cryptocurrencies. Stablecoins include mechanisms that maintain a low deviation from their target price, and so are useful to store or exchange value. Their built-in mechanisms remove price volatility.

A **smart contract** is a computer program that specifies the conditions under which a transaction can be processed. Nodes execute these programs. The term ‘smart’ highlights that they are programmable, while ‘contract’ reflects their binding nature, as they are practically impossible to change once deployed.

In Cardano, smart contracts are also referred to as **validators**. They can be of different types:

* **Spending** – set the allowed transaction logic for spending funds sitting at an address  linked to a smart contract.
* **Minting** – set the allowed transaction logic for creating tokens (referred to as native tokens on Cardano). These validators are also referred to as *minting policies*.
* **Rewarding** – used to govern the withdrawal of staking rewards.
* **Certifying** – used for certification purposes. Certificates can be used in applications that manage personal identity or physical assets/goods.
* **Voting** – handle transaction logic for voting on proposals.
* **Proposing** – handle transaction logic for proposals.

A **cryptocurrency wallet** is a program that stores a user’s private and public keys, providing a frontend for managing (sending or receiving) cryptocurrency assets stored on the blockchain. Wallets can also be used for purposes as:

* Viewing information as transaction history and displaying NFT images
* Staking cryptocurrency in PoS blockchains
* Interacting with decentralized applications (DApps).

Subsequent lessons of this course cover the topics above.

A **DApp** is a web-based application that consists of one or more smart contracts and code that handles transaction logic. Users can connect their cryptocurrency wallets to a DApp to interact with it.  

A **decentralized exchange** (DEX) is a platform where one or more smart contracts instead of a central authority, enable funds management. These contracts define the rules for exchanging cryptocurrency and tokens. A DEX is one example of a sophisticated DApp.
