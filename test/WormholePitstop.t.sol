// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {WormholePitstop} from "../src/WormholePitstop.sol";

contract WormholePitstopTest is Test {
    WormholePitstop public wormholePitstop;

    function setUp() public {
        wormholePitstop = new WormholePitstop();
    }
}

