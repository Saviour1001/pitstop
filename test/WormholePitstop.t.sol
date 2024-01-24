// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {WormholePitstop} from "../src/WormholePitstop.sol";

import "wormhole-solidity-sdk/testing/WormholeRelayerTest.sol";

contract WormholePitstopTest is WormholeRelayerBasicTest {
    WormholePitstop public wormholePitstop;

    function setUpSource() public override {
        wormholePitstop =
            new WormholePitstop(address(relayerSource), address(tokenBridgeSource), address(wormholeSource));
    }

    function setUpTarget() public override {}
}
