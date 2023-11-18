// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../script/Deploy.s.sol";

contract DeployTest is Deploy {
    address internal owner = makeAddr("owner");

    Greeter internal greeter;
    Counter internal counter;

    function setUp() public {
        params = DeployParams({
            owner: owner,
            greeting: "Hello",
            salts: Salts({
                greeter: bytes32(0),
                counter: bytes32(0)
            })
        });
        register();
        deploy({broadcast: false});

        greeter = Greeter(getAddress("Greeter"));
        counter = Counter(getAddress("Counter"));
    }

    function testGreet() public {
        assertEq(greeter.greet("Alice"), "Hello, Alice!");
    }

    function testGreeterOwner() public {
        assertEq(greeter.owner(), owner);
    }

    function testCounter() public {
        assertEq(counter.value(), 0);

        counter.increment();

        assertEq(counter.value(), 1);
    }
}
