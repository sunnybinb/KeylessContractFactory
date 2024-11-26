const { ethers, network } = require("hardhat");



async function main() {
    const UpgradableCounter = await ethers.getContractFactory("UpgradableCounter");
    const UpgradableCounterContract = await UpgradableCounter.deploy();
    
    const implAddr = UpgradableCounterContract.target;
    console.log("UpgradableCounter Impl deployed to:", implAddr);
    
    //const implAddr = "0x70351dBF4Cf8e01b961424271adeC4b93a3ADA48";
    const proxy_bytecode = (await ethers.getContractFactory("ERC1967Proxy")).bytecode;

    //without constructor arg
    const initializeData = UpgradableCounter.interface.encodeFunctionData(
        "initialize"
    );
    
    //with constructor arg
    const initializeData_arg = UpgradableCounter.interface.encodeFunctionData(
        "initializeWithArg",
        [10,"0x0000000000000000000000000000000000000123"]
    );
    
    const constructorArgs = ethers.AbiCoder.defaultAbiCoder().encode(
        ["address", "bytes"],
        [implAddr, initializeData]
    );
    //console.log(constructorArgs);

    //final bytecode
    //same with ethers.solidityPacked
    const bytecode = ethers.concat([
        proxy_bytecode,
        constructorArgs
    ]);

    const factoryAddr = "0xf8A4dCAcF0E604Ebc17975b984C13bF2cD540aA7"
    const Factory = await ethers.getContractAt("ContractFactory", factoryAddr);

    //const salt = ethers.hexlify(ethers.randomBytes(32));
    //console.log("Salt:", salt);
    const salt = "0x288d8e9bfe3b966988469195933a1fdc33835a80a97f523a0831e930fafbea61"
    const tx = await Factory.deploy(salt,bytecode);
    await tx.wait()
    console.log("Proxy deployed Done");

}



main().catch(error => {
    console.error(error)
    process.exitCode = 1
})

