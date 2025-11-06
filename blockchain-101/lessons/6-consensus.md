## Consensus

This lesson explores the core of blockchain – the rules, the law, and how users with equal rights reach a consensus in a decentralized environment.

### Code is law

First and foremost, there is a paradigm we need to acknowledge, and that is 'code is law'. In the context of blockchains, this means that the rules written in code are what define what can or cannot happen. These rules aren’t prone to human error, though, and can be enforced automatically, without lawyers, courts, or central authorities. The code is the law, and if it allows you to do something, then it is 'legal'. Even exploitation can be technically allowed – but if the community disagrees, participants can vote to reverse it. In that case, the majority decision becomes the new outcome.

### Consensus rules

We are getting into the details at this point because, so far, we haven’t covered how new blocks are created or added to the chain, who can create them, or what makes a block or a transaction valid, etc. Consensus rules define all these aspects and provide the answers. Let’s start with consensus mechanisms, which determine how new blocks are created.

#### Consensus mechanisms

A wide range of consensus mechanisms exists, with new ones continually emerging. However, we will focus on the two main types. The process of creating new blocks and the individual who creates them were originally known as *mining* and *miner*, but as blockchain technology evolved, the terms *block-producing* and *block producer* also came into use.

##### Proof of work 

Initially, proof of work (PoW) was the first and only consensus mechanism. It is a competition to see who can solve a computationally challenging problem first. It’s so difficult that the term *mining* was inspired by real-life mining – both are equally hard, making it a fitting name.

Whoever solves the problem first gets to 'mine a block', meaning their newly created block is added to the chain, provided it is valid. However, earning the right to mine a block does not allow adding anything they want – all content must follow the consensus rules. As mentioned before, transactions require signatures, so a miner cannot spend others’ cryptocurrency since they cannot forge a signature without the correct private key. Choosing which transactions to include in their own blocks is at the miner’s discretion, and *incentive* and *censorship* are part of the broader discussion related to it – but that is another topic.

We have already discussed what a hash is. Simply put, the problem miners are racing to solve is finding a hash that meets specific conditions. Miners collect pending transactions in any order they choose and include them in their block, but they are not yet part of the chain. Next, they hash the block to get its hash value. Then comes the race. They compete to find a hash for their block that begins with a certain number of zeroes – for example, eight zeroes. You might ask: if hash functions always produce the same hash for the same input, don’t miners have to change the block’s content to get a different result? Yes, they do. To create a different hash, miners adjust a special number called a *nonce*. By increasing the nonce one by one – 1, 2, 3, and so on – the block’s hash changes completely. The first miner to find the specific nonce that produces a hash starting with the required number of zeroes gets their block added to the chain.

##### Proof of stake

In PoW, all the work done trying to find a hash is lost or becomes worthless, except for the winning block. There is even another approach called proof of useful work, but it still consumes large amounts of energy and, at scale, could exceed the energy use of an entire country. Proof of stake (PoS) doesn’t consume energy in that way. In PoS, mining becomes *staking*, and miners are called block producers, also known as validators or slot leaders. It works so that the right to produce blocks depends on the amount of stake someone holds. For example, if a person holds 10% of the total supply, they can expect to produce about 10% of all blocks within a given period. However, this process isn’t entirely deterministic – someone with exactly 1% of the stake won’t necessarily produce exactly 1% of the blocks. Block assignment is based on probability, or in other words, it works like a lottery where larger stakeholders have a higher chance of being selected. This element of randomness helps prevent manipulation or coordinated attacks, since block producers don’t know too far in advance when they will be selected. They find out only shortly before – sometimes minutes, hours, or days ahead. Another benefit is that it gives every honest block producer a chance, regardless of the size of their stake. If the process were fully deterministic and 10,000 blocks were assigned during a period, anyone with less than 0.01% of the stake would never be chosen until they reached that threshold.

#### Chain branching

Transactions are recognized as complete or processed when they are included in a block in the chain. The deeper the block with the transaction is in the chain, the less likely it is to be reversed, because all subsequent blocks would also have to change. Transaction reversal?
Because of the decentralized and distributed nature of the network, multiple blocks may sometimes be created at the same time, each competing for the same position in the chain. In fact, all of them can be valid candidates for addition to the chain, but the issue lies in determining which one was – or was thought to be – the first. Once a candidate block is chosen, the others are dismissed along with the transactions they contain. As a result, those transactions are reversed unless they also appear in the accepted block.

##### Longest chain

The most well-known consensus rule for competing branches of the chain is the longest chain rule. It states that the longest branch of the chain is considered the valid one at that moment. A blockchain is not a perfectly linear sequence of blocks – it’s more like the root of a tree with several branches. No one knows which branch will become the longest in the future, so all are temporarily kept in case one of them overtakes the rest. Since resources are limited, older branches that fail to meet a certain threshold are eventually discarded. In the worst case, such abandoned branches could even be used for attacks.

#### Other details

Consensus rules also define every other aspect of the system, such as the total supply, minting (ie, how new supply is released into circulation), smart contracts, and more. They cover all the details that make transactions valid – including the sender, receiver, amount, timestamp, and whether the sender has enough balance to complete the transaction. These rules are enforced by participants, since no central authority exists. This means some users might ignore them and attempt malicious actions. However, as long as the majority behaves honestly, such attempts cause no serious harm. If miners choose not to include certain types of transactions, such as those from a specific sender, that would be considered censorship. As long as at least one miner does not censor the target, the transaction will eventually be confirmed. If every miner censors the same target, that becomes a form of consensus – and the affected user would have to become a miner themselves or wait for a new miner willing to include their transaction. That’s one of the subtle nuances of consensus. In practice, consensus rules are implemented in code, and as code is law, they are enforced by computers and devices – not by humans.

### Bitcoin as an example

For instance, in the Bitcoin blockchain, the total supply is capped at 21 million bitcoins. Through PoW, new bitcoins are minted and enter circulation as rewards for mining blocks until this cap is reached. Each block originally rewarded 50 bitcoins, but the reward is halved every 210,000 blocks – roughly every four years – because Bitcoin’s consensus rules aim to keep the average block time at about 10 minutes. This is achieved by recalibrating a parameter called mining difficulty – the required number of zeroes at the beginning of a block’s hash – every 2,100 blocks. If the most recent 2,100 blocks were mined in less than 10 minutes on average, the difficulty increases, and if they took longer, it decreases.

### Further reading:

* Back to lesson 5: [Cryptography](./5-cryptography.md)
* Next lesson: [Accounting model](./7-accounting-model.md)
* [Index](../README.md).
