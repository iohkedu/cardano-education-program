# 6.2 Creating tokens and NFTs

Artists who create physical or digital paintings can sell their artwork on exchanges. They attach their painting as an image to the tokens. Often, they choose to use an NFT to make it rarer. On Cardano, the image can be encoded into the NFT's metadata or linked from [IPFS](https://en.wikipedia.org/wiki/InterPlanetary_File_System), which is a blockchain used for sharing decentralized data. Through IPFS, short videos can also be associated with NFTs. NFT exchanges may offer the ability to create NFTs through their platform. In this case, an artist simply has to upload the image, pay the fee, and the NFT gets created by the exchange. To create an NFT with an image on Cardano, users can visit the [Cardano tools](https://cardano-tools.io/mint) web page. You can use this page to mint NFTs and tokens on both test networks and the main network. At the top of the page, users can click *Connect your wallet* and select Lace.

![Cardano Tools Mint NFT page screenshot](images\06-02-01.png)

The ‘Authorize DApp’ window facilitates the connection of Lace with the DApp. Click  ‘Authorize*’*.
![Authorize DApp window screenshot](images\06-02-02.png)

A confirmation window appears, allowing you to choose whether always to allow this DApp to connect to your wallet without confirmation or to connect only this time.  

![Confirmation window screenshot](images\06-02-03.png)

In this example,  click ‘Only once*’*. After connecting the wallet, the balance becomes visible.

![Wallet balance visible after connecting](images\06-02-04.png)

Next, upload an image and set the NFT name.

![Uploading an image and setting NFT name screenshot](images\06-02-05.png)

For this demonstration, the Plutus smart contract language logo in .svg format is used (.jpg or .png formats are also valid). Make sure the NFT toggle is on and click  ‘Mint*’*. If the toggle was off, we could set the amount of tokens to mint. The transaction confirmation window displays the transaction information, including the fee. Click ‘Confirm’.

![Transaction confirmation window screenshot](images\06-02-06.png)

Enter the wallet password to confirm the transaction.

![Wallet password entry screenshot](images\06-02-07.png)

After the transaction is carried out, the NFT is visible in the wallet’s NFTs view.

![NFT visible in wallet’s NFTs view](images\06-02-08.png)

Clicking the NFT displays its details.

![NFT details view screenshot](images\06-02-09.png)

The policy ID, which represents the hash of the minting policy and the asset ID, is visible. A closer look reveals that the policy ID is *included* in the asset ID. The remaining part of the asset ID is the name of the token, represented in [hexadecimal form](https://simple.wikipedia.org/wiki/Hexadecimal). Additionally, the media’s URL is displayed, along with the image data encoded as a base64 string. Users can click ‘Set as your wallet avatar’ if they wish for this image to appear in the ‘Settings’ button. Users can send the NFT to another wallet by clicking ‘Send NFT*’*.

Besides NFTs, Lace can also display other tokens in the ‘Tokens*’* screen, which also displays ada.

![Tokens screen screenshot](images\06-02-10.png)

Clicking a token displays its information.

![Token information screenshot](images\06-02-11.png)

If the token has a name, it will be shown. Else, Lace displays a shortened fingerprint at the top. It also displays the token balance, full fingerprint, and policy ID. The fingerprint is computed from the policy ID and token name (if a name exists). It is a shorter identifier for assets that users can recognize and refer to when talking about assets. The rules for computing fingerprints are defined in [CIP-14](https://cips.cardano.org/cip/CIP-14).
