// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "wormhole-solidity-sdk/WormholeRelayerSDK.sol";
import "wormhole-solidity-sdk/interfaces/IERC20.sol";
import "wormhole-solidity-sdk/interfaces/IWETH.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WormholePitstop  {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
