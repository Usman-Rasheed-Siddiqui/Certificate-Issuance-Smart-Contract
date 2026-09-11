# Skills-Based Certificate Issuing System

An Ethereum-based smart contract system that simulates a government-backed certificate issuing process based on a citizen's **personal information, education status, and technical skills**.

The system consists of four interconnected Solidity smart contracts:

- **Citizen** — Stores citizen information.
- **Skills** — Stores skill scores for citizens.
- **Validation** — Determines whether a citizen qualifies for a specific certificate.
- **Certificate** — Issues, verifies, and revokes certificates for eligible citizens.

The contracts are designed to work together as:

```text
Citizen ───────┐
               ├──> Validation ───> Certificate
Skills ────────┘
```

---

## Features

- Store citizen information on-chain.
- Store skill scores from 0–100.
- Automatically check certificate eligibility.
- Issue certificates only to eligible citizens.
- Prevent multiple active certificates of the same type for one citizen.
- Verify certificate authenticity.
- Revoke certificates through the government account.
- Allow the government to change the authorized third party.
- Reuse already deployed contracts through their contract addresses.

---

# Smart Contracts

## 1. Citizen.sol

The `Citizen` contract stores basic information about citizens.

Each citizen contains:

- Name
- CNIC
- Age
- Intermediate status
- Existence status

### Main functions

| Function | Purpose |
|---|---|
| `addCitizen()` | Adds a new citizen |
| `updateCitizen()` | Updates citizen information |
| `getCitizen()` | Retrieves citizen information |
| `citizenExists()` | Checks whether a citizen exists |
| `setAuthorizedThirdParty()` | Changes the authorized third party |

Only the **Authorized Third Party** can add or update citizens.

---

## 2. Skills.sol

The `Skills` contract stores skill scores for citizens.

### Graphic Designing Skills

- Adobe Creative Tool
- Figma
- Premiere
- Photoshop

### Web Development Skills

- React
- TypeScript
- Django
- API

Each skill has a score between **0 and 100**.

### Main functions

| Function | Purpose |
|---|---|
| `setGraphicDesigningSkills()` | Stores graphic designing scores |
| `setWebDevelopmentSkills()` | Stores web development scores |
| `getGraphicDesigningSkills()` | Retrieves graphic designing scores |
| `getWebDevelopmentSkills()` | Retrieves web development scores |
| `setAuthorizedThirdParty()` | Changes the authorized third party |

Only the **Authorized Third Party** can modify skills.

---

## 3. Validation.sol

The `Validation` contract connects the `Citizen` and `Skills` contracts.

It determines whether a citizen satisfies the requirements for a certificate.

### General requirements

A citizen must:

- Exist in the Citizen contract.
- Be at least **18 years old**.
- Have passed Intermediate.

### Graphic Designing Certificate

The citizen must have:

- Adobe Creative Tool >= 60
- Photoshop >= 60

### Web Development Certificate

The citizen must have:

- React >= 60
- Django >= 60

The passing score is defined as:

```solidity
PASSING_SCORE = 60
```

and the minimum age is:

```solidity
MINIMUM_AGE = 18
```

---

## 4. Certificate.sol

The `Certificate` contract is responsible for issuing, verifying, and revoking certificates.

It connects to:

- Citizen contract
- Validation contract

### Certificate Types

```text
0 = Graphic Designing
1 = Web Development
```

### Main functions

| Function | Purpose |
|---|---|
| `issueCertificate()` | Issues a certificate to an eligible citizen |
| `verifyCertificate()` | Verifies a certificate |
| `revokeCertificate()` | Revokes a certificate |
| `setAuthorizedThirdParty()` | Changes the authorized third party |

---

# Roles

The system uses two main roles.

## Government

The Government account can:

- Revoke certificates.
- Change the authorized third party.

The government address is supplied when deploying the contracts.

---

## Authorized Third Party

The Authorized Third Party can:

- Add citizens.
- Update citizens.
- Add/update citizen skills.
- Issue certificates.

The authorized third party address is also supplied during deployment.

> **Important:** The Government and Authorized Third Party can be the same MetaMask account for testing purposes.

---

# Requirements

To deploy and interact with the contracts, you need:

- A browser such as Chrome or Edge
- MetaMask
- Remix IDE
- Some ETH for transaction gas if deploying to a public testnet

Remix IDE:

https://remix.ethereum.org/

MetaMask:

https://metamask.io/

---

# Part 1 — Deploy and Run From Scratch

This section explains how to deploy all four contracts yourself.

## Step 1 — Open Remix

Open Remix IDE:

https://remix.ethereum.org/

Create a new workspace or use the default workspace.

Create the following four files inside the `contracts` folder:

```text
Citizen.sol
Skills.sol
Validation.sol
Certificate.sol
```

Paste the corresponding Solidity code into each file.

---

# Step 2 — Compile the Contracts

Open the **Solidity Compiler** tab.

Select compiler version:

```text
0.8.20
```

Compile each contract.

You should have:

```text
Citizen
Skills
Validation
Certificate
```

available under the compiled contracts.

---

# Step 3 — Connect Remix to MetaMask

Open the **Deploy & Run Transactions** tab.

Under **Environment**, select:

```text
Injected Provider - MetaMask
```

MetaMask will ask you to connect the account.

Make sure:

1. The correct MetaMask account is selected.
2. MetaMask is connected to the network you want to use.
3. You have enough ETH for deployment/transactions.

For learning and testing, a testnet is recommended rather than using real ETH.

---

# Step 4 — Decide the Two Addresses

Before deployment, decide which MetaMask addresses will represent:

```text
Government
Authorized Third Party
```

For simple testing, you can use the same account for both.

For example:

```text
Government:
0xAAA...

Authorized Third Party:
0xBBB...
```

These are only examples. Use your actual MetaMask addresses.

---

# Step 5 — Deploy Citizen

Select:

```text
Citizen
```

from the contract dropdown.

The constructor requires:

```solidity
constructor(
    address _government,
    address _thirdParty
)
```

Enter:

```text
_government = Government Address
_thirdParty = Authorized Third Party Address
```

For example:

```text
0xAAA...
0xBBB...
```

Click:

```text
Deploy
```

Confirm the transaction in MetaMask.

After deployment, Remix will show the deployed `Citizen` contract under **Deployed Contracts**.

### Copy the Citizen contract address.

You will need this address later.

For example:

```text
Citizen Contract:
0x111...
```

---

# Step 6 — Deploy Skills

Select:

```text
Skills
```

The constructor requires:

```solidity
constructor(
    address _government,
    address _thirdParty
)
```

Enter:

```text
_government = Government Address
_thirdParty = Authorized Third Party Address
```

Click:

```text
Deploy
```

Confirm the MetaMask transaction.

Copy the deployed contract address.

For example:

```text
Skills Contract:
0x222...
```

---

# Step 7 — Deploy Validation

Now deploy the `Validation` contract.

Its constructor requires two contract addresses:

```solidity
constructor(
    address _citizenContract,
    address _skillsContract
)
```

Enter:

```text
_citizenContract = Citizen Contract Address
_skillsContract = Skills Contract Address
```

For example:

```text
0x111...
0x222...
```

Click:

```text
Deploy
```

Confirm the transaction.

Copy the deployed Validation address.

For example:

```text
Validation Contract:
0x333...
```

---

# Step 8 — Deploy Certificate

Finally, deploy the `Certificate` contract.

Its constructor requires four addresses:

```solidity
constructor(
    address _government,
    address _thirdParty,
    address _validationContract,
    address _citizenContract
)
```

Enter them in this exact order:

```text
_government          = Government Address
_thirdParty          = Authorized Third Party Address
_validationContract  = Validation Contract Address
_citizenContract     = Citizen Contract Address
```

For example:

```text
0xAAA...
0xBBB...
0x333...
0x111...
```

Click:

```text
Deploy
```

Confirm the transaction.

You now have the complete system deployed.

---

# Deployment Dependency Order

The contracts **must be deployed in this order**:

```text
Citizen
   +
Skills
   ↓
Validation
   ↓
Certificate
```

The addresses of previously deployed contracts are required when deploying the dependent contracts.

---

# Part 2 — Running the System

After deploying all four contracts, the normal workflow is:

```text
Add Citizen
     ↓
Add Skills
     ↓
Check Eligibility
     ↓
Issue Certificate
     ↓
Verify Certificate
     ↓
(Optional) Revoke Certificate
```

---

# Step 1 — Add a Citizen

Open the deployed `Citizen` contract.

Find:

```text
addCitizen
```

It requires:

```text
_name
_cnic
_age
_intermediatePassed
```

Example:

```text
_name:
Ali Ahmed

_cnic:
123456789

_age:
22

_intermediatePassed:
true
```

Click `transact`.

Confirm the transaction in MetaMask.

### Important

You must be connected with the **Authorized Third Party** account.

Otherwise, the transaction will fail with:

```text
Only authorized third party can perform this action
```

---

# Step 2 — Add Graphic Designing Skills

Open the deployed `Skills` contract.

Find:

```text
setGraphicDesigningSkills
```

Enter:

```text
_cnic = 123456789
_adobeCreativeTool = 80
_figma = 70
_premiere = 65
_photoshop = 85
```

Click `transact`.

The scores must be between:

```text
0 - 100
```

---

# Step 3 — Add Web Development Skills

You can also add Web Development skills for the same citizen.

Use:

```text
setWebDevelopmentSkills
```

Example:

```text
_cnic = 123456789
_react = 85
_typescript = 70
_django = 90
_api = 80
```

Click `transact`.

---

# Step 4 — Check Eligibility

Open the deployed `Validation` contract.

For Graphic Designing, call:

```text
graphicDesigningCertificateCondition
```

Enter:

```text
123456789
```

The result should be:

```text
true
```

because:

```text
Adobe Creative Tool = 80 >= 60
Photoshop           = 85 >= 60
```

The citizen is also:

```text
Age = 22 >= 18
Intermediate = true
```

Therefore, the citizen qualifies.

---

For Web Development, call:

```text
webDevelopmentCertificateCondition
```

with:

```text
123456789
```

The result should also be:

```text
true
```

because:

```text
React  = 85 >= 60
Django = 90 >= 60
```

---

# Step 5 — Issue a Certificate

Open the deployed `Certificate` contract.

Find:

```text
issueCertificate
```

It requires:

```text
_cnic
_type
```

The certificate type is an enum:

```solidity
enum CertificateType {
    GraphicDesigning,
    WebDevelopment
}
```

Therefore:

```text
0 = Graphic Designing
1 = Web Development
```

### Example: Graphic Designing

Enter:

```text
_cnic = 123456789
_type = 0
```

Click `transact`.

The transaction must be sent from the **Authorized Third Party** account.

If successful, a certificate ID will be assigned automatically.

The first certificate will normally have:

```text
certificateId = 1
```

---

# Step 6 — Verify the Certificate

Use:

```text
verifyCertificate
```

Enter the certificate ID:

```text
1
```

The contract returns:

```text
citizenName
citizenCNIC
certificateType
issueDate
isActive
```

For example:

```text
citizenName: Ali Ahmed
citizenCNIC: 123456789
certificateType: 0
issueDate: ...
isActive: true
```

This confirms that the certificate exists and is currently active.

---

# Step 7 — Revoke a Certificate

Only the **Government** account can revoke a certificate.

Use:

```text
revokeCertificate
```

Enter:

```text
1
```

Click `transact`.

After successful execution, calling:

```text
verifyCertificate(1)
```

will show:

```text
isActive = false
```

The certificate still exists on-chain, but it is no longer active.

---

# Important Permission Rules

| Action | Government | Authorized Third Party |
|---|---:|---:|
| Add citizen | ❌ | ✅ |
| Update citizen | ❌ | ✅ |
| Add/update skills | ❌ | ✅ |
| Issue certificate | ❌ | ✅ |
| Verify certificate | Anyone | Anyone |
| Check eligibility | Anyone | Anyone |
| Revoke certificate | ✅ | ❌ |
| Change authorized third party | ✅ | ❌ |

Read-only functions such as `getCitizen()`, skill getters, validation functions, and `verifyCertificate()` can be called without being the Government or Authorized Third Party.

---

# Part 3 — Reusing Already Deployed Contracts

If someone else has already deployed the four contracts, **you do not need to deploy them again**.

You only need their contract addresses and the correct network.

You will need:

```text
Citizen Contract Address
Skills Contract Address
Validation Contract Address
Certificate Contract Address
```

For example:

```text
Citizen:
0x111...

Skills:
0x222...

Validation:
0x333...

Certificate:
0x444...
```

---

# Step 1 — Connect MetaMask

Open Remix and connect:

```text
Injected Provider - MetaMask
```

Make sure MetaMask is connected to the **same network on which the contracts were deployed**.

For example, if the contracts were deployed on Sepolia, your MetaMask must also be connected to Sepolia.

---

# Step 2 — Compile the Contracts

You still need the Solidity source code/interface in Remix so that Remix knows the contract's ABI.

Compile the contracts using:

```text
Solidity 0.8.20
```

---

# Step 3 — Use "At Address"

In the **Deploy & Run Transactions** tab, select the required contract from the contract dropdown.

Instead of clicking `Deploy`, use:

```text
At Address
```

Enter the already deployed contract address.

For example:

```text
0x111...
```

Click:

```text
At Address
```

Remix will load the existing contract under **Deployed Contracts**.

### Important

`At Address` does **not** deploy a new contract.

It simply tells Remix:

> "Use this already deployed contract at this blockchain address."

---

# Step 4 — Connect Each Contract

Repeat the process for all four contracts.

### Citizen

Select:

```text
Citizen
```

Then:

```text
At Address → Citizen Contract Address
```

### Skills

Select:

```text
Skills
```

Then:

```text
At Address → Skills Contract Address
```

### Validation

Select:

```text
Validation
```

Then:

```text
At Address → Validation Contract Address
```

### Certificate

Select:

```text
Certificate
```

Then:

```text
At Address → Certificate Contract Address
```

You can now interact with the existing deployment.

---

# Reuse Example

Suppose a project owner provides:

```text
Network:
Sepolia

Citizen:
0x1111111111111111111111111111111111111111

Skills:
0x2222222222222222222222222222222222222222

Validation:
0x3333333333333333333333333333333333333333

Certificate:
0x4444444444444444444444444444444444444444
```

You would:

```text
1. Connect MetaMask to Sepolia
2. Open Remix
3. Compile the contracts
4. Select Citizen → At Address → Citizen address
5. Select Skills → At Address → Skills address
6. Select Validation → At Address → Validation address
7. Select Certificate → At Address → Certificate address
```

No deployment is required.

---

# Permissions When Reusing Contracts

Using the contract address does **not** automatically give you permission to modify the contract.

For example, if the existing deployment has:

```text
Authorized Third Party:
0xBBB...
```

and your MetaMask account is:

```text
0xCCC...
```

you cannot call:

```text
addCitizen()
setGraphicDesigningSkills()
setWebDevelopmentSkills()
issueCertificate()
```

because your address is not the authorized third party.

Similarly, only the configured Government address can:

```text
revokeCertificate()
setAuthorizedThirdParty()
```

However, read-only functions can generally be used by any connected account.

---

# Complete Example

Assume the following citizen:

```text
Name:
Ali Ahmed

CNIC:
123456789

Age:
22

Intermediate:
Passed
```

Graphic Designing skills:

```text
Adobe Creative Tool: 80
Figma: 70
Premiere: 65
Photoshop: 85
```

Web Development skills:

```text
React: 85
TypeScript: 70
Django: 90
API: 80
```

The Validation contract checks:

### Graphic Designing

```text
Age >= 18
Intermediate = true
Adobe Creative Tool >= 60
Photoshop >= 60
```

Result:

```text
Eligible = true
```

### Web Development

```text
Age >= 18
Intermediate = true
React >= 60
Django >= 60
```

Result:

```text
Eligible = true
```

The Authorized Third Party can then issue:

```text
issueCertificate(123456789, 0)
```

for Graphic Designing.

Or:

```text
issueCertificate(123456789, 1)
```

for Web Development.

---

# Important Behavior

## One Active Certificate Per Type

A citizen cannot have two active certificates of the same type.

For example, after issuing:

```text
Graphic Designing Certificate
```

another attempt to issue the same certificate type for the same CNIC will fail with:

```text
Active certificate of this type already exists
```

The Government can revoke the existing certificate first.

After revocation, another certificate of the same type can be issued.

---

# Certificate IDs

Certificate IDs are generated automatically.

The contract starts with:

```solidity
nextCertificateId = 1;
```

After each successful certificate issuance:

```text
1 → 2 → 3 → 4 → ...
```

The certificate ID is therefore assigned by the smart contract rather than manually entered by the user.

---

# Events

The contracts emit events that can be viewed through blockchain transaction logs.

### Citizen

```text
CitizenAdded
CitizenUpdated
ThirdPartyChanged
```

### Skills

```text
GraphicDesigningSkillsUpdated
WebDevelopmentSkillsUpdated
ThirdPartyChanged
```

### Certificate

```text
CertificateIssued
CertificateRevoked
ThirdPartyChanged
```

These events provide an on-chain record of important actions.

---

# Contract Relationship

The complete architecture is:

```text
                 ┌──────────────────┐
                 │     Citizen      │
                 │                  │
                 │ Name             │
                 │ CNIC             │
                 │ Age              │
                 │ Intermediate     │
                 └────────┬─────────┘
                          │
                          │ Citizen Data
                          │
                          ▼
                 ┌──────────────────┐
                 │   Validation     │
                 │                  │
                 │ Age >= 18        │
                 │ Intermediate     │
                 │ Skill >= 60      │
                 └────────┬─────────┘
                          ▲
                          │ Skill Data
                          │
                 ┌────────┴─────────┐
                 │     Skills       │
                 │                  │
                 │ Graphic Design   │
                 │ Web Development  │
                 └──────────────────┘
                          │
                          │ Eligibility
                          ▼
                 ┌──────────────────┐
                 │   Certificate    │
                 │                  │
                 │ Issue            │
                 │ Verify           │
                 │ Revoke           │
                 └──────────────────┘
```

---

# Troubleshooting

## "Only authorized third party can perform this action"

Your connected MetaMask account is not the `authorizedThirdParty` address stored in the contract.

Check:

```text
authorizedThirdParty()
```

and compare it with your MetaMask address.

---

## "Only government can perform this action"

Your connected MetaMask account is not the configured Government address.

Check:

```text
government()
```

and compare it with your MetaMask address.

---

## "Citizen already exists"

The CNIC has already been registered.

Use:

```text
getCitizen(CNIC)
```

to retrieve the existing citizen.

---

## "Citizen does not exist"

The CNIC has not been added to the Citizen contract.

Add the citizen before attempting to issue a certificate.

---

## "Citizen does not meet Graphic Designing requirements"

The citizen does not satisfy one or more of the following:

```text
Age >= 18
Intermediate passed
Adobe Creative Tool >= 60
Photoshop >= 60
```

---

## "Citizen does not meet Web Development requirements"

The citizen does not satisfy one or more of the following:

```text
Age >= 18
Intermediate passed
React >= 60
Django >= 60
```

---

## "Active certificate of this type already exists"

The citizen already has an active certificate of that type.

You must revoke the existing certificate before issuing another one of the same type.

---

## "Certificate does not exist"

The certificate ID provided to `verifyCertificate()` does not correspond to an issued certificate.

---

# Quick Reference

## Deployment Order

```text
Citizen
↓
Skills
↓
Validation
↓
Certificate
```

## Certificate Types

```text
0 → Graphic Designing
1 → Web Development
```

## Graphic Designing Requirements

```text
Age >= 18
Intermediate = Passed
Adobe Creative Tool >= 60
Photoshop >= 60
```

## Web Development Requirements

```text
Age >= 18
Intermediate = Passed
React >= 60
Django >= 60
```

## Main Roles

```text
Government
    ↓
Revoke certificates
Change authorized third party

Authorized Third Party
    ↓
Manage citizens
Manage skills
Issue certificates

Anyone
    ↓
Read/verify public information
```

---

# Summary

This project demonstrates how multiple Ethereum smart contracts can be connected to create a complete certificate issuing system.

The four contracts have separate responsibilities:

```text
Citizen
   ↓
Stores citizen information

Skills
   ↓
Stores skill information

Validation
   ↓
Determines eligibility

Certificate
   ↓
Issues and verifies certificates
```

The system can either be:

### Deployed from scratch

```text
Deploy Citizen
→ Deploy Skills
→ Deploy Validation
→ Deploy Certificate
→ Use the system
```

or:

### Reused from an existing deployment

```text
Obtain contract addresses
→ Connect MetaMask to correct network
→ Compile contracts in Remix
→ Use "At Address"
→ Interact with existing contracts
```

No new deployment is required when reusing an existing deployment.