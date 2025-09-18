# 4.4 Staking cycle

When a user delegates ada, the pool can start producing blocks two epochs later. The user starts receiving rewards after two epochs. An epoch currently lasts five days. This is the delegation cycle:

* Epoch x: the user delegates funds
* Epoch x+1: delegation is registered
* Epoch x+2: delegation becomes active, and a pool may create blocks
* Epoch x+3: rewards are calculated
* Epoch x+4: rewards are distributed.

Typically, rewards are distributed to wallets within 15 to 20 days after delegation. If the user delegates funds to another pool or stops delegating in epoch x \+ n, they will get rewards for n epochs from the first stake pool.  

Live stake refers to all the ada registered to stake pools (starting at epoch x and ending when funds are no longer delegated). The active stake is all the ada locked in for an epoch snapshot (which starts at epoch x+2 and ends two epochs later, after funds are no longer delegated). Any of those can be higher or lower than the other. The numbers on official pages differ a little and can be looked up at:

* [CExplorer](https://cexplorer.io/)
* [CardanoScan](https://cardanoscan.io/)  
* [PoolTool](https://pooltool.io/).
