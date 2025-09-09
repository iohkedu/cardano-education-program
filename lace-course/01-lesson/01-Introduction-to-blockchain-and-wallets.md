# 1. Introduction to blockchain and wallets 

This lesson covers the basics of blockchain and cryptocurrency wallets. The explanations are general and applicable to any type of blockchain, not just Cardano. If you are already familiar with blockchain basics, feel free to skip this lesson. The last two sections are more technical. They explain cryptographic keys and how wallets generate and use them. You may skip these sections and move on to the next lesson. 

## 1.1 Basic blockchain terms

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

A **decentralized exchange** (DEX) is a platform where one or more smart contracts instead of a central authority, enable fund management. These contracts define the rules for exchanging cryptocurrency and tokens. A DEX is one example of a sophisticated DApp.  

## 1.2 Introduction to cryptocurrency wallets  

As mentioned in the previous section, a cryptocurrency wallet provides a frontend for storing and managing cryptocurrencies and tokens. Under the hood, wallets manage cryptographic keys, which users need to sign transactions. To learn more about keys, read the [*Cryptographic keys*](https://github.com/iohkedu/cardano-education-program/blob/lace-course/lace-course/01-lessons/01-Introduction-to-blockchain-and-wallets.md#14-cryptographic-keys) and [*Key generation for wallets*](https://github.com/iohkedu/cardano-education-program/blob/lace-course/lace-course/01-lessons/01-Introduction-to-blockchain-and-wallets.md#15-key-generation-for-wallets) sections.  

In this section, we will cover various types of wallets tailored to different use cases. The first major categories are *software wallets* and *hardware wallets*. Software wallets are digital wallets that users install on their computers, either as desktop applications or as browser extensions. Hardware wallets are small computers, often the size of a USB stick, that run wallet software. They connect to a user’s computer, where compatible wallet software must be installed to support the connected wallet. One of the advantages of hardware wallets is security – the communication between the hardware wallet and the computer is restricted. Because of this, hardware wallets are very difficult to hack. Another category is a paper wallet, where private and public keys are written down or printed. 

A software wallet can be further categorized into two types: *full-node* and *lightweight*. Full-node wallets download the entire blockchain history and connect directly to the blockchain. Lightweight wallets connect to a server that contains a synced node and posts a request to query blockchain data and process transactions. The advantage of full-node wallets is that you don’t have to trust a remote server if unsure of its operator. The downside is that you *need* to sync your wallet node with the latest blockchain data. This may take some time if your computer is disconnected from the network for a while. IO is working on a protocol and network called [Mithril](https://mithril.network/) to provide full-node wallets with quick synchronization, and lightweight wallets with the same security guarantees as full-node wallets. 

Wallets can also be labeled as *hot* and *cold*. Cold wallets remain offline, while hot wallets are connected to the internet. This means that hot wallets are more user-friendly and accessible, but easier for hackers to steal. Web-based, mobile, and desktop wallets are hot wallets. Paper and hardware wallets are cold wallets. 

Another key differentiation between wallets is whether they are *custodial* or *non-custodial*. For custodial wallets, users do not have complete control over their tokens, and the private keys required to sign transactions are held by the entity that provides the wallet (eg, exchanges). Users can access these wallets only through their web browser. Handing over the security of the wallet to another entity can be risky. Exchanges often follow rigorous security standards, as they are highly prized targets for hackers.  

Wallets support various functionality. Some wallets support fund operations only within a specific blockchain. There are also multi-cryptocurrency wallets, and some can manage over 100 different currencies. Examples of such wallets include [MetaMask](https://metamask.io/), [Trust](https://trustwallet.com/), and [Exodus](https://www.exodus.com/), as well as hardware wallets such as [Trezor](https://trezor.io/) and [Ledger](https://www.ledger.com/). Wallets can also offer staking functionality if they support PoS cryptocurrencies. Web-browser wallets can also connect to DApps and generate transactions that interact with smart contracts. DApp developers decide which wallets their DApp is going to support. Wallets can also display images of NFTs or browse NFTs on market platforms. IO plans to add voting capabilities to its Lace wallet, enabling users to vote on proposals supporting the Cardano ecosystem.  

## 1.3 Best security practices

There are various security features for cryptocurrency wallets. Users can find many within a wallet itself, but they should also consider other recommendations. 

The most common security feature for wallets, both hardware and software, is that they are *forgiving*. This means that if users lose access to the wallet, they can restore it. Losing access can happen if the wallet is accidentally deleted or if the user loses access to the computer or hardware device where the wallet is installed. 

If a wallet is backed up with a seed phrase (also referred to as a *recovery phrase* or *mnemonic* – meaning ‘help to remember’ in Latin), it can be restored. A seed phrase is a list of words generated when a user creates a wallet. Usually, the list contains 24 randomly chosen words out of a fixed list of words. The count of words can also be smaller, 12 or 15, for example. The user needs to write down these words on paper and keep them in a safe place. Any person with access to the seed phrase can restore a wallet on a new computer and have full access to funds. The reason for this is that with the seed phrase, a master key can be generated, from which all other wallet keys are derived. To learn more about generating a seed phrase and restoring a wallet, read the [*Key generation for wallets*](https://github.com/iohkedu/cardano-education-program/blob/lace-course/lace-course/01-lessons/01-Introduction-to-blockchain-and-wallets.md#15-key-generation-for-wallets) section. 

It is also recommended not to display the list in front of computers and mobile devices that have a camera. Besides storing the seed on paper, one can also use a metal crypto wallet. These wallets enable storing the seed phrase on metal plates or a ring, thereby protecting it from time decay and fire. 

Another good security practice that wallets provide is asking you to set a password (passphrase) when creating a wallet. This password is then requested every time a user wants to unlock specific wallet functionality, such as signing a transaction or viewing the secret seed. This is useful if someone gains access to your computer with the wallet, because they cannot access any funds if they do not know the wallet’s password.   

For a significant amount of funds, a hardware wallet is the most secure option. When making a transaction, the hardware wallet displays the details and requires confirmation on its own screen, so even if a computer is compromised, the device remains secure because it cannot be directly controlled. 

Hardware wallets can also connect to lightweight wallets, allowing for interaction with decentralized exchanges. In this case, your funds do not leave your wallet until the trade is complete. In the case of a standard crypto exchange, you have to temporarily give up control of your funds and place them in the exchange’s wallet before trading. Most of the time, this is not an issue, since many exchanges follow rigorous security practices. If you are using a non-decentralized exchange, it is recommended that you always enable an additional security step for login and transaction confirmation. An example of such a security step is [two-factor authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication) (2FA). Because exchanges are highly targeted, it is not recommended to leave significant amounts of funds at an exchange for long periods of time. It is also worth noting that poorly managed exchanges can go bankrupt, so it makes sense for a user to take the time to consider their options before deciding on one.  

## 1.4 Cryptographic keys

*Note:* *This and the next section are somewhat technical for people without a technical background. However, we encourage you to read them and share any questions you may have with us.* 

Blockchain technology relies on public key cryptography. A cryptographic key can be used to sign a message. In the blockchain field, this message is a transaction. Signing transforms the message into a different type of data. Then, using cryptography, it can be proven that this message was signed with the key without revealing the key itself. 

A cryptographic key is a sequence of [bytes](https://simple.wikipedia.org/wiki/Byte) of fixed size. A byte is defined by 8 [bits](https://simple.wikipedia.org/wiki/Bit), which are the most basic form of information computers can store. Instead of bytes, another encoding can be used to display keys, for instance, the [hexadecimal](https://simple.wikipedia.org/wiki/Hexadecimal) system (numbers from zero to nine and letters from A to F) or the [bech32](https://en.bitcoin.it/wiki/Bech32) system that Bitcoin uses. In asymmetric cryptography, which is used in blockchain technology, keys are generated with an algorithm and come in pairs. One key is the private key, which the owner keeps secret, and the other key is the public key that they reveal. Public keys are generated from private keys. Due to the secure nature of key generation, an attacker cannot determine the private key by knowing the public key.  

A blockchain can utilize the public key associated with a user's cryptocurrency address. If funds are stored at that address and the owner wants to spend them, they must sign the transaction, which represents our message, with their private key. The node that receives this transaction uses the public key and the signed transaction to verify that the transaction was indeed signed with the private key linked to the public key. This means that the owner of a private key is the only person who can spend the funds associated with the address that corresponds to the public key. Sometimes, public keys are not used directly for blockchain addresses, but their hashes are used instead. Refer to the official documentation to learn more about [Cardano addresses](https://docs.cardano.org/about-cardano/learn/cardano-addresses). 

The following videos explain blockchain basics by showcasing interactive demonstrations of how hashes, transaction signing, and PoW consensus work:  

* [Blockchain 101 – a visual demo](https://www.youtube.com/watch?v=_160oMzblY8)   
* [Blockchain 101 – part 2 – public/private keys and signing](https://www.youtube.com/watch?v=xIDL_akeras).

Cryptocurrency wallets are programs that manage cryptographic keys. Wallets display user addresses that represent public keys or are derived from them, and they also display the funds held at these addresses. They store private keys and sign transactions with them when a wallet owner wants to spend their funds. These transactions are then broadcast to the blockchain network. Wallets offer additional functionalities, and we will showcase the functionality of the Cardano Lace wallet in the following lessons. Next, we explain how cryptographic keys are generated.  

## 1.5 Key generation for wallets

When generating a seed phrase, most wallets follow the Bitcoin Improvement Proposal 39 ([BIP-39](https://bips.dev/39/)), which is a standard for generating a seed phrase. The standard defines a list of [2048 words](https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt) where the first four letters of each word are unique and identify it unambiguously. A word can also be shorter than four letters. The number 2048 is equal 2 to the power of 11. This means that every single word defines a unique sequence of 11 [bits](https://simple.wikipedia.org/wiki/Bit). If a wallet generates a 24-word seed phrase, it contains 264 bits of information (11*24). Out of these 264 bits, 256 bits are used to set the master key of our wallet, from which all other keys are generated. The master key is sometimes referred to as the root key. 

The remaining 8 bits are used for verifying the master key with a [checksum](https://simple.wikipedia.org/wiki/Checksum). A checksum is a fixed-length sequence of data computed from input data of arbitrary length. It is used to verify data and relies on the fact that the probability of a collision (two different input data producing the same checksum) is negligible. This means that when generating a seed phrase, the last word cannot be arbitrarily chosen and is partly set by the checksum. We say *partly* because for a 24-word seed phrase, the last word contains 11 bits of information, and only 8 bits are used for the checksum. Because 3 bits can be chosen freely, only a limited subset of words from the 2048 word list can be used. 

The [Mnemonic Generation (BIP39) Simply Explained](https://medium.com/coinmonks/mnemonic-generation-bip39-simply-explained-e9ac18db9477) blog on Medium walks the reader through a simple example of generating a concrete seed phrase. Once the seed phrase is generated, the master key is set, and other keys (public and private) are generated with cryptographic methods from it. 

We note that the sequence of 24 words can be generated offline, without an internet connection, which allows for cold storage. In theory, there could be a collision, meaning that two different users end up with the same sequence of words for a seed phrase. In practice, the probability of such an event is negligible because the number of possible options for generating a 24-word seed phrase is 2 to the power of 256, which equals around 10 to the power of 77. To give you an impression of magnitude, there are estimated 10 to the power of 18 grains of sand in the world, which is far less than possible seed phrase sequences. As the chance of two people picking up the same grain of sand is negligible, so is the chance of two equal seed phases being generated. This is also true for seed phrases of 12 and 15 words in length. These provide 128- and 160-bit long master keys and approximately 10^38 and 10^48 options for seed phrase generation. 