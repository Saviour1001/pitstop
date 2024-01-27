// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {WormholePitstop} from "../src/WormholePitstop.sol";

import "wormhole-solidity-sdk/testing/WormholeRelayerTest.sol";

contract WormholePitstopTest is WormholeRelayerBasicTest {
    WormholePitstop public wormholePitstop;
    WormholePitstop public wormholePitstopTarget;

    constructor() {
        setTestnetForkChains(4, 5);
    }

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
        pitstopInfo[0] = WormholePitstop.PitstopInfo({targetChain: targetChain, amount: 100});
        uint256 totalFees = wormholePitstop.quotePitstop(pitstopInfo);
        console.log("Single chain: %s", totalFees);
    }

    function testQuotePitstopWithMultipleChains() public view {
        WormholePitstop.PitstopInfo[] memory pitstopInfo = new WormholePitstop.PitstopInfo[](2);
        pitstopInfo[0] = WormholePitstop.PitstopInfo({targetChain: targetChain, amount: 100});
        pitstopInfo[1] = WormholePitstop.PitstopInfo({targetChain: targetChain, amount: 200});
        uint256 totalFees = wormholePitstop.quotePitstop(pitstopInfo);

        console.log("Multiple chains: %s", totalFees);
    }

    function testUsePitstop() public {
        uint256 amount = 19e17;

        vm.selectFork(targetFork);
        address recipient = 0x1234567890123456789012345678901234567890;

        vm.selectFork(sourceFork);
        WormholePitstop.PitstopInfo[] memory pitstopInfo = new WormholePitstop.PitstopInfo[](1);
        pitstopInfo[0] = WormholePitstop.PitstopInfo({targetChain: targetChain, amount: amount});

        // cost calculation

        uint256 totalBridgingFees = wormholePitstop.quotePitstop(pitstopInfo);

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < pitstopInfo.length; i++) {
            totalAmount += pitstopInfo[i].amount;
        }

        uint256 totalAmountWithFees = totalAmount + totalBridgingFees;

        ////////////////
        address wethAddress = address(tokenBridgeSource.WETH());
        vm.recordLogs();

        wormholePitstop.usePitstop{value: totalAmountWithFees}(pitstopInfo, recipient);
        performDelivery();

        vm.selectFork(targetFork);
        address wormholeWrappedToken = tokenBridgeTarget.wrappedAsset(sourceChain, toWormholeFormat(wethAddress));
        // assertEq(IERC20(wormholeWrappedToken).balanceOf(recipient), amount);

        console.log("Balance after bridging", IERC20(wormholeWrappedToken).balanceOf(recipient));
        
        

    }
}
