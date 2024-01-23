// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {WormholePitstop} from "../src/WormholePitstop.sol";

contract WormholePitstopTest is Test {
    WormholePitstop public wormholePitstop;

    function setUp() public {
        wormholePitstop = new WormholePitstop();
        wormholePitstop.setNumber(0);
    }

    function test_Increment() public {
        wormholePitstop.increment();
        assertEq(wormholePitstop.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        wormholePitstop.setNumber(x);
        assertEq(wormholePitstop.number(), x);
    }
}

