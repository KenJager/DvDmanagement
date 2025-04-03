// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract DvdManagement {

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    enum StatutDvd {available, borrowed, sold}

    struct Loan{
        uint e_id;
        uint dateRental;
        uint durationLoan;
        uint feesRental;
        dvd[] listDvd;
    }

    struct dvd{
        uint d_id;
        string d_title;
        string autor;
        uint numCopy;
        StatutDvd statut;
        address currentOwner;
        uint price;
    }

    mapping (uint => dvd) DVDs;
    mapping (address => uint) numLoan;
    mapping (address => Loan) clientLoan;

    uint nextDvd = 0;

    event addedDvd(uint id, string title, string autor, uint numEx);
    event addedLoan(address client, uint dvd_id, uint durationLoan);

    modifier isOwner{
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    modifier dvdExist(uint _id){
        require(_id > 0 && _id < nextDvd, "Invalid Id");
        _;
    }

    receive() external payable { }

    function addDvD(string memory _title, string memory _autor, uint _numCopy, uint _price) public  isOwner{
        DVDs[nextDvd] = dvd({d_id           : nextDvd, 
                             d_title        : _title, 
                             autor          : _autor, 
                             numCopy  : _numCopy, 
                             statut         : StatutDvd.available,
                             currentOwner   : owner,
                             price          : _price});
        nextDvd++;
        emit addedDvd(nextDvd - 1, _title, _autor, _numCopy);
    }

    function deleteDvD(uint _id) public isOwner{
        delete DVDs[_id];
        // for(uint i = _id; i <= nextDvd; i++){
        //     DVDs[i] = DVDs[i+1];
        // }
        nextDvd--;
    }

    function updateDvD(uint _id, string memory _title, string memory _autor, uint _numCopy) public isOwner{
        DVDs[_id].d_title =  _title;
        DVDs[_id].autor = _autor;
        DVDs[_id].numCopy = _numCopy;
    }

    function getAllDvD() public isOwner view returns(dvd[] memory){
        require(nextDvd > 0, "No Dvd available");
        dvd[] memory DvdList = new dvd[](nextDvd - 1);
        for(uint i = 0; i < nextDvd; i++){
            DvdList[i] = DVDs[i];
        }
        return DvdList;
    }

    function getDvD(uint _id) public isOwner dvdExist(_id) view returns(dvd memory){
        dvd memory dvdL = DVDs[_id];
        return dvdL;
    }

    function addLoan(uint _id, uint _durationLoan) public {
        require(_durationLoan > 0 && _durationLoan <= 30, "Duree invalide (1-30 jours)");
        clientLoan[msg.sender].listDvd.push(DVDs[_id]);
        numLoan[msg.sender]++;
        uint totalCost = clientLoan[msg.sender].feesRental * _durationLoan;

        // require(
        //     tokenDePaiement.transferFrom(msg.sender, DVDs[_id].currentOwner, totalCost),
        //     "Payment defaulter"
        // );

        DVDs[_id].statut = StatutDvd.borrowed;
        clientLoan[msg.sender].dateRental = block.timestamp;
        clientLoan[msg.sender].durationLoan = _durationLoan * 1 days;

        emit addedLoan(msg.sender, _id, _durationLoan);
    }

    function deleteLoan(address _clientAddress, uint _id) public isOwner{
        delete clientLoan[_clientAddress].listDvd[_id];
        numLoan[_clientAddress]--;
        DVDs[_id].statut = StatutDvd.available;
        DVDs[_id].numCopy++;
    }

    function byeDvd() public {

    }

    // Fonction pour retirer les Ethers du contrat (seulement propriétaire)
    function retirerEthers() public isOwner {
        payable(owner).transfer(address(this).balance);
    }
    
}