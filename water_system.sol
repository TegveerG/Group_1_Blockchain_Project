// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./user_account.sol";

contract WaterSystem {
    // Struct to store data for each residence
    struct Residence {
        // uint256 solarPanelStrength; // strength of the solar panel in Watts
        uint256 waterConsumption; // current energy consumption in Watt-hours
        uint256 waterSurplus; // surplus energy in Watt-hours
        bool isRegistered; // flag to indicate if the house is registered
    }

    mapping(address => Residence) public residences;

    // Event to log when water is supplied
    event WaterSupplied(
        address indexed fromSupplier,
        address indexed toResidence,
        uint256 amount
    );

    // Function to update a residence's water consumption
    function updateResidenceData(
        address _residenceAddress,
        uint256 _waterConsumption,
        uint256 _waterSurplus
    ) external {
        require(
            residences[_residenceAddress].isRegistered,
            "Residence is not registered."
        );
        residences[_residenceAddress].waterConsumption = _waterConsumption;
        residences[_residenceAddress].waterSurplus = _waterSurplus;
    }

    // Function to supply water to a residence
    function supplyWater(
        address _fromSupplier,
        address _toResidence,
        uint256 _amount
    ) external {
        require(
            residences[_fromSupplier].isRegistered &&
                residences[_toResidence].isRegistered,
            "Supplier or residence are not registered."
        );
        require(
            residences[_toResidence].waterSurplus >= _amount,
            "Not enough water surplus."
        );
        residences[_fromSupplier].waterSurplus -= _amount;
        residences[_toResidence].waterSurplus += _amount;
        emit WaterSupplied(_fromSupplier, _toResidence, _amount);
    }
}
