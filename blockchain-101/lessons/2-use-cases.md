## Use cases

Now that we have this special notebook, what can we actually do with it? Or better yet, what should we write in it, since we can record anything we want?

### Magical stamp

The 'magical stamp' creates the essential link between pages. This link ensures that a change to one page affects the whole sequence, since all subsequent pages must be updated as well.

Because each stamp is generated from the content of its page, any change to that content also changes the stamp. When a page is altered, it must be re-stamped. However, the next page stores the previous stamp as part of its own content, so the updated stamp no longer matches what the next page already has. This creates a ripple effect: every following page must update the stamp of the previous page it stores and then generate a new stamp for itself to remain connected to the chain.

Deleting a page causes a similar issue, since the chain must remain continuous. The next page would need to link back to the page preceding the deleted one.

### Where can we use it?

Because changing information deep in the chain is so difficult, blockchains are well-suited for data that should remain permanent. To name a few, this includes medical records, academic transcripts, and financial transactions. For example, medical diagnoses and prescriptions are often needed decades later to ensure accurate treatment. Storing such information on a blockchain makes it easier to trust that it has not been altered over time. In contrast, paper is fragile, and traditional digital systems can lose or change data through system updates, migrations, or external issues.

This doesn’t mean mistakes can’t be corrected. If something is recorded incorrectly, a new entry can be added to explain what was wrong and why. There’s even a light-hearted saying in the blockchain world: ‘You don’t delete data – you just add another entry saying it’s deleted’. Deletion, in this sense, means adding information, not removing it.

### Cryptocurrency

Cryptocurrency is the most well-known and widely used application of blockchain. At its core, it’s just numbers stored digitally – much like the numbers in a bank account balance.

Cryptocurrencies introduce a crucial element: monetary incentives. They reward participants for maintaining and securing the blockchain network. While a blockchain can exist without a cryptocurrency, public blockchains normally include one because, without a monetary incentive, it becomes unclear who would cover the ongoing cost of running and securing the system. Over time, fewer and fewer people would be willing to bear that cost, and the network would eventually cease to exist.

Private blockchains, however, can operate without a cryptocurrency, as participants are typically incentivized through internal mechanisms within the organization or consortium.

### Further reading:

* Back to lesson 1: [Chain of blocks](./1-chain-of-blocks.md)
* Next lesson: [Distributed ledger](./3-distributed-ledger.md)
* [Index](../README.md).
