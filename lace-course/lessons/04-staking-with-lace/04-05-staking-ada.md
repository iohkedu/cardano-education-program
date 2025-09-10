# 4.5 Staking your ada

Cardano implements *liquid staking*, which means that  ada remains in the user’s wallet at all times, available for transactions. This contrasts with traditional staking, where the cryptocurrency is locked up for a specific period of time and cannot be spent. This means Cardano users retain complete control over their funds at all times. It is also possible to stake ada from a hardware wallet, which makes the staking process safe.

Users must select a stake pool to delegate their ada. In this example, we choose the pool BNTY1. Once selected, the stake pool detail window opens.

![Stake pool selection screen](images\04-05-01.png)

This screen displays general pool information. From this screen, you can stake all your ada to the current pool or select the current pool for multi-staking, which allows you to delegate portions of ada to multiple pools.

Clicking ‘Stake all on this pool’ launches the ‘Manage staking’ screen.

![Manage staking screen](images\04-05-02.png)

Here, you can set how much ada you want to delegate to this pool. When staking with a single pool, you should delegate *all* of your ada. Adding another pool to the portfolio would allow you to define the split ratio for each pool. Users can multi-delegate to up to 10 pools.

Clicking ‘Confirm new portfolio’ launches a screen to confirm the transaction.

![Confirm new portfolio screen](images\04-05-03.png)

The amount to stake, the pool to delegate to, and the transaction cost are visible. Besides the transaction fee, users must pay a deposit of two test ada, which will be refunded after delegation to this pool ends.

![Staking confirmation window](images\04-05-04.png)

The ‘Staking confirmation’ window appears. Enter the wallet password and click ‘Confirm’.

![Staking notification](images\04-05-05.png)

This notification confirms that ada is staked to the selected pool. Clicking ‘Overview’ at the top of the ‘Staking’ window displays the pool’s details.
![Staking overview screen](images\04-05-06.png)

The information includes the amount of ada staked to the *BNTY1preprod* pool, some pool details, and the total rewards received. The rewards will remain at zero until 15 to 20 days elapse. There is also a message notifying that voting power must be delegated to spend the staking rewards earned. The *Participate in Cardano governance with Lace* lesson explains this in detail*.*

The ‘Manage’ button on the right-hand side reopens the ‘Manage staking’ screen. Users can add new pools and rebalance their portfolio. In that case, users will continue receiving staking rewards from their current pool until they start receiving rewards from the *new* stake pool or pools. Users can also stop delegating to their chosen pool by clicking ‘Remove pool from portfolio’. There is no need to withdraw staking rewards before switching stake pools. If the user receives some new ada in their wallet, it will be automatically staked to their chosen pool/pools. Additionally, if the user sends some ada to another address, Lace will automatically rebalance the delegation.

A stake pool on testnet can have a different name than the stake pool operated by the same SPO on mainnet. Additionally, the stake pool parameters (fee and margin) may differ on the mainnet. Check out the [Lace FAQ](https://www.lace.io/faq) to learn more about staking and multi-staking.
