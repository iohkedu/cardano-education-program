## Accounting model

Another term that came from real life because of its similarity is *wallets*. Wallets manage private and public keys, track cryptocurrency balances (also known as coins), synchronize with the blockchain, send transactions to the network, and handle much more behind the scenes. But how do blockchains actually store balances? That’s an important question, since it’s what allows the system to check whether someone has enough funds to make a new transaction. You can’t do much with an empty wallet these days – pun intended. The **accounting model** is the answer to how a blockchain stores balances and defines the structure that all transactions must follow.

### Unspent transaction output (UTXO) model

The **UTXO model** sometimes seems unintuitive at first, but it's easy to understand. U, TX, and O stand for **u**nspent, **t**ransaction, and **o**utput, respectively. As the name suggests, it's about transaction outputs.

We will follow an example with Bob sending Ted 100,000 ada coins, which is a cryptocurrency of the Cardano blockchain. Such a transaction would resemble this:

```
                                                     *****
                                                   **     **
                                                  *         *
                                                 *    TED    *
                                                *   100,000   *
                                              // *    ada    *
                                             //   *         *
                                            //     **     **
                                           //        *****
                          _________       //
     *****               |         |     //
   **     **             |         |    //
  *         *            |         |   //
 *    BOB    *           |         |  //
*  1,000,000  * =======> |   TX    | >
 *    ada    *           |         |  \\
  *         *            |         |   \\
   **     **             |         |    \\
     *****               |_________|     \\
                                          \\        *****
                                           \\     **     **
                                            \\   *         *
                                             \\ *    BOB    *
                                               *   900,000   * 
                                                *    ada    *
                                                 *         *
                                                  **     **
                                                    *****
```

Transactions have inputs and outputs. In this example, Bob’s 1 million ada is the only input, and there are two outputs: one to Ted for 100,000 ada, and one back to Bob as change for 900,000 ada. Think of it like using cash. You don’t tear a $10 bill in half to pay $5 at a store – you hand over the whole $10 bill and receive $5 in change. The total of all inputs must equal the total of all outputs plus any transaction fees.

The two outputs are UTXOs, since they are transaction outputs that have not yet been spent. Here’s the twist: transaction inputs can only come from UTXOs – which means from previous transaction outputs. Once an output is used as an input, it is no longer an unspent transaction output (UTXO) because it has been spent. Hence, each UTXO can only be used once. So, the transactions would proceed as follows:


```
                        ***
                       *   *
                      *     *
             ____    / *   *
  ***       |    |  /   ***                   ***
 *   *      |    | /                         *   *
*     * --> | TX |>                         *     *
 *   *      |    | \               ____    / *   *
  ***       |____|  \   ***       |    |  /   ***
                     \ *   *      |    | /
                      *     * --> | TX |>
                       *   *      |    | \
                        ***       |____|  \   ***
                                           \ *   *
                                            *     *
                                             *   *
                                              ***
```

Bitcoin and Cardano use the UTXO accounting model, for instance. Each blockchain follows its own consensus rules and applies a slightly modified version of the same accounting model. You might wonder how the first UTXO comes into existence when there are no previous transactions. The first UTXO is special – it’s created in the genesis block, the very first block of the chain. Since blockchains use variations of the model, there are exceptions. For example, in Bitcoin, the transaction that mints new bitcoins doesn’t require any inputs and contains only outputs.

### Account model

The other accounting model used by blockchains is the **account model**. If the UTXO model is like cash, the account model is more like a credit card. It tracks literal balances, and when a transaction occurs, the balance is updated accordingly – just like a bank account. Ethereum and BNB Smart Chain (BSC) are two examples of blockchains that use this model.

Overall, the accounting model is a crucial aspect of blockchain design because it defines the fundamental structure and format of transactions, which in turn influence other features such as smart contracts, layer 2s, and sidechains.

### Further reading:

* Back to lesson 6: [Consensus](./6-consensus.md)
* Next lesson: [Blockchain evolution](./8-blockchain-evolution.md)
* [Index](../README.md).
