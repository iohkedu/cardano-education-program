## Cryptography

Today, almost everything exists in digital form – and cryptography is what keeps it secure. It is the science and practice of protecting information by ensuring that only intended parties can access or understand it, even in the presence of adversaries. In simple terms, cryptography provides tools and methods to safeguard communication and data. Although it underpins modern digital systems, the concept itself is ancient – people have used ciphers and secret codes for thousands of years. 

Let’s now explore how blockchain technology relies on cryptography to ensure trust and security.

### Stamp = hash

The so-called magical stamps we discussed earlier are actually hash functions. A hash may look like a random string of numbers and letters, but it’s actually a *deterministic* result of a mathematical function. This means that even the slightest change in the input produces a completely different and unpredictable output, while the same input will always produce the same hash. This property helps preserve data integrity, ensuring that nothing in the data – not even a single bit – has been altered.

There are many types of hash functions. The examples below use the SHA256 function.

Hashing the text ‘**Hello Cardano!**’ produces the hash: `31145d2fdcd6d3c35d4e675c15574a67f94d03682d742996bc400dd0eb36b214`.
In contrast, ‘**Hello Cardano**’ results in: `c6eee28483846f2c831700e1135c143ace1779247f2a8a4c7ec95089ffec258b`,
while ‘**HelloCardano!**’ gives: `769c5e4d024fb3c1867eed576cd84c28892f82d3504484f7abf71ad708fe1396`.

A key property of a hash function is that its output has a fixed length, no matter how long the input is. However, since the possible inputs are infinite and the outputs are limited in size, two different inputs could, in theory, produce the same hash. This rare event is called a **hash collision**. If someone could find a different input that generates the same hash, they could deceive others into believing that the data’s integrity remains intact, even though it has been altered. See **Entropy** to understand why such collisions do not occur in practice.

### Public key cryptography

Public key cryptography uses a pair of keys for authentication. One is a *public* key, and the other is a *private* key. The main idea is that you can safely share your public key as an address while keeping your private key secret.

### Digital signature

No one should be able to spend someone else’s cryptocurrency or act on another person’s behalf without permission. A digital signature proves that the owner has approved an action or agreed to what is being signed, much like a handwritten signature on paper.

A private key is used to create the signature, while a public key is used to verify that it’s genuine. As you may have noticed, cryptographic actions such as 'Sign here' are performed with private keys, while public keys are used for verification. This design keeps private keys safe from exposure, as a public key can never be used to determine the private key — even though they are mathematically linked.

Let's use [this tool](https://emn178.github.io/online-tools/ecdsa/key-generator/) for the example below. Keep the default settings, and it will generate a pair of keys – one public and one private.

Private key:

```
-----BEGIN PRIVATE KEY-----
MIGEAgEAMBAGByqGSM49AgEGBSuBBAAKBG0wawIBAQQg+NbrSLAWknPG827kTzbu
Xg8UQexCrWKmAbUGb6HR1rGhRANCAAQLSKY4AgqNtm22GSPtPtKiHayeGHZw5/r8
j4KlUsNvIdJArM0gsS2nEbSzRVKq5usf6sQoFmgVOD1CNbDPPBpk
-----END PRIVATE KEY-----
```

Public key:

```
-----BEGIN PUBLIC KEY-----
MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEC0imOAIKjbZtthkj7T7Soh2snhh2cOf6
/I+CpVLDbyHSQKzNILEtpxG0s0VSqubrH+rEKBZoFTg9QjWwzzwaZA==
-----END PUBLIC KEY-----
```
For [signing](https://emn178.github.io/online-tools/ecdsa/sign/), let’s use a hypothetical message: *Send Tom 1,000,000 ada*.

The generated signature looks like this:
`3045022100d58fd9479c9182abfc62b4dd024e71ccca3e8ccbe30746c5a881df24322327a902200c90f99308728ec61b711bfb128d792a7aa53004c71a7d57d67516d22e2b1931`.

Next, open the [verification](https://emn178.github.io/online-tools/ecdsa/verify/) page. Using the public key and the same message (*Send Tom 1,000,000 ada*), the tool confirms that the signature is valid.

### Mnemonic phrase (also known as seed phrase)

The private key is very important, but it’s also very long. Even when written in hexadecimal form, which makes it difficult to store safely, writing it down on paper can be risky, as the paper could get torn, wet, or burned. Even losing a few characters could make recovery almost impossible.

To solve this, there are standard sets of words called *mnemonic phrases*. These are groups of carefully selected words designed so that – even if part of a word is smudged or unclear – it’s still possible to identify the correct one.

### Entropy

What stops someone from creating a hash collision and causing chaos? Or, if a blockchain is transparent, distributed, and decentralized – where anyone can access and participate freely – what ensures that one's money and one's identity truly belong to them? It all comes down to the private key. But what is a private key? Simply put, it’s just a number.

There’s more to it, though. Everyone in the network follows clear consensus rules that are public and open to all. If blockchain worked like a system with usernames and passwords, everyone would have to know everyone else’s credentials – because there’s no central authority to store or verify them. That clearly wouldn’t make sense. So how can everything be public, yet each person still keep their identity private? The answer is *entropy*. This means that while all the rules are known, the possible combinations of numbers are so vast that it’s practically impossible to guess someone else’s private key. Everyone plays by the same open rules, but their individual choices remain secure within that enormous space of possibilities.

Here’s a real-life example. Everyone knows that credit cards have a four-digit (sometimes six-digit) PIN code, which gives only about a thousand possible combinations – but there are only three tries. The chance of guessing the correct PIN in three attempts is very low. In blockchain, however, there’s no company to enforce such limits. Because private keys are just numbers, the only way to keep them safe from guessing, while keeping the rules public, is to make the number space astronomically large. So large, in fact, that finding the right one isn’t practically possible, even with advanced computers or state-of-the-art technology.

For instance, hash functions or public key pairs with 2<sup>256</sup> entropy would mean there are 2<sup>256</sup> possibilities in total. Even though the human brain is truly a masterpiece, it often struggles to comprehend the magnitude of a large number from a particular perspective. Consider this comparison:

* One million seconds – about 11 days and 13 hours
* One billion seconds – about 31 years and 251 days.

That’s a difference of just three zeroes. Now the number 2<sup>256</sup> has **78** digits.

The most abundant thing on Earth is sand, and scientists estimate there are about **7.5 x 10<sup>18</sup>** grains of it on our planet. That’s a difference of 59 digits. The only thing larger might be the number of atoms in the entire observable universe – estimated at around **10<sup>80</sup>**.

To put it in perspective, consider how difficult it is to guess one among 2<sup>256</sup> numbers. Let's try to do it with all the computers and supercomputers combined. Even if every computer and supercomputer on Earth worked together, it would still take longer than the entire history of the universe. If we had started guessing at the moment of the Big Bang, we still wouldn’t have found the right one by now. That’s why, in practice, no one can guess a private key or break a hash. If a private key is lost or exposed, the outcome is final – the associated cryptocurrencies are lost forever or can be stolen. It’s like having a door without a lock placed somewhere in the universe – its safety lies in the impossibility of finding it.

*Fun fact*: Satoshi Nakamoto, the unknown creator of Bitcoin, is believed to hold more than one million bitcoins. If someone could guess the number – that is, the private key – for Satoshi’s address or any wallet holding millions of dollars in assets, they could take those funds. But the chances are so astronomically small that it’s simply not worth trying.

### Further reading:

* Back to lesson 4: [Decentralization](./4-decentralization.md)
* Next lesson: [Consensus](./6-consensus.md)
* [Index](../README.md).
