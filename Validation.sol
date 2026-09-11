// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Interface matching the optimized Citizen contract
interface ICitizen {
    function getCitizen(uint64 _cnic)
        external
        view
        returns (
            string memory name,
            uint64 cnic,
            uint8 age,
            bool intermediatePassed,
            bool exists
        );
}

// Interface matching the optimized Skills contract
interface ISkills {
    function getGraphicDesigningSkills(uint64 _cnic)
        external
        view
        returns (
            uint8 adobeCreativeTool,
            uint8 figma,
            uint8 premiere,
            uint8 photoshop
        );

    function getWebDevelopmentSkills(uint64 _cnic)
        external
        view
        returns (
            uint8 react,
            uint8 typescript,
            uint8 django,
            uint8 api
        );
}

contract Validation {

    // Immutable state variables saved directly in bytecode (saves gas on reads)
    ICitizen public immutable citizenContract;
    ISkills public immutable skillsContract;

    uint8 public constant PASSING_SCORE = 60;
    uint8 public constant MINIMUM_AGE = 18;

    constructor(address _citizenContract, address _skillsContract) {
        require(_citizenContract != address(0), "Invalid Citizen contract address");
        require(_skillsContract != address(0), "Invalid Skills contract address");

        citizenContract = ICitizen(_citizenContract);
        skillsContract = ISkills(_skillsContract);
    }

    // Check basic citizen eligibility
    function citizenIsValid(uint64 _cnic) public view returns (bool) {
        (, , uint8 age, bool intermediatePassed, bool exists) = citizenContract.getCitizen(_cnic);
        return exists && age >= MINIMUM_AGE && intermediatePassed;
    }

    // Check Graphic Designing eligibility
    function graphicDesigningCertificateCondition(uint64 _cnic) external view returns (bool) {
        if (!citizenIsValid(_cnic)) {
            return false;
        }

        (uint8 adobeCreativeTool, , , uint8 photoshop) = skillsContract.getGraphicDesigningSkills(_cnic);
        return (adobeCreativeTool >= PASSING_SCORE && photoshop >= PASSING_SCORE);
    }

    // Check Web Development eligibility
    function webDevelopmentCertificateCondition(uint64 _cnic) external view returns (bool) {
        if (!citizenIsValid(_cnic)) {
            return false;
        }

        // Destructure only required variables (react & django) directly as uint8
        (uint8 react, , uint8 django, ) = skillsContract.getWebDevelopmentSkills(_cnic);
        return (django >= PASSING_SCORE && react >= PASSING_SCORE);
    }
}