// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import './Owner.sol';

contract wallet is owner{
    // objet decrivant un payement : montant et la date
    struct payment {
        uint amount;
        uint timestamp;
    }

    // objet decrivant l'argent d'un individu et la liste des operations effectue
    struct Balance{
        uint totalBalance;
        uint numPayment;
        mapping(uint => payment) payments;
    }

    // on associe la Balance pour chaque utilisateur (adresse)
    mapping (address => Balance) wallets;

    receive() external payable {
        // payment memory p = payment(msg.value, block.timestamp);
        wallets[msg.sender].totalBalance += msg.value;
        wallets[msg.sender].payments[wallets[msg.sender].numPayment] = payment(msg.value, block.timestamp);
        wallets[msg.sender].numPayment++;
    }

    function getBalance() public isOwner view returns (uint) { 
        return wallets[msg.sender].totalBalance;
    }

    function withDrawAll(address payable _to) public {
        uint amount = wallets[msg.sender].totalBalance;
        wallets[msg.sender].totalBalance = 0;
        _to.transfer(amount);
    }

    function withDraw(address payable _to, uint _amount) public {
        require(_amount <= wallets[msg.sender].totalBalance, "Amount not enough");
        wallets[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }


}