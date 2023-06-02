// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DanilychToken is ERC20, ERC20Burnable, Ownable {
    uint256 public txFee;

    constructor(uint256 txFee_) ERC20("DanilychToken", "DAN") {
        txFee = txFee_;
        _mint(msg.sender, 100000 * 10 ** decimals());
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        uint256 burnValue = (amount / 100) * txFee;
        _burn(msg.sender, burnValue);
        _transfer(owner, to, amount - burnValue);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        uint256 burnValue = (amount / 100) * txFee;
        _burn(msg.sender, burnValue);
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount - burnValue);
        return true;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function changeFee(uint256 txFee_) external onlyOwner {
        txFee = txFee_;
    }
}
