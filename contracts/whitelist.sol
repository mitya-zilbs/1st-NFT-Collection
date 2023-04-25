//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract whitelist {
  //max number of addresses allowed
  uint8 public maxWhitelistedAddresses;

  //lists non-whitelisted addresses as false and listed ones true
  mapping(address => bool) public whitelistedAddresses;

  //tracks number of whitelisted addresses
  uint8 public numAddressesWhitelisted;

  //constructor that runs and sets max number
  constructor(uint8 _maxWhitelistedAddresses) {
    maxWhitelistedAddresses = _maxWhitelistedAddresses;
  }

  //function to add addresses to whitelist
  function addAddressToWhitelist() public {
    //checks if address already whitelisted
    require(
      !whitelistedAddresses[msg.sender],
      "Sender has already been whitelisted"
    );

    //checks to see if max number of addresses has been reached
    require(
      numAddressesWhitelisted < maxWhitelistedAddresses,
      "No more addresses can be added"
    );

    //adds address to whitelisted address array and increases counter by 1
    whitelistedAddresses[msg.sender] = true;
    numAddressesWhitelisted += 1;
  }
}
