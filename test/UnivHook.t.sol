// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";

// about Router and Token
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {PoolSwapTest} from "v4-core/src/test/PoolSwapTest.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";

// about poolmanager
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PoolManager} from "v4-core/src/PoolManager.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";

// about Quoter
import {IQuoter} from "v4-periphery/src/interfaces/IQuoter.sol";
import {Quoter} from "v4-periphery/src/lens/Quoter.sol";

// library
import {Currency, CurrencyLibrary} from "v4-core/src/types/Currency.sol";
import {PoolId, PoolIdLibrary} from "v4-core/src/types/PoolId.sol";
import {StateLibrary} from "v4-core/src/libraries/StateLibrary.sol";

// Hook contract
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {Hooks} from "v4-core/src/libraries/Hooks.sol";
// import {UnivHook} from "../src/UnivHook.sol";

contract UnivHookTest is Test, Deployers {
    // Use the libraries
    using StateLibrary for IPoolManager; // for tick info
    using PoolIdLibrary for PoolKey; // for poolid
    using CurrencyLibrary for Currency; // for currency

    // The two currencies (tokens) from the pool
    // Currency currency0;
    // Currency currency1;

    PoolId poolid;
    PoolKey poolkey;
    Quoter quoter;

    // UnivHook hook;

    function setUp() public {
        // Deploy v4 core contracts
        deployFreshManagerAndRouters();
        // manager = new PoolManager();
        // swapRouter = new PoolSwapTest(manager);
        // modifyLiquidityRouter = new PoolModifyLiquidityTest(manager);

        // Deploy two test tokens
        (currency0, currency1) = deployMintAndApprove2Currencies();
        quoter = new Quoter(manager);

        // initialize pool
        poolkey = PoolKey(currency0, currency1, 3000, 60, IHooks(address(0)));
        poolid = poolkey.toId();
        manager.initialize(poolkey, SQRT_PRICE_1_1, ZERO_BYTES);
    }

    function modifyLiquidity(
        PoolKey memory poolKey,
        int24 tickLower,
        int24 tickUpper,
        int256 liquidity,
        bytes memory hookData
    ) public {
        // if liquidify < 0, remove liquidity
        modifyLiquidityRouter.modifyLiquidity(
            poolKey,
            IPoolManager.ModifyLiquidityParams({
                tickLower: tickLower,
                tickUpper: tickUpper,
                liquidityDelta: liquidity,
                salt: 0
            }),
            hookData
        );
    }

    function swap(PoolKey memory poolKey, int256 amountSpecified, bool zeroForOne, bytes memory hookData) public {
        // if amountSpecified < 0, exactIn
        // else, exactOut
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: zeroForOne,
            amountSpecified: amountSpecified,
            sqrtPriceLimitX96: zeroForOne ? MIN_PRICE_LIMIT + 1 : MAX_PRICE_LIMIT - 1
        });

        PoolSwapTest.TestSettings memory testSettings =
            PoolSwapTest.TestSettings({takeClaims: false, settleUsingBurn: false});

        swapRouter.swap(poolKey, params, testSettings, hookData);
    }

    function test_0() public {
        // ? full-range Check
        modifyLiquidity(poolkey, -13860, 13860, 100 ether, new bytes(0));
        console.log("after addLiquidity manager balance");
        console.log("currency0 balance: ", currency0.balanceOf(address(manager)));
        console.log("currency1 balance: ", currency1.balanceOf(address(manager)));
        console.log();

        // currency0.transfer(address(1), 1 ether);
        // currency1.transfer(address(1), 1 ether);
        // vm.startPrank(address(1));
        // {
        //     console.log("before swap user balance");
        //     console.log("currency0 balance: ", currency0.balanceOf(address(1)));
        //     console.log("currency1 balance: ", currency1.balanceOf(address(1)));
        //     console.log();
        //     MockERC20(Currency.unwrap(currency0)).approve(address(swapRouter), 1 ether);
        //     MockERC20(Currency.unwrap(currency1)).approve(address(swapRouter), 1 ether);
        //     swap(poolkey, -1 ether, true, new bytes(0));
        //     console.log("after swap user balance");
        //     console.log("currency0 balance: ", currency0.balanceOf(address(1)));
        //     console.log("currency1 balance: ", currency1.balanceOf(address(1)));
        //     console.log();
        // }
        // vm.stopPrank();
        // console.log("after swap manager balance");
        // console.log("currency0 balance: ", currency0.balanceOf(address(manager)));
        // console.log("currency1 balance: ", currency1.balanceOf(address(manager)));

        // // remove liquidity
        // modifyLiquidity(poolkey, -600, 600, -100 ether, new bytes(0));
        // console.log("after removeLiquidity manager balance");
        // console.log("currency0 balance: ", currency0.balanceOf(address(manager)));
        // console.log("currency1 balance: ", currency1.balanceOf(address(manager)));
    }
}
