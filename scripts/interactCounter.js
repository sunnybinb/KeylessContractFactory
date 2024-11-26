const { ethers } = require("hardhat")

async function main() {
    address = "0x2925BCA3CCA12d69EBCf5a0839b3b54AF46fF27B"

    const contract = await ethers.getContractAt(
        "UpgradableCounter",
        address
    )
    
    console.log(await contract.count())
    console.log(await contract.owner())

    
}

main()
