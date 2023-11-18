// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Greeter} from "../src/Greeter.sol";
import {Counter} from "../src/Counter.sol";

import {Deployer} from "foundry-immutable-deployer/Deployer.sol";

// Define a struct to hold your deployment parameters.
struct DeployParams {
    address owner;
    string greeting;
    Salts salts;
}

// Your deployment parameter struct can include nested data, like the salts
// struct below.
struct Salts {
    bytes32 greeter;
    bytes32 counter;
}

contract Deploy is Deployer {
    DeployParams internal params;

    // Override this function to load your deployment parameters.
    // You can load them from environment variables using Foundry's vm.env*
    // helpers, or define them directly in the function body.
    function loadDeployParameters() internal override {
        params = DeployParams({
            owner: vm.envOr("OWNER", msg.sender),
            greeting: "Merhaba",
            salts: Salts({
                greeter: keccak256("greeter"),
                counter: keccak256("counter")
            })
        });
    }

    // Register your contracts for deployment. For each contract, you must
    // provide a name and contract creation code. Additionally, you may provide
    // a salt and abi-encoded constructor arguments.
    function register() internal override {
        register("Greeter", params.salts.counter, type(Greeter).creationCode, abi.encode(params.greeting, params.owner));
        register("Counter", params.salts.counter, type(Counter).creationCode);
    }

    // This function will be called after deployment. Perform any post-deploy
    // checks and tasks here. You can use Foundry assertion helpers, just like
    // in a test.
    function afterDeploy() internal override {
        Greeter greeter = Greeter(getAddress("Greeter"));
        Counter counter = Counter(getAddress("Counter"));

        assertEq(greeter.greet("Istanbul"), "Merhaba, Istanbul!");
        assertEq(greeter.owner(), params.owner);
        assertEq(counter.value(), 0);
    }
}
