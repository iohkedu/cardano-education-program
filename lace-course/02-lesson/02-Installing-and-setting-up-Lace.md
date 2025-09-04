# 2. Installing and setting up Lace 

This lesson covers the procedure for installing and setting up Lace, a lightweight Cardano wallet. If you already have a Cardano crypto wallet and want to start using Lace, refer to the last section, [*Restoring an existing wallet*](https://github.com/iohkedu/cardano-education-program/blob/lace-course/lace-course/02-lesson/02-Installing-and-setting-up-Lace.md#23-restoring-an-existing-wallet). 

The name Lace is derived from the name Lovelace, which was the last name of Ada Lovelace, a 19th-century English mathematician and writer who wrote the world's first computer program. She realized that computers would be able to do more than just calculate or perform number crunching (source: [simple wiki](https://simple.wikipedia.org/wiki/Ada_Lovelace)). Cardano’s native currency is called ada, which is divided into lovelace. One million lovelace represents one ada. 

We note that there are other wallets in the Cardano ecosystem, including: 

* [Yoroi](https://yoroi-wallet.com/), a lightweight wallet developed by Emurgo, a founding entity of Cardano   
* [Etrnl](https://eternl.io/), a lightweight wallet developed by a company from the Cardano ecosystem   
* [Daedalus](https://daedaluswallet.io/), a full-node wallet developed by IO. 

## 2.1 How to install Lace

At the time of writing, Lace is supported in Google Chrome, Edge, and Firefox browsers. Lace can also be installed on Chromium-based browsers, such as Brave; however, this has not been officially tested. The safest way to install Lace is to visit the [lace.io](http://lace.io) website. The **Add to browser** button at the top right corner leads to the Lace browser extension in the Chrome, Microsoft, and Firefox web stores. In the Chrome web store, you can also see a blue checkmark, and the tooltip explains why this browser extension is safe. Click **Install** and locate your extension in the *Extensions* settings page after installation. 

Once Lace is installed, it will get automatically updated. You will see a notification window after opening Lace if the wallet has been updated, which will also list new features of Lace. You can check the Lace version in your browser’s Extensions settings window.  

## 2.2 How to set up a new Lace wallet 

Once Lace is installed as a browser extension, open the wallet from your Extensions settings page. The following screen will appear:  

![Lace options for wallet setup][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-01.png]

Lace provides us with three options:  

* To create a new Cardano wallet  
* To connect a hardware wallet, such as Trezor or Ledger  
* To restore a Cardano wallet from the secret seed phrase. 

Choosing any of the three options means you agree to Lace’s terms of service and privacy policy. You can view the documents by clicking the links in the notification text at the bottom. Click **Create**. The recovery method option appears. 

![Recovery method options][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-02.png]

Choose whether to generate a 24-word recovery phrase or a scannable QR code encrypted with a PGP key. In this tutorial, we will select the recovery phrase. Click **Next** to create your recovery phrase. 

![Recovery phrase][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-03.png]

In the image above, the recovery phrase is hidden. Write down the recovery phrase on durable paper or a metal crypto wallet. For paper, it is recommended to make two copies and store them in two separate, safe locations. It is not recommended to use the *copy to clipboard* option. If you have malware installed that accesses your clipboard and shares this data with a remote computer, the seed could be leaked. If you are using this feature, Lace provides a link to the [best practices guide](https://www.lace.io/faq?question=best-practices-for-using-the-copy-to-clipboard-paste-from-clipboard-recovery-phrase-features) for safe usage of the clipboard feature. Click **Next** and the window for entering the recovery phrase appears. 

![Enter recovery phrase][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-04.png]

When typing in the recovery phrase words, use the Tab key to autocomplete a single word. As mentioned in the [*Key generation for wallets*](https://github.com/iohkedu/cardano-education-program/blob/lace-course/lace-course/01-lessons/01-Introduction-to-blockchain-and-wallets.md#15-key-generation-for-wallets) section, the first four letters unambiguously define a seed word. After entering the last word, Lace will check if the last word, which contains the checksum of previously input data, is correct. Then, click **Next** and the wallet setup window appears.    

![Wallet name and password][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-05.png]

Now you need to create a password. When entering the password, a progress bar will appear to indicate its strength. If the password is too weak, Lace will not allow you to set up your wallet. The password must then be reentered. After that, you can click **Open wallet**, and the main page of the Lace wallet will appear. 

![Tokens welcome screen][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-06.png]

You can now see the main wallet screen, which displays your current balance and a welcome message. The page also shows the wallet address, which in our case is: 

```shell
addr1qyh8v5qqcqfhfpkv8sxjxulw09m24r3ac6uns49cpwfndy0tdewcc2l3v2reur6jl2amk2jnfr6klgjjlyx29qpd0e0qtv4mld
```

You can also use the scannable QR code to get your address. Close Lace and try to reopen it from the browser’s *Extensions* menu. The following window will appear: 

![Lace wallet in small format][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-07.png]

You can use your wallet in this format, or expand it to full screen by clicking the four arrows. Sometimes, when opening the wallet, a notification appears that provides information about a new version. 

![Lace notification message][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-02-08.png]

## 2.3 Restoring an existing wallet

After installing the Lace extension, you have the option to restore an existing wallet. If you click **Restore** on the introduction screen, you can choose to restore your wallet from either a recovery phrase or a paper wallet. This section explains how to restore it from a recovery phrase. 

![Recovery method choice][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-03-01.png]

After clicking **Next**, a window appears to select the password length and enter the seed phrase. 

![Enter recovery phrase][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-03-02.png]

Type in your recovery phrase. The process is the same as outlined earlier. Then, click **Next**, and the wallet setup window appears.  

![Wallet name and password][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-03-03.png]

Give your wallet a name and set up a password. When entering the password, a progress bar will appear to indicate its strength. Choose a strong password and proceed by clicking **Open wallet**. 

![Tokens welcome screen][https://github.com/iohkedu/cardano-education-program/blob/lace-course/images/2/02-03-04.png]

You can now view the main wallet screen, which displays your current balance and a welcome message. The page also shows the wallet address, which in our case is: 

```shell
addr1qyh8v5qqcqfhfpkv8sxjxulw09m24r3ac6uns49cpwfndy0tdewcc2l3v2reur6jl2amk2jnfr6klgjjlyx29qpd0e0qtv4mld
```

You can also scan the QR code to get your address. In the next lesson, we will demonstrate how to receive and send some test ada. 
