// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AMM} from "../game/AMM.sol";
import {CraftingSystem} from "../game/CraftingSystem.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract GameFactory {
    address public immutable resourceToken;

    event AMMDeployed(address indexed ammAddress, bytes32 salt);
    event CraftingSystemDeployed(address indexed craftingSystemAddress);

    constructor(address _resourceToken) {
        resourceToken = _resourceToken;
    }

    function deployAMM(bytes32 salt) external returns (address) {
        AMM amm = new AMM{salt: salt}(IERC1155(resourceToken));
        emit AMMDeployed(address(amm), salt);
        return address(amm);
    }

    function deployCraftingSystem() external returns (address) {
        CraftingSystem crafting = new CraftingSystem(resourceToken);
        emit CraftingSystemDeployed(address(crafting));
        return address(crafting);
    }

    function computeAMMAddress(bytes32 salt) external view returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(AMM).creationCode,
            abi.encode(resourceToken)
        );

        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(bytecode))
        );

        return address(uint160(uint256(hash)));
    }
}
