# 4.3 Looking up stake pools

Stake pool listings can be found on various pages and also in Lace. Around 2,400 pools are currently operating on mainnet.

An example online page for viewing pool listings is [ADAPools](https://adapools.org/). You can see the annual percentage of user return calculated on the basis of the last 10 epochs and for the pool's entire lifetime. You also see the pool fee and its declared pledge (the operator’s stake delegated through the pool). The active pledge can be viewed on various explorers, including [www.cexplorer.io](http://www.cexplorer.io). The active pledge was introduced so that people see how much ‘skin’ an SPO has in the game.  

To view the pools in Lace, click ‘Staking’ on the right side. The staking overview window appears,  listing the total balance available for staking.

![Staking overview window in Lace](images\04-03-01.png)

Click the ‘Browse pools’ tab at the top to view all available pools for the preprod network set in a previous lesson.

![Browse pools tab in Lace](images\04-03-02.png)

The pools are sorted alphabetically, and their saturation levels are displayed. Once this level reaches 100%, the pool no longer receives any additional rewards, and users are incentivized to stake with another pool that has not yet reached full saturation. Click the layout button on the right side, above the pool list, to change the view from block to list.

![Pool list layout in Lace](images\04-03-03.png)

Next, click the circular information button in the top right corner to filter the pools by various criteria, such as saturation, cost, margin, pledge, and more. For each option, you can set numbers or letters to decrease or increase. Lace only takes into account pools that have met their pledge and are either active, activating, or retiring (a pool takes two epochs to retire). Some other pages, such as [pooltool.io](http://pooltool.io) and [adapools.org](http://adapools.org) display all pools.

You can also see the current epoch number, when it will end, the total amount of pools, and the percentage of staked ada.

![Epoch and staking statistics in Lace](images\04-03-04.png)

There are 456 and 344 active pools running for the preview and preprod networks, respectively, at the time of writing. The incentive to run them is for the benefit of Cardano, so developers can test their applications on these networks. Additionally, for SPOs to test and observe node releases, parameter changes, and other updates.

Some tickers (the short name of a pool, consisting of between three and five letters) may not be visible on one or both test networks. This is because Lace retrieves this information from the Stake Pool Metadata Aggregation Server ([SMASH](https://github.com/IntersectMBO/cardano-db-sync/blob/master/doc/smash.md)), hosting metadata for stake pools (owner, pool name and ticker, homepage, pledge address, short description, etc). Sometimes, this information may not be kept up to date, or a configuration file may be changed, so Lace may not always display tickers for all pools.  

When deciding which pool to stake ada with, you can also check out the pool’s website (if there is one). Some pools follow a certain mission or ethos and donate part of their income. An example is the [Climate Neutral Cardano](https://climateneutralcardano.org/) pool alliance that connects pools committed to using 100% renewable energy for the operation of their stake pool servers. Additionally, they donate a portion of their pool operator rewards to support climate and environmental protection.  
