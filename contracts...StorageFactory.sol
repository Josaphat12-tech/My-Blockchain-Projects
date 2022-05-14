// SPDX-Licence-Identifier: MIT

pragma solidity ^0.6.0;
import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage{
    
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageindex, uint256 _simpleStorageNumber) public {
        // Address
        // ABI
        // SimpleStorage simpleStorage= SimpleStorage(simpleStorageArray[_simpleStorageindex]);
        // simpleStorage.store(_simpleStorageNumber);


        // shortcut
        SimpleStorage(simpleStorageArray[_simpleStorageindex]).store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageindex) public view returns(uint256){
        // SimpleStorage simpleStorage = SimpleStorage(simpleStorageArray[_simpleStorageindex]);
        // return simpleStorage.retrieve();

        // shortcut
        return SimpleStorage(simpleStorageArray[_simpleStorageindex]).retrieve();
       
    }
}