### Lesson 6: The "Refinements" \- Fine-Tuning for Fairness

The basic idea is that a pool's rewards should be proportional to its stake. However, this simple idea on its own leads to several problems.

#### **Problems with the Basic Idea**

* **Large Pools:** If rewards are purely proportional to stake, operators have an incentive to merge pools to save on costs, just like in Bitcoin. This leads to centralization.

* **Being Online:** If rewards are based only on stake and not performance, a pool operator has no financial incentive to make sure their node is online to produce its assigned blocks.

* **Sybil Attacks:** An attacker could create hundreds of "attractive" pools with low fees to try and capture a majority of the network's stake. This is called a

  **Sybil attack**.

To solve these problems, Cardano's design adds three crucial "refinements" to the basic reward formula.

#### **Refinement 1: Discouraging Giant Pools**

To prevent pools from getting too big, there's a cap on the rewards they can earn. A single pool cannot earn more than

1/k of the total rewards pot in an epoch.

If a pool becomes

**saturated** (meaning it has more than 1/k of the total staked ADA), it still only gets 1/k of the rewards. This means the rewards for each delegator in that pool

*decrease*. For example, if a pool is three times the size of a non-saturated pool, its rewards will only be twice as large. A single ADA staked in the large pool will earn less than one staked in the smaller pool. This creates a gentle but effective financial nudge for delegators to move their stake to a smaller, more profitable pool.

#### **Refinement 2: Rewarding Performance**

To ensure pools do their job, rewards are adjusted by a

**performance factor**. A pool that misses half its blocks should only receive half its rewards.

But there's a twist\! On Cardano, leader election is private; only the pool operator knows they've been chosen. So how do we know how many blocks a pool

*should* have produced? We

**estimate** it\!90. We know a pool's chance of being elected is proportional to its stake, and we know the average number of blocks in an epoch (around 21,600)919191919191919191. By combining these, we can estimate a pool's expected block production and compare it to its actual production92. Because this is based on probability, a pool can get lucky and have an

*estimated* performance over 100%, but this averages out over time93.

#### **Refinement 3: Preventing Sybil Attacks**

To defend against Sybil attacks, Cardano uses the concept of a

**pledge**94. When an operator registers a pool, they must declare a pledge—a certain amount of their own ADA that they will delegate to their own pool95. If an operator fails to meet their pledge, the pool earns

**no rewards at all**.

If the pledge is honored, the pool's rewards will depend on the size of that pledge—the higher the pledge, the higher the rewards the pool can offer. The magnitude of this effect is controlled by a protocol parameter called

a0.

---

**\[ILLUSTRATION GOES HERE: pledge.png \- A graph showing that rewards rise with stake, but the rate of that rise and the maximum potential reward are higher for pools with a higher pledge.\]**

---

This system forces an attacker to have significant "skin in the game." To launch a Sybil attack, they would have to split their own funds among many pools, resulting in a low pledge for each one. These low-pledge pools would be less attractive to delegators because they'd offer lower rewards, foiling the attack.

#### **Where to go next?**

* [Back to the index](../README.md)
* Lesson 5: [How Rewards Are Shared](lesson-5.md)
* Lesson 7: [The Beauty of Game Theory](lesson-7.md)
