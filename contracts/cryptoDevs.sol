//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract cryptoDevs is ERC721Enumerable, Ownable {
    //adds a base URI to base collection on
    string _baseTokenURI;
    //price of each NFT
    uint256 public _price = 0.01 ether;
    //pauses contract
    bool public _paused;
    //max number of NFTs
    uint256 public maxTokenIds = 20;
    //total number minted
    uint256 public tokenIds;
    //calls IWhitelist contract instance
    IWhitelist whitelist;
    //keeps track of if presale started
    bool public presaleStarted;
    //timestamp of when presale would end
    uint256 public presaleEnded;

    //checks if contract is paused
    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    //takes a constructor and imported ERC721 function
    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    //starts a presale for whitelisted addresses
    function startPresale() public onlyOwner {
        presaleStarted = true;
        //presale ends 5 minutes after timestamp
        presaleEnded = block.timestamp + 5 minutes;
    }

    //allows user to mint 1 NFT per transaction on presale
    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale has not ended yet");
        require(whitelist.whitelistedAddresses(msg.sender),'You are not whitelisted');
        require(tokenIds < maxTokenIds, 'Exceeded max Crypto Devs supply');
        require(msg.value >= _price, 'Ether sent is not correct');
        tokenIds += 1;
        //safer version of _mint()
        _safeMint(msg.sender, tokenIds);
    }

    //normal mint after presale ends
    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not ended yet");
        require(tokenIds < maxTokenIds, 'Exceeded max Crypto Devs supply');
        require(msg.value >= _price, 'Ether sent is not correct');
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    //overrides ERC721 implementation which by default returns an empty string
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
    
    //pauses and unpauses contract
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    //withdraw sends all ether in the contract to owner
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether");
    }

    //receives ether, msg.data must be empty
    receive() external payable {}
    //fallback function for when msg.data is not empty
    fallback() external payable{}
}