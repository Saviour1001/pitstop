// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {WormholeInteractions} from "./WormholeInteractions.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WormholePitstop is WormholeInteractions {

    constructor(
        address _wormholeRelayer,
        address _tokenBridge,
        address _wormhole
    ) WormholeInteractions(_wormholeRelayer, _tokenBridge, _wormhole) Ownable(msg.sender) {}

    struct PitstopInfo {
        uint16 targetChain;
        uint256 amount;
    }

    function usePitstop() public {

    }
    
}
