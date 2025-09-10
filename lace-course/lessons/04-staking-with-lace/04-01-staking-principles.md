# 4.1 Staking principles *(somewhat technical)*

Stake pools are block-producing Cardano nodes. They are computers that should ideally run and validate transactions 24/7. The PoS consensus protocol that Cardano nodes run is called [Ouroboros](https://iohk.io/en/blog/posts/2022/06/03/from-classic-to-chronos-the-implementations-of-ouroboros-explained/). Ouroboros allows any ada holder to delegate their ada to a stake pool and earn rewards over time. The rewards are paid out in ada.

The word *stake* is used for the ada that users or entities own. If the ada is delegated to a stake pool, it becomes part of the *live stake*. We say *live stake* because it refers to ada used for delegation, in contrast to *unstaked* ada. Sometimes, one comes across the word *active stake*, which is live stake that gets registered for an epoch snapshot. The reason we call it *active* is that it is *actively* used for securing the Cardano network at a certain point in time. An epoch is a measurement of time and lasts 432,000 slots on mainnet and preprod networks. For the preview network, it lasts 86,400 slots. A slot currently lasts one second and can change in the future if necessary. This means that an epoch currently lasts five days on mainnet and preprod and one day on the preview network. On average, nodes are expected to be nominated to produce a block every 20 seconds. That is also around the time it takes for a transaction to get confirmed. The more blocks a stake pool produces, the more rewards it earns.

The Ouroboros consensus mechanism selects nodes for block production. The more stake  registered with a stake pool, the higher the chance of being selected multiple times within an epoch to produce a block. There is also a threshold of delegated ada above which the probability of being selected no longer increases. This was implemented to prevent centralization, which happens when a few stake pools control the majority of delegated stake. We call this threshold the *saturation limit*.

If a stake pool produces one or more blocks within an epoch, it receives a reward of ada that is then distributed to all individuals who delegate to that pool. Staking rewards come from two sources: transaction fees and monetary expansion. Transaction fees depend on the size of the transaction (inputs, outputs, data attached to the transaction, etc). Each epoch, 0.03% of the remaining reserve is allocated for rewards in that epoch. If less than 100% of the available stake is delegated (all ada users own), then the appropriate percentage is paid out. The unclaimed rewards go back to the reserve. This means rewards are not dependent on the number of people staking ada, but rather they slowly decrease because the reserve has a limited amount of ada. Stake pool operators (SPOs) also take a percentage of the reward. This is to cover the work they put into running and maintaining a pool.

Part of the monetary expansion and the transaction fees is also allocated to the treasury. The funds in the treasury can then be used for funding the development of Cardano core technology and other activities related to the governance of Cardano. Also, community projects can be funded via [Project Catalyst](https://projectcatalyst.io/).

For more information on staking and monetary policies, see the following Cardano documentation pages:  

* [Proof of stake](https://docs.cardano.org/about-cardano/new-to-cardano/proof-of-stake)
* [Delegation](https://docs.cardano.org/about-cardano/learn/delegation)
* [Pledging and rewards](https://docs.cardano.org/about-cardano/learn/pledging-rewards)
* [Cardano monetary policy](https://docs.cardano.org/about-cardano/explore-more/monetary-policy).

For a more detailed explanation, check the following content in the Mastering Cardano book:

* [Governance chapter](https://github.com/input-output-hk/mastering-cardano/blob/main/chapters/chapter-05-governance.adoc)
* [Staking chapter](https://github.com/input-output-hk/mastering-cardano/blob/main/chapters/chapter-07-stake-pools-and-stake-pool-operation.adoc)
* [Ouroboros section](https://github.com/input-output-hk/mastering-cardano/blob/main/chapters/chapter-04-how-cardano-works/ouroboros-consensus.adoc).
