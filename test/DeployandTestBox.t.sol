// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployandTestBox is Test {

    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public proxy;
    BoxV2 public implementation;

    address public OWNER = makeAddr("owner");

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run();
    }

    function testCanUpgrade() public {
        implementation = new BoxV2();

        upgrader.upgradeBox(proxy, address(implementation));
        uint256 expectedNumber = 2;

        assertEq(expectedNumber, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(3);
        assertEq(3, BoxV2(proxy).getNumber());
    }

    function testProxyStartsWithBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }
}