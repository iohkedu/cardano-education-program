## **Cryptography**

In this modern era, very few things are not digital. Cryptography is the backbone of security for all digital infrastructures. It is the practice and study of techniques for secure communication in the presence of adversaries​. In simple terms, it provides methods to protect information and ensure it can be read or used only by intended parties. Cryptography has been a part of human communication for thousands of years as ciphers, long before the advent of computers. So let's dive into what blockchains use from cryptography.

### Stamp = Hash

The so called magical stamps we talked before is actually hash functions. Hash is something that appears to be a seemingly random value, but it is actually deterministic output of hash functions. Even a tiny bit of change results in completely different and unpredictable output but given the same input, it will create the same hash. It keeps integrity which means that no data is modified, not even one bit.

There are many hash functions and for examples below, SHA256 function is used.  
Hashing a text **"Hello Cardano!"** would give a hash `31145d2fdcd6d3c35d4e675c15574a67f94d03682d742996bc400dd0eb36b214`.  
In contrast, **"Hello Cardano"** text gives `c6eee28483846f2c831700e1135c143ace1779247f2a8a4c7ec95089ffec258b`.  
Or **"HelloCardano!"** => `769c5e4d024fb3c1867eed576cd84c28892f82d3504484f7abf71ad708fe1396`

A property of hash function is that it's output is fixed length but can take any lengths of input. It's apparent that with infinite possibilities on input side and being limited on output side, would cause conflicts because it's definitely possible to have 2 different inputs having same hash output. That is called **hash collision**. If one can find another input for any given hash, they can effectively claim something different is the original because the victim is convinced that integrity is still standing and the content isn't changed but in fact, it is. See **Entropy** to understand why it doesn't happen in practice.

### Public Key cryptography

Public key cryptography has 2 key pairs which serves the purpose of authentication that allows you to prove that it is actually you. One is public key and the other is private key. The main idea behind it is that you can safely disclose public key as an address without revealing private key.

### Digital Signature

No one should be able to spend others' cryptocurrency freely or do anything on behalf of others without owner's permission. So digital signature is the proof that owner permitted the action or agreed with what is signed, just like real signature handwritten on paper. Private keys are used for signing and creating signature whereas public keys are used to verify the signature is really signed by the signer. You might have noticed that cryptographic actions like signing here, is done with private keys and public keys are used for validation. That way, private keys are prevented from any risks of being revealed and public keys take all the exposure as it's not possible to figure private key out from public key, although it's a pair and one corresponds to the other.

Let's use a tool [here](https://emn178.github.io/online-tools/ecdsa/key-generator/) for an example below with default settings.

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

For [signing](https://emn178.github.io/online-tools/ecdsa/sign/), we will use a hypothetical message "Send Tom 1,000,000 ada".

The signature comes out as:
`3045022100d58fd9479c9182abfc62b4dd024e71ccca3e8ccbe30746c5a881df24322327a902200c90f99308728ec61b711bfb128d792a7aa53004c71a7d57d67516d22e2b1931`

And for [verification](https://emn178.github.io/online-tools/ecdsa/verify/), using the public key and the signature above, for a text "Send Tom 1,000,000 ada", the signature is verified and it shows valid.

### Mnemonic phrase (AKA Seed phrase)

The private key is everything and since it's very long even in hexadecimal numbers, saving it as is, is a problem. Especially on paper, it can easily be ripped, wet, burnt. Losing few characters could make it very hard to recover like days, months or even years. So there are standard sets of words called mnemonic phrases. It's a set words, carefully chosen in a way that if you lose either the beginning, middle or ending letters somehow, it's easily identified which word was it.

### Entropy

What's stopping someone to come up with hash collision to wreak havoc? Or in another case, if blockchain is transparent, distributed, decentralized where anyone can access and participate freely and equally, what's making sure that my money is mine and my identity is mine? Well, it's my private key, right. Then it begs the question of what is a private key. To put it simply, it's just a number.

However, there is a nuance to it. Everyone has agreed and been following crystal clear consensus rules which is public information. If there were an username and a password like accessing bank accounts, everyone also has to know them because there is no central authority to store them in order to authenticate. Additionally, it's not only that each participant follows consensus rules but they all uphold them so everyone saving everyone's password for the purpose of identifying each other later on is complete nonsense. So how to make it entirely publicly available which means everyone knows everything but kept private by individuals to distinguish themselves. The answer is entropy and what that means is that everyone knows it all and there is no secret but it's almost impossible to guess other people's choices among enormous possibilities.

Here is a real life example, everyone knows credit cards have 4 (sometimes 6) digit pin code which is only 1000 possibilities except there are only 3 tries. The chances of finding the correct pin code in 3 attemps are very low. In the case of blockchain, there is no company to enforce limits. Seeing private keys are just numbers, the only way to make it safe against guessing while making the rules known is to have it astronomically large. So much so that it's not practically possible to find the right one even with the help of computers and state of the art computational devices.

For instance, hash functions or public key pairs with 2<sup>256</sup> entropy would mean there are 2<sup>256</sup> possibilities in total. Even though human brain is truly a masterpiece, it just doesn't grasp how large a number is from certain point. Let's take an example of how different are a million and a billion.

* a million seconds => 11 days, 13 hours
* a billion seconds => 31 years, 251 days

It's a difference of only 3 zeroes.  
Now the number 2<sup>256</sup> has **78** digits.

The most abundant thing on Earth is sand and according to scientists, our planet has approximately **7.5 x 10<sup>18</sup>** of grains of sand. That leaves 59 digits of difference. Probably, the only thing that's larger is atoms in the whole observable universe which is estimated to be about **10<sup>80</sup>**.

To put it in perspective, how hard it is to guess one among 2<sup>256</sup> numbers, let's try with all the computers and supercomputers combined. Even with such computational power, it would take more time than the entire history of the cosmos. If we began guessing at the big bang, the creation moment of the universe, we still wouldn't have found it by now. That's how it is and how no one in practice can guess your private key or break hashes. If you lose your private key or expose it then your cryptocurrencies are lost forever or stolen, respectively. It's like a door without any locks placed somewhere in the universe and it's location keeps it safe.

*Fun fact*: Satoshi Nakamoto, the unknown creator of bitcoin, is proven to have more than 1 million bitcoins. If you can guess the number (or the private key, same thing) for Satoshi's address (public key) or any other address holding over a million dollars worth of assets, you will be able to take them. But it's so large and the chances are too, too low that i would strongly advise you not to waste much time by doing so.

#### **Where to go?**

* Back to lesson 4: [Decentralization](./4-decentralization.md)
* Next, Lesson 6: [Consensus](./6-consensus.md)
* [Index](../README.md)