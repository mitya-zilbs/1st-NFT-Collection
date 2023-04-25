# 1st-NFT-Collection
This NFT collection is an example built out from a lesson by LearnWeb3 DAO, deployed on the Sepolia testnet using localhost.
<br></br>
![image](https://user-images.githubusercontent.com/99213972/234171289-71f3b5b7-9d52-4f52-892e-820016858f78.png)
<br></br>
This dApp is a simple React app that mints 20 Crypto Dev NFTs, launches a presale, and then transitions to a public sale once the presale ends. 
It uses the whitelist contract as a means of determining who is on the whitelist and eligible for the presale, and the CryptoDevs contract for minting the NFTS.
The owner of the deployed contracts is able to start the presale, which lasts 5 minutes before it transitions to a public sale. 
Each NFT costs .01 ETH, and 20 are minted when the CryptoDevs contract is deployed.
<br></br>
<h3>Deployment Steps</h3>
Prerequesite: The whitelist contract must be deployed before the cryptoDevs, as index.js file only deploys cryptoDevs contract
Dependencies: 
npm init --yes
npm install --save-dev hardhat,
--save-dev @nomicfoundation/hardhat-toolbox,
@openzeppelin/contracts,
dotenv,
next,
web3modal,
ethers@5 (Web3Provider doesn't work after v5),
