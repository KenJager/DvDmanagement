// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract owner{
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier isOwner{
        require(msg.sender == owner, "You are not the owner");
        _;
    }
}