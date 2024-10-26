// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";

import {Constants} from "./base/Constants.sol";
import {Counter} from "../src/Counter.sol";
import {HookMiner} from "../test/utils/HookMiner.sol";
import {ERC20} from "solmate/src/tokens/ERC20.sol";

/// @notice Mines the address and deploys the Counter.sol Hook contract
contract CounterScript is Script, Constants {
    function setUp() public {}

    function run() public {
        // // hook contracts must have specific flags encoded in the address
        // uint160 flags = uint160(
        //     Hooks.BEFORE_SWAP_FLAG | Hooks.AFTER_SWAP_FLAG | Hooks.BEFORE_ADD_LIQUIDITY_FLAG
        //         | Hooks.BEFORE_REMOVE_LIQUIDITY_FLAG
        // );

        // // Mine a salt that will produce a hook address with the correct flags
        // bytes memory constructorArgs = abi.encode(POOLMANAGER);
        // (address hookAddress, bytes32 salt) =
        //     HookMiner.find(CREATE2_DEPLOYER, flags, type(Counter).creationCode, constructorArgs);

        // // Deploy the hook using CREATE2
        // vm.broadcast();
        // Counter counter = new Counter{salt: salt}(IPoolManager(POOLMANAGER));
        // require(address(counter) == hookAddress, "CounterScript: hook address mismatch");

        vm.startBroadcast();
        // Token deploy (USDC, USDT)
        USDC usdc = new USDC();
        USDT usdt = new USDT();

        usdt.approve(address(0xf9648701849166628A0968C1c2d4C3bfeFbb8Ac0), ~uint256(0));
        usdc.approve(address(0xf9648701849166628A0968C1c2d4C3bfeFbb8Ac0), ~uint256(0));
        usdc.approve(address(POOLMANAGER), ~uint256(0));
        usdt.approve(address(POOLMANAGER), ~uint256(0));
        vm.stopBroadcast();
    }
}

// contract USDC
contract USDC is ERC20 {
    constructor() ERC20("usdc", "USDC", 6) {
        _mint(msg.sender, 1000000000000000000000000000);
    }
}
// contract USDT

contract USDT is ERC20 {
    constructor() ERC20("usdt", "USDT", 6) {
        _mint(msg.sender, 1000000000000000000000000000);
    }
}
