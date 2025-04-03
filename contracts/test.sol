pragma solidity 0.8.26;

contract test{
    uint[] nombres;

    function addValue(uint _value) public {
        nombres.push(_value);
    }

    function updateValue(uint _index, uint _value) public {
        nombres[_index] = _value;
    }

    function deleteValue(uint _index) public {
        delete nombres[_index];
    }

    function getValue(uint _index) external view returns (uint){
        return nombres[_index];
    }

    function getNombreX2() public view returns (uint[] memory) {
        uint _length = nombres.length;
        uint[] memory nombreX2 = new uint [](_length);

        for(uint i=0; i<_length; i++){
            nombreX2[i] = nombres[i]*2;
        }

        return nombreX2;
    }
}