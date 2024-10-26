// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PositionManager} from "v4-periphery/src/PositionManager.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";

/// @notice Shared constants used in scripts
contract Constants {
    address constant CREATE2_DEPLOYER = address(0x4e59b44847b379578588920cA78FbF26c0B4956C);

    /// @dev populated with default anvil addresses
    IPoolManager constant POOLMANAGER = IPoolManager(address(0x38EB8B22Df3Ae7fb21e92881151B365Df14ba967));
    PositionManager constant posm = PositionManager(address(0x05deD3F8a8e84700d68A4D81cd6780c982dB13F9));
    IAllowanceTransfer constant PERMIT2 = IAllowanceTransfer(address(0x000000000022D473030F116dDEE9F6B43aC78BA3));
}
