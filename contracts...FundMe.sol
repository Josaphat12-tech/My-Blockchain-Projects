// SPDX-License-Identifier: MIT

// Smart contract that lets anyone deposit ETH into the contract
// Only the owner of the contract can withdraw the ETH
pragma solidity >=0.6.6 <0.9.0;

import "./AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";



contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public{
        owner = msg.sender;
    }
    
    function fund() public payable {
        uint256 minimunUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimunUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

        // (uint80 roundId,
        // int256 answer,
        // uint256 startedAt,
        // uint256 updatedAt,
        // uint80 answeredInRound ) = priceFeed.latestRoundData();

        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    // Modifier that help us apply some behaviors on our withdraw function for only the admin/owner to withdraw
    modifier OnlyOwner {
        require(msg.sender == owner, "Oups...Only the Admin or the Owner of this contract can withdraw!!!");
        _;
    }
    function withdraw() payable OnlyOwner public {
        // Only the contract admin/owner can withdraw from this account
        //require(msg.sender == owner,"Oups...Only the Admin or the Owner of this contract can withdraw!!!");
        msg.sender.transfer(address(this).balance);
        
        // resetting the balance to Zero by looping through all the senders and set the total amount to Zero
        for (uint256 funderIndex=0;funderIndex < funders.length;funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
    // Get the balance of tehe current account
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}