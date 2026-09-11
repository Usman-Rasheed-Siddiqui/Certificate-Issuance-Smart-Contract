// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Interface for Validation Contract
interface IValidation {
    function graphicDesigningCertificateCondition(uint64 _cnic) external view returns (bool);
    function webDevelopmentCertificateCondition(uint64 _cnic) external view returns (bool);
}

// Interface for Citizen Contract
interface ICitizenCertificate {
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

contract Certificate {

    address public government;
    address public authorizedThirdParty;

    IValidation public immutable validationContract;
    ICitizenCertificate public immutable citizenContract;

    enum CertificateType {
        GraphicDesigning,
        WebDevelopment
    }

    // PACKED INTO 2 STORAGE SLOTS TOTAL:
    // Slot 1 (26 bytes): certificateId (8) + citizenCNIC (8) + issueDate (8) + certificateType (1) + isActive (1)
    // Slot 2: citizenName (dynamic string)
    struct CertificateData {
        uint64 certificateId;
        uint64 citizenCNIC;
        uint64 issueDate;
        CertificateType certificateType;
        bool isActive;
        string citizenName;
    }

    uint64 public nextCertificateId = 1;

    // Certificate ID => Certificate Data
    mapping(uint64 => CertificateData) public certificates;

    // CNIC => Certificate Type => Certificate ID
    mapping(uint64 => mapping(CertificateType => uint64)) public activeCertificate;

    event CertificateIssued(
        uint64 indexed certificateId,
        uint64 indexed cnic,
        CertificateType certificateType
    );

    event CertificateRevoked(uint64 indexed certificateId);

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
        address _thirdParty,
        address _validationContract,
        address _citizenContract
    ) {
        require(_government != address(0), "Invalid government address");
        require(_thirdParty != address(0), "Invalid third party address");
        require(_validationContract != address(0), "Invalid validation contract");
        require(_citizenContract != address(0), "Invalid citizen contract");

        government = _government;
        authorizedThirdParty = _thirdParty;
        validationContract = IValidation(_validationContract);
        citizenContract = ICitizenCertificate(_citizenContract);
    }

    // Government changes the authorized third party
    function setAuthorizedThirdParty(address _newThirdParty) external onlyGovernment {
        require(_newThirdParty != address(0), "Invalid third party address");

        address oldThirdParty = authorizedThirdParty;
        authorizedThirdParty = _newThirdParty;

        emit ThirdPartyChanged(oldThirdParty, _newThirdParty);
    }

    // Generic Issue Certificate Function for any CertificateType
    function issueCertificate(uint64 _cnic, CertificateType _type)
        external
        onlyAuthorizedThirdParty
    {
        // 1. Check qualification condition based on type
        if (_type == CertificateType.GraphicDesigning) {
            require(
                validationContract.graphicDesigningCertificateCondition(_cnic),
                "Citizen does not meet Graphic Designing requirements"
            );
        } else if (_type == CertificateType.WebDevelopment) {
            require(
                validationContract.webDevelopmentCertificateCondition(_cnic),
                "Citizen does not meet Web Development requirements"
            );
        }

        // 2. Ensure citizen does not already have an active certificate of this type
        require(
            activeCertificate[_cnic][_type] == 0,
            "Active certificate of this type already exists"
        );

        // 3. Retrieve Citizen metadata
        (string memory name, , , , bool exists) = citizenContract.getCitizen(_cnic);
        require(exists, "Citizen does not exist");

        // 4. Save Packed Struct to Storage
        uint64 certId = nextCertificateId;

        certificates[certId] = CertificateData({
            certificateId: certId,
            citizenCNIC: _cnic,
            issueDate: uint64(block.timestamp),
            certificateType: _type,
            isActive: true,
            citizenName: name
        });

        activeCertificate[_cnic][_type] = certId;
        nextCertificateId++;

        emit CertificateIssued(certId, _cnic, _type);
    }

    // Government revokes a certificate
    function revokeCertificate(uint64 _certificateId) external onlyGovernment {
        CertificateData storage certificate = certificates[_certificateId];
        require(certificate.isActive, "Certificate is already revoked or does not exist");

        certificate.isActive = false;

        // Reset active certificate mapping
        activeCertificate[certificate.citizenCNIC][certificate.certificateType] = 0;

        emit CertificateRevoked(_certificateId);
    }

    // Verify certificate authenticity
    function verifyCertificate(uint64 _certificateId)
        external
        view
        returns (
            string memory citizenName,
            uint64 citizenCNIC,
            CertificateType certificateType,
            uint64 issueDate,
            bool isActive
        )
    {
        CertificateData storage cert = certificates[_certificateId];
        require(cert.certificateId != 0, "Certificate does not exist");

        return (
            cert.citizenName,
            cert.citizenCNIC,
            cert.certificateType,
            cert.issueDate,
            cert.isActive
        );
    }
}