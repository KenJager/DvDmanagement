// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;

contract Exercice{

    enum etape {commande, expedie, livre}

    struct produit{
        uint _SKU;
        Exercice.etape _etape;
    }

    mapping (address => produit) CommandeProduits;

    function commander(address _client, uint _SKU) public{
        CommandeProduits[_client]._SKU = _SKU;
        CommandeProduits[_client]._etape = etape.commande;
    }

    function expedier(address _client) public{
        CommandeProduits[_client]._etape = etape.expedie;
    }

    function getSKU(address _client) public view returns(uint _SKU){
        _SKU =  CommandeProduits[_client]._SKU;
    }

    function getEtape(address _client) public view returns(etape _etape){
        _etape = CommandeProduits[_client]._etape;
    }
}
