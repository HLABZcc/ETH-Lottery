// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./mlEthereum.sol";

contract MaxiLotteryETH {
    bool lotteryClosed;

    mlEthereum mlETH;

    mapping(uint256 => address) public winners;
    uint256 idLottery;

    address payable[] public players;

    address payable owner;

    constructor(mlEthereum _mlETH) {
        mlETH = _mlETH;
        owner = payable(msg.sender);
    }

    function toggleLottery() external onlyOwner {
        lotteryClosed = !lotteryClosed;
    }

    function pickWinner() external onlyOwner {
        require(lotteryClosed, "Maxi Lottery ETH is open!");
        uint256 winner = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % players.length;

        players[winner].transfer((address(this).balance / 100) * 90);
        owner.transfer((address(this).balance / 100) * 10);

        mlETH.mint(players[winner], 10 * 10**18);

        winners[idLottery] = players[winner];
        idLottery++;

        players = new address payable[](0);
    }

    function play() external payable {
        require(!lotteryClosed, "Maxi Lottery ETH is closed!");
        require(
            msg.value == 0.01 ether,
            "Not enough funds provided! (Require: 0.01 ETH)"
        );
        players.push(payable(msg.sender));
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getWinner(uint256 _idLottery) external view returns (address) {
        return winners[_idLottery];
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }
}
