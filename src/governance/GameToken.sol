// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract GameToken is ERC20Votes, ERC20Permit {
    constructor(address initialOwner)
        ERC20("GameToken", "GAME")
        ERC20Permit("GameToken")
    {
        _mint(initialOwner, 1_000_000 * 10 ** decimals());
    }

    function _update(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, amount);
    }

    function nonces(address owner)
        public view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}
