// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// import "@openzeppelin/contracts/access/AccessControl.sol";
import "./water_system.sol";

contract UserAccountAndBilling {
    struct User {
        address walletAddress;
        string physAddress;
        uint balance;
        string userName;
        uint256 totalWaterUsage;
    }
    mapping(address => User) public users;
    WaterSystem public waterSystem;
    uint256 public raterPerLiter = 2;

    constructor(address _waterSystemAddress) {
        waterSystem = WaterSystem(_waterSystemAddress);
    }

    function createUser(
        address _walletAddress
    ) public {
        // Ensure the user does not already exist
        require(users[_walletAddress].walletAddress == address(0), "User already exists");

        // Create a new user with default values
        users[_walletAddress] = User({
            walletAddress: _walletAddress,
            physAddress: "",
            balance: 0,
            userName: "",
            totalWaterUsage: 0
        });
    }

    function updateUserWalletAddress(address _newWalletAddress) public {
        require(
            users[msg.sender].walletAddress != address(0),
            "User Does Not Exist."
        );

        users[msg.sender].walletAddress = _newWalletAddress;
    }

    function updateUserAccountBalance(uint256 _newBalance) public {
        require(
            users[msg.sender].walletAddress != address(0),
            "User Does Not Exist."
        );
        users[msg.sender].balance = _newBalance;
    }

    function updateUserPhysicalAddress(string memory _newPhysAddress) public {
        require(
            bytes(users[msg.sender].physAddress).length > 0,
            "User Does Not Exist."
        );
        users[msg.sender].physAddress = _newPhysAddress;
    }

    function viewActiveBillings()
        public
        view
        returns (uint256[] memory, string[] memory)
    {
        uint256[] memory balances = new uint256[](1);
        string[] memory userNames = new string[](1);

        balances[0] = users[msg.sender].balance;
        userNames[0] = users[msg.sender].userName;

        return (balances, userNames);
    }

    function checkWaterUsage() public view returns (uint256) {
        require(
            users[msg.sender].walletAddress != address(0),
            "User Does Not Exist."
        );
        return users[msg.sender].totalWaterUsage;
    }

    function recordWaterUsage(uint256 _usage) public {
        users[msg.sender].totalWaterUsage += _usage;
        uint cost = _usage * raterPerLiter;
        uint new_balance = cost + users[msg.sender].balance;
        updateUserAccountBalance(new_balance);
    }
}
