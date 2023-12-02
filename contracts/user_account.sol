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

    function createrUserAccount(address _walletAddress) public {
        require(users[msg.sender].walletAddress == _walletAddress, "User Exists");
        require(verifyUserAddress(msg.sender), "Invalid User Address");
        users[msg.sender] = User({
            walletAddress: msg.sender,
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

    function AddressListings() internal pure returns (address[] memory) {
        address[] memory addresses = new address[](10);
        addresses[0] = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        addresses[1] = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        addresses[2] = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
        addresses[3] = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
        addresses[4] = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
        addresses[5] = 0x17F6AD8Ef982297579C203069C1DbfFE4348c372;
        addresses[6] = 0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678;
        addresses[7] = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;
        addresses[8] = 0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C;
        addresses[9] = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;

        return addresses;
    }

    function verifyUserAddress(
        address _userAddress
    ) internal pure returns (bool) {
        address[] memory validAddresses = AddressListings();

        for (uint256 i = 0; i < validAddresses.length; i++) {
            if (validAddresses[i] == _userAddress) {
                return true;
            }
        }
        return false;
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
