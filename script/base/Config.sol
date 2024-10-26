// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {Currency} from "v4-core/src/types/Currency.sol";

/// @notice Shared configuration between scripts
contract Config {
    /// @dev populated with default anvil addresses
    IERC20 constant token0 = IERC20(address(0x2f764c5CBb424a687298Cb8205368AB0D60a30e3));
    IERC20 constant token1 = IERC20(address(0x9Fad0609f3CbBF67A887F7BE7953bC000De61CF5));
    IHooks constant hookContract = IHooks(address(0xf9648701849166628A0968C1c2d4C3bfeFbb8Ac0));

    Currency constant currency0 = Currency.wrap(address(token0));
    Currency constant currency1 = Currency.wrap(address(token1));
}
