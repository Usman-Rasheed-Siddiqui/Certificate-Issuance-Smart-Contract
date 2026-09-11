// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Skills {

    address public government;
    address public authorizedThirdParty;

    // Packed into a SINGLE 32-byte storage slot (4 x 1 byte = 4 bytes total)
    struct GraphicDesigningSkills {
        uint8 adobeCreativeTool;
        uint8 figma;
        uint8 premiere;
        uint8 photoshop;
    }

    // Packed into a SINGLE 32-byte storage slot (4 x 1 byte = 4 bytes total)
    struct WebDevelopmentSkills {
        uint8 react;
        uint8 typescript;
        uint8 django;
        uint8 api;
    }

    mapping(uint64 => GraphicDesigningSkills) private graphicDesigningSkills;
    mapping(uint64 => WebDevelopmentSkills) private webDevelopmentSkills;

    event GraphicDesigningSkillsUpdated(uint64 indexed cnic);
    event WebDevelopmentSkillsUpdated(uint64 indexed cnic);
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

    constructor(address _government, address _thirdParty) {
        require(_government != address(0), "Invalid government address");
        require(_thirdParty != address(0), "Invalid third party address");

        government = _government;
        authorizedThirdParty = _thirdParty;
    }

    function setAuthorizedThirdParty(address _newThirdParty) external onlyGovernment {
        require(_newThirdParty != address(0), "Invalid third party address");

        address oldThirdParty = authorizedThirdParty;
        authorizedThirdParty = _newThirdParty;

        emit ThirdPartyChanged(oldThirdParty, _newThirdParty);
    }

    function setGraphicDesigningSkills(
        uint64 _cnic,
        uint8 _adobeCreativeTool,
        uint8 _figma,
        uint8 _premiere,
        uint8 _photoshop
    ) external onlyAuthorizedThirdParty {
        require(
            _adobeCreativeTool <= 100 &&
            _figma <= 100 &&
            _premiere <= 100 &&
            _photoshop <= 100,
            "Scores must be between 0 and 100"
        );

        graphicDesigningSkills[_cnic] = GraphicDesigningSkills({
            adobeCreativeTool: _adobeCreativeTool,
            figma: _figma,
            premiere: _premiere,
            photoshop: _photoshop
        });

        emit GraphicDesigningSkillsUpdated(_cnic);
    }

    function setWebDevelopmentSkills(
        uint64 _cnic,
        uint8 _react,
        uint8 _typescript,
        uint8 _django,
        uint8 _api
    ) external onlyAuthorizedThirdParty {
        require(
            _react <= 100 &&
            _typescript <= 100 &&
            _django <= 100 &&
            _api <= 100,
            "Scores must be between 0 and 100"
        );

        webDevelopmentSkills[_cnic] = WebDevelopmentSkills({
            react: _react,
            typescript: _typescript,
            django: _django,
            api: _api
        });

        emit WebDevelopmentSkillsUpdated(_cnic);
    }

    function getGraphicDesigningSkills(uint64 _cnic)
        external
        view
        returns (
            uint8 adobeCreativeTool,
            uint8 figma,
            uint8 premiere,
            uint8 photoshop
        )
    {
        GraphicDesigningSkills storage skills = graphicDesigningSkills[_cnic];
        return (
            skills.adobeCreativeTool,
            skills.figma,
            skills.premiere,
            skills.photoshop
        );
    }

    function getWebDevelopmentSkills(uint64 _cnic)
        external
        view
        returns (
            uint8 react,
            uint8 typescript,
            uint8 django,
            uint8 api
        )
    {
        WebDevelopmentSkills storage skills = webDevelopmentSkills[_cnic];
        return (
            skills.react,
            skills.typescript,
            skills.django,
            skills.api
        );
    }
}