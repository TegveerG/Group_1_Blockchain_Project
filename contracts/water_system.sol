// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4.0;

contract WaterSystem {
    
    // Struct to store data for each house
    struct House {
        uint256 solarPanelStrength;     // strength of the solar panel in Watts
        uint256 energyConsumption;      // current energy consumption in Watt-hours
        uint256 energySurplus;          // surplus energy in Watt-hours
        bool isRegistered;              // flag to indicate if the house is registered
    }
    
    mapping(address => House) public houses;
    
    // Event to log when a house is registered
    event HouseRegistered(address indexed houseAddress, uint256 solarPanelStrength);
    
    // Event to log when energy is shared
    event EnergyShared(address indexed fromHouse, address indexed toHouse, uint256 amount);
    
    // Function to register a new house
    function registerHouse(uint256 _solarPanelStrength) external {
        require(!houses[msg.sender].isRegistered, "House is already registered");
        houses[msg.sender] = House(_solarPanelStrength, 0, 0, true);
        emit HouseRegistered(msg.sender, _solarPanelStrength);
    }
    
    // Function to update a house's energy consumption and surplus
    function updateHouseData(address _houseAddress, uint256 _energyConsumption, uint256 _energySurplus) external {
        require(houses[_houseAddress].isRegistered, "House is not registered");
        houses[_houseAddress].energyConsumption = _energyConsumption;
        houses[_houseAddress].energySurplus = _energySurplus;
    }
    
    // Function to share energy between two houses
    function shareEnergy(address _fromHouse, address _toHouse, uint256 _amount) external {
        require(houses[_fromHouse].isRegistered && houses[_toHouse].isRegistered, "One or more houses are not registered");
        require(houses[_fromHouse].energySurplus >= _amount, "Not enough energy surplus");
        houses[_fromHouse].energySurplus -= _amount;
        houses[_toHouse].energySurplus += _amount;
        emit EnergyShared(_fromHouse, _toHouse, _amount);
    }
}