// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Citizen {

    address public government;
    address public authorizedThirdParty;

    struct CitizenInfo {
        string name;
        uint64 cnic;
        uint8 age;
        bool intermediatePassed;
        bool exists;
    }

    mapping(uint64 => CitizenInfo) private citizens;

    event CitizenAdded(
        uint256 indexed cnic,
        string name,
        uint256 age,
        bool intermediatePassed
    );

    event CitizenUpdated(uint256 indexed cnic);

    event ThirdPartyChanged(
        address indexed oldThirdParty,
        address indexed newThirdParty
    );

    modifier onlyGovernment() {
        require(msg.sender == government, "Only government can perform this action");
        _;
    }

    modifier onlyAuthorizedThirdParty() {
        require(
            msg.sender == authorizedThirdParty,
            "Only authorized third party can perform this action"
        );
        _;
    }

    constructor(
        address _government,
        address _thirdParty
    ) {
        require(_government != address(0), "Invalid government address");
        require(_thirdParty != address(0), "Invalid third party address");

        government = _government;
        authorizedThirdParty = _thirdParty;
    }

    // Government can change the authorized third party
    function setAuthorizedThirdParty(
        address _newThirdParty
    ) external onlyGovernment {
        require(
            _newThirdParty != address(0),
            "Invalid third party address"
        );

        address oldThirdParty = authorizedThirdParty;
        authorizedThirdParty = _newThirdParty;

        emit ThirdPartyChanged(
            oldThirdParty,
            _newThirdParty
        );
    }

    // Authorized third party adds a citizen
    function addCitizen(
        string memory _name,
        uint64 _cnic,
        uint8 _age,
        bool _intermediatePassed
    ) external onlyAuthorizedThirdParty {

        require(
            !citizens[_cnic].exists,
            "Citizen already exists"
        );

        citizens[_cnic] = CitizenInfo({
            name: _name,
            cnic: _cnic,
            age: _age,
            intermediatePassed: _intermediatePassed,
            exists: true
        });

        emit CitizenAdded(
            _cnic,
            _name,
            _age,
            _intermediatePassed
        );
    }

    // Authorized third party updates citizen information
    function updateCitizen(
        string memory _name,
        uint64 _cnic,
        uint8 _age,
        bool _intermediatePassed
    ) external onlyAuthorizedThirdParty {

        require(
            citizens[_cnic].exists,
            "Citizen does not exist"
        );

        CitizenInfo storage citizen = citizens[_cnic];

        citizen.name = _name;
        citizen.age = _age;
        citizen.intermediatePassed = _intermediatePassed;

        emit CitizenUpdated(_cnic);
    }

    // Get citizen information
    function getCitizen(
        uint64 _cnic
    )
        external
        view
        returns (
            string memory name,
            uint64 cnic,
            uint8 age,
            bool intermediatePassed,
            bool exists
        )
    {
        CitizenInfo memory citizen = citizens[_cnic];

        return (
            citizen.name,
            citizen.cnic,
            citizen.age,
            citizen.intermediatePassed,
            citizen.exists
        );
    }

    // Check whether citizen exists
    function citizenExists(
        uint64 _cnic
    ) external view returns (bool) {
        return citizens[_cnic].exists;
    }
}