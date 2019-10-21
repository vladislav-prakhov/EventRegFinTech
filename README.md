# EventRegFinTech
event registration ethereum dapp

Now it works with Ganache localhost  

Install ganache  
Open remix.ethereum.org  
Deploy smart contract in ganache network  

Get deployed smart contract address and add it in variable **contractAddress** in **index.html**  
Check also ganache localhost variable  
`let web3 = new Web3("http://localhost:7545");`  
`let contractAddress = '0x3564e0c1aa2e887dafc64e8f1600e26822671308';`   
Save

**Open html page in browser**

In app you can
1) Add new event with description in smart contract
2) Register person with passport number
3) Check registration status by passport number
