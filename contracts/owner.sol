// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Owner{
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier isOwner{
        require(msg.sender == owner, "Vous n'etes pas le Proprietaire");
        _;
    }
}