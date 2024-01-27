// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {WormholeInteractions} from "./WormholeInteractions.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {console} from "forge-std/Test.sol";

contract WormholePitstop is WormholeInteractions {
    constructor(address _wormholeRelayer, address _tokenBridge, address _wormhole)
        WormholeInteractions(_wormholeRelayer, _tokenBridge, _wormhole)
        Ownable(msg.sender)
    {}

    struct PitstopInfo {
        uint16 targetChain;
        uint256 amount;
    }

    function quotePitstop(PitstopInfo[] calldata _pitstopInfo) public view returns (uint256 totalBridgingFees) {
        for (uint256 i = 0; i < _pitstopInfo.length; i++) {
            totalBridgingFees += quoteCrossChainDeposit(_pitstopInfo[i].targetChain);
        }
    }

    function usePitstop(PitstopInfo[] calldata _pitstopInfo, address _receiver) external payable {
        uint256 totalBridgingFees = quotePitstop(_pitstopInfo);

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < _pitstopInfo.length; i++) {
            totalAmount += _pitstopInfo[i].amount;
        }

        uint256 totalAmountWithFees = totalAmount + totalBridgingFees;

        require(msg.value >= totalAmountWithFees, "WormholePitstop: insufficient funds");

        for (uint256 i = 0; i < _pitstopInfo.length; i++) {
            uint256 amount = _pitstopInfo[i].amount;
            uint16 targetChain = _pitstopInfo[i].targetChain;
            address targetToken = 0x1d1499e622D69689cdf9004d05Ec547d650Ff211;
            address recipient = _receiver;

            sendNativeCrossChainDeposit(targetChain, targetToken, recipient, amount);
            
        }
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
