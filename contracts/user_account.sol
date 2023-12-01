// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./water_system.sol";

contract UserAccountAndBilling {

    struct User{
        address userAddress;
        uint balance;
        string userName;
    }
    mapping(address => User) public users;
    WaterSystem public waterSystem;

    constructor(address _waterSystemAddress){
        waterSystem = WaterSystem(_waterSystem);
    
    }

    function createrUserAccount() public {
        require(users[msg.sender].userAddress == address(0), "User Exists");
        users[msg.sender] = User(msg.sender, 0);
    }

    function updateUserAccount(uint256 _newBalance) public {
        require(users[msg.sender].userAddress == address(0), "User Does not Exist");
        users[msg.sender] = User(msg.sender, 0);
    }

    functionviewActiveBillings() public view returns (uint[] memory) {
        
    }

}