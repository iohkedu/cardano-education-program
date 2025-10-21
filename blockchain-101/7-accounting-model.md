## **Accounting Model**

Another thing whose name also came from real life due to it's similarity is wallets. Wallets manage private and public keys, keep track of balances of cryptocurrencies, also known as coins, sync blockchain, send transactions to the network and more under the hood. But how do blockchains store balances exactly? It's another important thing as it's used to check if one has sufficient balance to make new transactions. Can't do anything with empty wallet nowadays, can we, pun intended. **Accounting model** is the answer for how blockchain stores it and it sets the foundation how all the transactions must be formatted.

### Unspent Transaction Output (UTxO) model

The **UTXO model** sometimes seem unintuitive at first but it's easy to understand. U, TX and O stand for Unspent, Transaction and Output, respectively. As the name suggests, it's about transaction outputs.

We will follow an example that Bob sends Ted 100,000 ada coins which is a cryptocurrency of Cardano blockchain. Such transaction would look something like this.

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

Transactions have inputs and outputs. In this case, Bob's 1 million ada is the only input and two outputs, one belonging to Ted with 1 hundred thousand ada, the other going back to Bob for the change of 9 hundred thousand ada. Think of cash (money bills) here, you don't tear $10 in the middle and give half of the bill to buy $5 worth of something at supermarkets, but you give the bill of $10 as a whole and get the change of $5 bill back. The total of all inputs should match with the total of all outputs and transaction fees if there are any.

The 2 outputs would be UTXOs as they are transaction outputs but not spent yet. Here is the twist, transactions inputs take only UTXOs, which are transaction outputs. Once an output is used as an input, it no longer is **unspent** transaction output (UTXO) because it is spent, hence, UTXOs can only be spent once. So the transactions would happen like the following:


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

Couple of the blockchains that use the UTXO model are Bitcoin and Cardano blockchains. Blockchains have different consensus rules and use modified versions of a single accounting model. You might be wondering that how does the first UTXO come into existence when there are no transactions? The first UTXO(s) is/are special and created in the genesis block. The very first block of the chain is called genesis. As blockchains use variations of a model, for instance, in Bitcoin, there is an exception which is that the transaction minting new bitcoins don't require any inputs and can have only has outputs.

### Account model

The other accounting model blockchains use is the **Account model**. If UTXO was like cash, think of the account model as credit cards alike. It has literal balances and when a transaction is made, then the balance is updated accordingly, just like bank account balance. Ethereum and BNB Smart Chain (BSC) are two of the blockchains that use the account model.

Overall, accounting model is crucial aspect of blockchain because it dictates the fundamental design and format of transactions which propagates to other features like smart contracts, layer 2s and sidechains.

#### **Where to go?**

* Back to lesson 6: [Consensus](./6-consensus.md)
* Next, Lesson 8: [Blockchain Evolution](./8-blockchain-evolution.md)
* [Index](./0-index.md)