// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {WormholeInteractions} from "./WormholeInteractions.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WormholePitstop is WormholeInteractions {
    constructor(address _wormholeRelayer, address _tokenBridge, address _wormhole)
        WormholeInteractions(_wormholeRelayer, _tokenBridge, _wormhole)
        Ownable(msg.sender)
    {}

    struct PitstopInfo {
        uint16 targetChain;
        uint256 amount;
    }

    function quotePitstop(PitstopInfo[] calldata _pitstopInfo) public view returns (uint256 totalFees) {
        for (uint256 i = 0; i < _pitstopInfo.length; i++) {
            totalFees += quoteCrossChainDeposit(_pitstopInfo[i].targetChain);
        }
    }

    function usePitstop(PitstopInfo[] calldata _pitstopInfo, address _receiver) external payable {
        uint256 totalFees = quotePitstop(_pitstopInfo);
        require(msg.value == totalFees, "msg.value must be quoteCrossChainDeposit(targetChain) + amount");

        for (uint256 i = 0; i < _pitstopInfo.length; i++) {
            PitstopInfo calldata info = _pitstopInfo[i];
            sendNativeCrossChainDeposit(info.targetChain, address(0), _receiver, info.amount);
        }
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
