// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {
    // uint256 favoriteNumber = 5;
    // bool favoriteBool = false;
    // string favoriteString = 'String';
    // int256 favoriteInt = -5;
    // address favoriteAddress = 0x57aA44F2AC2f4909B50F7fF220516Faa009B88B8;
    // bytes32 favoriteBytes = 'cat';

    uint256 favoriteNumber; //this variable will get initialized to
    bool favoriteBool;

    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // People public person =People({favoriteNumber: 2, name:"Josaphat"});

    // This is how we create a dynamic array in solidity
    People[] public people;
    mapping(string => uint256) public nameToFavortieNumber;

    // mapping(uint256 => string) public favoriteNumberToName;

    function store(uint256 _favoriteNumber) public returns (uint256) {
        favoriteNumber = _favoriteNumber;
        return favoriteNumber;
    }

    // This function retrieve data inside the variables
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    // Function to addPerson inside the Array
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // people.push(People({favoriteNumber:_favoriteNumber, name:_name}));
        people.push(People(_favoriteNumber, _name));
        nameToFavortieNumber[_name] = _favoriteNumber;
        // favoriteNumberToName[_favoriteNumber] = _name;
    }
}
