### Lesson 4: Where Does the Reward Money Come From?

The incentives have to be funded from somewhere. In Cardano, the reward money comes from two main sources.

#### **1\. Transaction Fees**

Every time someone makes a transaction on Cardano, they pay a small fee. This fee has two jobs:

* **Preventing Attacks:** It makes it prohibitively expensive for an attacker to flood the network with junk transactions (a DDoS attack), because a small flat fee applies to every single transaction, no matter how small the amount being sent. Interestingly, the fee is based on the transaction's size in bytes, not the amount of ADA being sent. A transaction of 10 million ADA costs only slightly more than one sending 10 ADA, because the number takes a few more bytes to write down.

* **Funding Rewards:** These fees are collected and added to the rewards pot for the epoch.

#### **2\. Monetary Expansion**

Cardano has a maximum supply of billion ADA, but only 31 billion were in circulation at the start. The remaining 14 billion ADA were placed in the **ADA Reserves** to fund rewards and the treasury.

Every epoch (which is five days), a small, fixed percentage (ρ, a protocol parameter) of the remaining reserves is added to the rewards pot. This process is called **monetary expansion**.

Because the percentage is taken from the *remaining* reserves, the amount of ADA from this source gradually decreases over time. Let's look at a simplified example where

ρ=1%:

* **Epoch 1:** 1% of 14 billion \= 140 million ADA in rewards.

* **Epoch 2:** Remaining reserves are 13.86 billion. 1% of that \= 138.6 million ADA in rewards.

* **Epoch 3:** Remaining reserves are \~13.72 billion. 1% of that \= \~137.2 million ADA in rewards.

This decline is very gradual in the real system. The hope and expectation is that as Cardano's usage grows, the income from transaction fees will increase, making up for the decline in rewards from monetary expansion and creating a sustainable system for the long term.

#### **Where to go next?**

* [Back to the Top](Incentives.md)
* Lesson 3: [The "Goldilocks" Configuration](lesson-3.md)
* Lesson 5: [How Rewards Are Shared](lesson-5.md)
