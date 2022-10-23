// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract mlEthereum is ERC20 {
    address owner;
    address approvedContract;

    constructor() ERC20("Maxi Lottery Ethereum", "mlETH") {
        owner = msg.sender;
    }

    function setApprovedContract(address _approvedContract) external onlyOwner {
        approvedContract = _approvedContract;
    }

    function mint(address _to, uint256 _numberOfTokens) external {
        require(msg.sender == approvedContract, "Not Approved");
        _mint(_to, _numberOfTokens);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }
}
