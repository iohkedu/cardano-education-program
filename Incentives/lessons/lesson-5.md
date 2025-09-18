### Lesson 5: How Rewards Are Shared

Once every five days (one epoch), all the transaction fees and the ADA from monetary expansion are collected into a virtual "rewards pot".

First, a slice of this pot (a percentage called

τ) is sent to the **treasury**. The treasury is a decentralized fund that can be used to pay for future development and improvements to the Cardano ecosystem. The rest is then distributed among the stake pools.

#### **Splitting the Spoils in a Pool**

Once a stake pool gets its reward, how is it divided? Let's follow the money step-by-step.

1. **Operator Costs:** The pool operator first takes a fixed amount of ADA to cover their expenses. They declare this cost when they register the pool.

2. **Operator Margin:** The operator then takes a percentage (the *margin*) of what's left. This is their profit for running the pool.

3. **Delegator Rewards:** Everything that remains is then distributed among all the people who delegated to the pool61. A delegator's share is proportional to the amount of ADA they delegated62. The pool operator is also a delegator to their own pool, so they receive a proportional share on top of their costs and margin.

Let's walk through the example from the book:

* A pool earns  
  **1,000 ADA** in rewards.

* The operator, Alice, has set her fixed costs at  
  **200 ADA** and her margin at **1%**.

* Alice has delegated 100,000 ADA, Bob has delegated 200,000 ADA, and Charlie has delegated 300,000 ADA to her pool.

Here is the distribution:

1. Alice first takes her  
   **200 ADA** fixed cost. The pot now holds 800 ADA.

2. Next, Alice takes her 1% margin from the remainder: 1% of 800 ADA is  
   **8 ADA**. The pot now holds 792 ADA.

3. The final  
   **792 ADA** is split among Alice, Bob, and Charlie proportional to their stake (in a 1:2:3 ratio).

   * Alice gets 1/6 of 792 \=  
     **132 ADA**.

   * Bob gets 2/6 of 792 \=  
     **264 ADA**.

   * Charlie gets 3/6 of 792 \=  
     **396 ADA**.

In total, Alice received 200 \+ 8 \+ 132 \=

**340 ADA**. Bob received

**264 ADA**, and Charlie received **396 ADA**.

#### **Where to go next?**

* [Back to the index](../README.md)
* Lesson 4: [Where Does the Reward Money Come From?](lesson-4.md)
* Lesson 6: [The "Refinements" \- Fine-Tuning for Fairness](lesson-6.md)
