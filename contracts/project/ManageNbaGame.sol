// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract nbaGames {

    enum resultMatch {gagne, perdu, inconnu}

    struct nbaMatch {
        string _teamName;
        nbaGames.resultMatch _resultMatch;
        uint date;
    }

    mapping(address => nbaMatch[]) Matchs;

    function addResultMatch(string memory _adverseTeam, uint _scoreTeam, uint _scoreAdverseTeam) public {
        nbaMatch memory m;
        if(_scoreTeam > _scoreAdverseTeam) {
            m = nbaMatch(_adverseTeam, resultMatch.gagne, block.timestamp);
        } else {
            m = nbaMatch(_adverseTeam, resultMatch.perdu, block.timestamp);
        }

        Matchs[msg.sender].push(m);
    }

    function getResultMatch(string memory _adverseTeam) public view returns(resultMatch) {
        uint i;
        for(i = 0; i < Matchs[msg.sender].length; i++) { // boucle for
            if(keccak256(bytes(Matchs[msg.sender][i]._teamName)) == keccak256(bytes(_adverseTeam))) { // comparaison de strings
                return Matchs[msg.sender][i]._resultMatch;
            }
        }
        return resultMatch.inconnu;
    }
}