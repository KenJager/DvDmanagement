// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract DvdManagement {

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    enum StatutDvd {available, sold}

    struct dvd{
        uint d_id;
        string d_title;
        uint numCopy;
        StatutDvd statut;
        address currentOwner;
        uint256 price;
    }

    mapping (uint => dvd) DVDs;

    uint nextDvd;

    event addedDvd(uint id, string title, string autor, uint numEx);
    event DvdPurchased(address client, uint id, string sms);

    modifier isOwner{
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    modifier dvdExist(uint _id){
        require(_id >= 0 && _id < nextDvd, "Invalid Id");
        _;
    }

    receive() external payable { }

    function addDvD(string memory _title, uint _numCopy, uint _price) public  isOwner{
        DVDs[nextDvd] = dvd({d_id           : nextDvd, 
                             d_title        : _title, 
                             numCopy        : _numCopy, 
                             statut         : StatutDvd.available,
                             currentOwner   : owner,
                             price          : _price});
        nextDvd++;
    }

    function deleteDvD(uint _id) public isOwner dvdExist(_id){
        require(DVDs[_id].statut == StatutDvd.available, "Dvd is not available");
        delete DVDs[_id];
        nextDvd--;
    }

    function updateDvD(uint _id, string memory _title, uint _numCopy) public isOwner{
        DVDs[_id].d_title =  _title;
        DVDs[_id].numCopy = _numCopy;
    }

    function getAllDvD() public isOwner view returns(dvd[] memory){
        require(nextDvd > 0, "No Dvd available");
        dvd[] memory DvdList = new dvd[](nextDvd);
        for(uint i = 0; i < nextDvd; i++){
            DvdList[i] = DVDs[i];
        }
        return DvdList;
    }

    function getDvD(uint _id) public isOwner dvdExist(_id) view returns(dvd memory){
        dvd memory dvdL = DVDs[_id];
        return dvdL;
    }

    function buyDvd(uint _id) public payable dvdExist(_id){
        require(DVDs[_id].statut == StatutDvd.available, "DvD is not available");

        uint256 priceInWei = DVDs[_id].price * 1 ether;
        require(msg.value >= priceInWei, "Insufficient ETH sent");
        if (msg.value > priceInWei) {
            payable(msg.sender).transfer(msg.value - DVDs[_id].price);
        }

        payable(owner).transfer(priceInWei);
        DVDs[_id].statut = StatutDvd.sold;
        DVDs[_id].currentOwner = msg.sender;

        emit DvdPurchased(msg.sender, _id, "DVD purchased successfully!");
    }  

    function seePurchase() public view returns(dvd[] memory) {
        uint count = 0;
        for(uint i = 0; i < nextDvd; i++) {
            if (DVDs[i].statut == StatutDvd.sold && DVDs[i].currentOwner == msg.sender) {
                count++;
            }
        }

        require(count > 0, "No purchase found for this address");

        dvd[] memory purchases = new dvd[](count);
        uint index = 0;
        
        // Remplir le tableau
        for(uint i = 0; i < nextDvd; i++) {
            if (DVDs[i].statut == StatutDvd.sold && DVDs[i].currentOwner == msg.sender) {
                purchases[index] = DVDs[i];
                index++;
            }
        }

        return purchases;
    }

    function getBalance() view public returns(uint){
        return (msg.sender).balance;
    }
}