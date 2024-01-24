// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {WormholePitstop} from "../src/WormholePitstop.sol";

import "wormhole-solidity-sdk/testing/WormholeRelayerTest.sol";

contract WormholePitstopTest is WormholeRelayerBasicTest {
    WormholePitstop public wormholePitstop;
    WormholePitstop public wormholePitstopTarget;

    function setUpSource() public override {
        wormholePitstop =
            new WormholePitstop(address(relayerSource), address(tokenBridgeSource), address(wormholeSource));
    }

    function setUpTarget() public override {
        wormholePitstopTarget =
            new WormholePitstop(address(relayerTarget), address(tokenBridgeTarget), address(wormholeTarget));
    }

    function testQuotePitstop() public view {
        WormholePitstop.PitstopInfo[] memory pitstopInfo = new WormholePitstop.PitstopInfo[](1);
        pitstopInfo[0] = WormholePitstop.PitstopInfo({targetChain: 2, amount: 100});
        uint256 totalFees = wormholePitstop.quotePitstop(pitstopInfo);
        console.log("totalFees", totalFees);
    }

    function testUsePitstop() public payable {
        WormholePitstop.PitstopInfo[] memory pitstopInfo = new WormholePitstop.PitstopInfo[](1);
        pitstopInfo[0] = WormholePitstop.PitstopInfo({targetChain: 2, amount: 100});
        uint256 totalFees = wormholePitstop.quotePitstop(pitstopInfo);

        console.log("totalFees", totalFees);

        wormholePitstop.usePitstop{value: totalFees+ 100000}(pitstopInfo, address(this));

        // wormholePitstop.usePitstop{value: 1000}(pitstopInfo, address(this));
    }
    


}
