## **Consensus**

Here we'll explore the core of blockchain, the rule, the law, and how users with equal rights reach a consensus in a decentralized environment.

### Code is law

First and foremost, there is a paradigm we need to acknowledge and that is "Code is law". The reason why it's important in the context of blockchains is that it's not prone to human mistakes and easily enforced without the hassle of lawyers or trials, especially where there is no authority. The code is the law and if it allows you to do something, then it is "legal". Even exploitation can be legal but the caveat is that everyone else might vote for reversal and by majority, it will get undone.

### Consensus Rules

We are getting in the trenches at this point because, so far, we haven't covered how new blocks are created or added to the chain, who can create them, what would make a block or a transaction valid, etc. Consensus rules dictate them all and will give answers. Let's start with consensus mechanisms which is responsible for how new blocks are created.

#### Consensus Mechanisms

There is a wide array of consensus mechanisms in existence, with new ones emerging constantly. However, we will focus on the two major mechanisms. Creating new blocks and the creator were originally referred to only as mining and miner, but as blockchain evolved, now block producing and block producer are also used.

##### Proof of Work (POW)

Initially, proof of work was the first and only consensus mechanism. It is a competition of who will solve the computationally hard problem first. It's so difficult that the name of mining came from literally mining in real life as it's compared equally hard, thus, considered a fitting name. 

Somebody who solved the problem first will get to "mine a block" which means to get own created block added to the chain, given that the block is a valid block. Additionally, earning a right to mine a block doesn't grant you to put anything you want in the block in accordance with the consensus rules. As mentioned before, transactions require signature so a miner cannot spend others' cryptocurrency because they cannot forge a signature without correct private key. Choosing what transactions to include in own blocks is at miners discretion and, **incentive** and **censorship** are part of the discussion related to it but it is another topic.

We have seen what hash is. Simply put, the problem miners are racing to solve is find a hash with specific conditions. Miners collect pending transactions however they want and include them in their block but it's not part of the chain yet. Next, they hash the block and get the hash value of it. Then comes the race, they compete to find a hash for their block that begins with particular amount of zeroes like it should start with 8 zeroes. You might ask, if hash functions give out the same hash values for the same input, don't they have to change block content to get different hash? Yes, indeed the block needs to change to create diffirent hash and there is an extra number for that purpose called **nonce**. By incrementing a nonce one by one, like 1, 2, 3, etc, changes the block hash completely and the first person to find specific number that results in block hash having started with certain amount of zeroes gets their block added to the chain.

##### Proof of Stake (POS)

In POW, all the work done on trying to find a hash is lost or worthless except the winning block. There is even another mechanism called Proof of Useful Work but it's all consuming energy and at scale, it might become enormous, perhaps more than a country's consumption. Proof of Stake doesn't spend energy like that. In POS, mining becomes staking and miners are called block producers, also known as validators or slot leaders. It works like you earn the rights to produce blocks depending on how much stake you have. If you hold 10% of supply, then you will get to produce 10% of all blocks created in a period. However, it's not fully deterministic that someone with exact 1% stake gets exactly 1% of blocks. Furthermore, block assignment is done through probability or in another words, like a lottery where large stake holders have a high chance of winning. The reason for having randomness to certain extent is that it prevents planned manipulation or attacks. They don't know when they should produce a block too far in advance or too late. They know it with just enough time in advance, sometimes minutes, hours or days. Another subtle benefit is that it gives every honest block producer a chance, no matter how small. If it was deterministic all the way and only 10,000 blocks were assigned over the period, those who has stake lower than 0.01% will never get a block until they reach 0.01%.

#### Chain branching

Transactions are recognized as done or processed when it's included in a block in the chain. The deeper the block with the transaction is in the chain, the less the transaction is likely to be reversed because all the following blocks will also have to change. Transaction reversal?
Due to the nature of decentralized and distributed network, from time to time, multiple blocks are created and become candidates for the same position in the chain. In fact, they all are valid blocks for being chained to the chain but the problem comes in from where they were or thought be the first candidate. Once a candidate is chosen, the other blocks are dismissed, so are the transaction in them. Consequently, transactions are reversed unless they were also in the chosen one.

##### Longest chain

The most well known consensus rule for branches of the chain is the longest chain rule. It says that the longest branch of the chain is the right chain at the moment. Blockchain is not a perfect linear chain of blocks. But it's more like a root of a tree. No one knows what branch will be the longest in the future so they are kept in the short term in case they become the longest. Resources are limited, so old losing branches are disregarded after a certain threshold and worse case scenario is that they could be used for attacks too.

#### Other details

Consensus rules also cover every other details such as total supply, minting as in how supply is released to go into circulation, smart contracts, etc. Like the transactions requiring signatures and every tiny bit of detail such as sender, receiver, amount, timestamp of transaction, does the sender have enough balance to do such transaction and more. It's enforced by participants as no central authority exist which could mean some users can ignore it and try to do malicious things. As long as the majority is honest, that should do no serious harm. Miners choosing not to include certain type of transactions like specific sender in their blocks, would be censorship. As long as there is at least one miner not censoring the target, their transaction will go through eventually. If every miner was censoring the same target, then by definition, that would be considered a consensus, and the victim have to either become a miner or wait for a new miner who won't censor it unless somebody stops censoring. That's a little nuance of a case. Actually, consensus rules are implemented in code and as code is law, it is enforced by computers and devices, not humans.

### Bitcoin as an example

For instance, in case of Bitcoin blockchain, the total supply is capped at 21 million bitcoins. Using proof of work, new bitcoins are minted and get into circulation as a reward for mining a block until the cap is reached. 50 bitcoins a block but it gets halved every 210,000 blocks which is approximately 4 years because bitcoin's consensus rules try to keep a single block's mining time to an average of 10 minutes. They do that by re-calibrating something called mining difficulty (the number of zeroes at the beginning of block hash) every 2,100 blocks. So if the most recent 2,100 blocks were mined with an average time less than 10 minutes a block, they increase the difficulty and vice versa.

#### **Where to go?**

* Back to lesson 5: [Cryptography](./5-cryptography.md)
* Next, Lesson 7: [Accounting Model](./7-accounting-model.md)
* [Index](./0-index.md)