# Skills-Based Certificate Issuing System

An Ethereum-based smart contract system that simulates issuing certificates based on a citizen's eligibility and skill scores.

The system contains four connected contracts:

```text
Citizen + Skills → Validation → Certificate
```

## Contracts

- **Citizen.sol** — Stores citizen information: name, CNIC, age, and Intermediate status.
- **Skills.sol** — Stores Graphic Designing and Web Development skill scores.
- **Validation.sol** — Checks whether a citizen meets the requirements for a certificate.
- **Certificate.sol** — Issues, verifies, revokes, and reactivates certificates.

## Roles

### Government

Can:

- Revoke certificates
- Reactivate revoked certificates
- Change the authorized third party

### Authorized Third Party

Can:

- Add/update citizens
- Add/update skills
- Issue certificates

> For testing, the same MetaMask account can be used as both Government and Authorized Third Party.

---

# 1. Deploy and Run

## Requirements

- [Remix IDE](https://remix.ethereum.org/)
- [MetaMask](https://metamask.io/)
- ETH for gas when using a public testnet

In Remix, compile all contracts using Solidity:

```text
0.8.20
```

Then select:

```text
Environment → Injected Provider - MetaMask
```

## Deployment Order

The contracts must be deployed in this order:

```text
1. Citizen
2. Skills
3. Validation
4. Certificate
```

### 1. Deploy Citizen

Constructor:

```text
_government
_thirdParty
```

Use the Government and Authorized Third Party wallet addresses.

Copy the deployed **Citizen contract address**.

### 2. Deploy Skills

Constructor:

```text
_government
_thirdParty
```

Copy the deployed **Skills contract address**.

### 3. Deploy Validation

Constructor:

```text
_citizenContract
_skillsContract
```

Enter:

```text
_citizenContract = Citizen contract address
_skillsContract = Skills contract address
```

Copy the deployed **Validation contract address**.

### 4. Deploy Certificate

Constructor:

```text
_government
_thirdParty
_validationContract
_citizenContract
```

Enter:

```text
_government = Government address
_thirdParty = Authorized Third Party address
_validationContract = Validation contract address
_citizenContract = Citizen contract address
```

The complete system is now deployed.

---

# 2. Using the System

The normal workflow is:

```text
1. Add Citizen
       ↓
2. Add Skills
       ↓
3. Check Eligibility
       ↓
4. Issue Certificate
       ↓
5. Verify Certificate
       ↓
6. Revoke / Reactivate if required
```

# 3. Citizen Contract Functions

## addCitizen

Only the Authorized Third Party can call this.

```text
addCitizen(name, cnic, age, intermediatePassed)
```

Parameters in order:

| Parameter | Type | Example |
|---|---|---|
| `name` | string | `"Ali Ahmed"` |
| `cnic` | uint64 | `123456789` |
| `age` | uint8 | `22` |
| `intermediatePassed` | bool | `true` |

Example:

```text
addCitizen("Ali Ahmed", 123456789, 22, true)
```

## updateCitizen

Updates an existing citizen.

```text
updateCitizen(name, cnic, age, intermediatePassed)
```

Example:

```text
updateCitizen("Ali Ahmed", 123456789, 23, true)
```

## getCitizen

Anyone can call this read function.

```text
getCitizen(cnic)
```

Example:

```text
getCitizen(123456789)
```

Returns:

```text
name
cnic
age
intermediatePassed
exists
```

## citizenExists

Checks whether a citizen exists.

```text
citizenExists(cnic)
```

Example:

```text
citizenExists(123456789)
```

Returns:

```text
true / false
```

## setAuthorizedThirdParty

Only Government can call this.

```text
setAuthorizedThirdParty(newThirdParty)
```

Example:

```text
setAuthorizedThirdParty(0x123...)
```

---

# 4. Skills Contract Functions

All skill scores must be between `0` and `100`.

## setGraphicDesigningSkills

Only the Authorized Third Party can call this.

```text
setGraphicDesigningSkills(
    cnic,
    adobeCreativeTool,
    figma,
    premiere,
    photoshop
)
```

Parameters in order:

| Parameter | Type | Example |
|---|---|---|
| `cnic` | uint64 | `123456789` |
| `adobeCreativeTool` | uint8 | `80` |
| `figma` | uint8 | `75` |
| `premiere` | uint8 | `65` |
| `photoshop` | uint8 | `85` |

Example:

```text
setGraphicDesigningSkills(123456789, 80, 75, 65, 85)
```

## setWebDevelopmentSkills

```text
setWebDevelopmentSkills(
    cnic,
    react,
    typescript,
    django,
    api
)
```

Example:

```text
setWebDevelopmentSkills(123456789, 80, 70, 85, 75)
```

## getGraphicDesigningSkills

```text
getGraphicDesigningSkills(cnic)
```

Example:

```text
getGraphicDesigningSkills(123456789)
```

Returns:

```text
adobeCreativeTool
figma
premiere
photoshop
```

## getWebDevelopmentSkills

```text
getWebDevelopmentSkills(cnic)
```

Example:

```text
getWebDevelopmentSkills(123456789)
```

Returns:

```text
react
typescript
django
api
```

## setAuthorizedThirdParty

Only Government can call this.

```text
setAuthorizedThirdParty(newThirdParty)
```

---

# 5. Validation Contract Functions

The Validation contract checks the citizen's eligibility using data from the Citizen and Skills contracts.

A citizen must:

- Exist
- Be at least `18` years old
- Have passed Intermediate

## citizenIsValid

```text
citizenIsValid(cnic)
```

Example:

```text
citizenIsValid(123456789)
```

Returns:

```text
true / false
```

## Graphic Designing Eligibility

Requirements:

- Adobe Creative Tool ≥ `60`
- Photoshop ≥ `60`

Call:

```text
graphicDesigningCertificateCondition(cnic)
```

Example:

```text
graphicDesigningCertificateCondition(123456789)
```

Returns:

```text
true / false
```

## Web Development Eligibility

Requirements:

- React ≥ `60`
- Django ≥ `60`

Call:

```text
webDevelopmentCertificateCondition(cnic)
```

Example:

```text
webDevelopmentCertificateCondition(123456789)
```

Returns:

```text
true / false
```

---

# 6. Certificate Contract Functions

## issueCertificate

Only the Authorized Third Party can call this.

```text
issueCertificate(cnic, type)
```

There are **two parameters**:

| Parameter | Meaning | Example |
|---|---|---|
| `cnic` | Citizen's CNIC | `123456789` |
| `type` | Certificate type | `0` or `1` |

Certificate types:

```text
0 = Graphic Designing
1 = Web Development
```

### Graphic Designing Example

```text
issueCertificate(123456789, 0)
```

### Web Development Example

```text
issueCertificate(123456789, 1)
```

The contract automatically:

1. Checks eligibility.
2. Checks that the citizen exists.
3. Checks that the citizen does not already have an active certificate of that type.
4. Generates the certificate ID automatically.
5. Stores the certificate.
6. Marks it as active.

You **do not enter the certificate ID yourself**.

For example:

```text
nextCertificateId = 1

issueCertificate(123456789, 0)

Certificate ID = 1
```

The next certificate will receive ID `2`.

---

# 7. Verify Certificate

Anyone can call:

```text
verifyCertificate(certificateId)
```

Example:

```text
verifyCertificate(1)
```

It returns:

```text
citizenName
citizenCNIC
certificateType
issueDate
isActive
```

Example:

```text
Certificate ID: 1
Citizen Name: Ali Ahmed
CNIC: 123456789
Type: GraphicDesigning
Issue Date: ...
Active: true
```

---

# 8. Revoke Certificate

Only the Government can call:

```text
revokeCertificate(certificateId)
```

Example:

```text
revokeCertificate(1)
```

After revocation:

```text
isActive = false
```

The certificate is **not deleted from the blockchain**.

Its information remains stored, but it is no longer active.

The active certificate mapping is also reset:

```text
activeCertificate[cnic][type] = 0
```

This allows another certificate of the same type to be issued later.

---

# 9. Reactivate Certificate

Only the Government can call:

```text
reactivateCertificate(certificateId)
```

Example:

```text
reactivateCertificate(1)
```

The certificate must:

- Exist
- Currently be inactive
- Not conflict with another active certificate of the same type

After successful reactivation:

```text
isActive = true
```

and:

```text
activeCertificate[cnic][type] = certificateId
```

Therefore, the certificate keeps its **original certificate ID**.

Example:

```text
Issue Certificate
Certificate ID = 1
        ↓
Revoke
isActive = false
        ↓
Reactivate
isActive = true
Certificate ID = 1
```

---

# 10. Certificate Active Status Lookup

The following public mapping is also available in Remix:

```text
activeCertificate(cnic, type)
```

Parameters:

```text
cnic
type
```

Example:

```text
activeCertificate(123456789, 0)
```

If the result is:

```text
1
```

it means Certificate `1` is currently the active Graphic Designing certificate for that citizen.

If the result is:

```text
0
```

it means the citizen currently has no active certificate of that type.

Remember:

```text
0 = Graphic Designing
1 = Web Development
```

---

# 11. Other Certificate Contract Read Functions

Because these variables are declared `public`, Solidity automatically creates getter functions for them.

## government

```text
government()
```

Returns the Government wallet address.

## authorizedThirdParty

```text
authorizedThirdParty()
```

Returns the currently authorized third-party wallet address.

## nextCertificateId

```text
nextCertificateId()
```

Returns the ID that will be assigned to the next certificate.

## certificates

```text
certificates(certificateId)
```

Example:

```text
certificates(1)
```

Returns the stored certificate data for Certificate `1`.

## validationContract

```text
validationContract()
```

Returns the Validation contract address.

## citizenContract

```text
citizenContract()
```

Returns the Citizen contract address.

---

# 12. Change Authorized Third Party

Only Government can change the authorized third party.

In the Certificate, Citizen, and Skills contracts:

```text
setAuthorizedThirdParty(newThirdParty)
```

Example:

```text
setAuthorizedThirdParty(0xABC...)
```

The new address becomes the account allowed to perform third-party operations.

---

# 13. Complete Testing Example

Use one MetaMask account as both Government and Authorized Third Party for easy testing.

### Step 1 — Add Citizen

```text
addCitizen("Ali Ahmed", 123456789, 22, true)
```

### Step 2 — Add Graphic Designing Skills

```text
setGraphicDesigningSkills(123456789, 80, 75, 65, 85)
```

### Step 3 — Check Eligibility

```text
graphicDesigningCertificateCondition(123456789)
```

Expected:

```text
true
```

### Step 4 — Issue Certificate

```text
issueCertificate(123456789, 0)
```

Certificate ID:

```text
1
```

### Step 5 — Verify

```text
verifyCertificate(1)
```

Expected:

```text
isActive = true
```

### Step 6 — Revoke

```text
revokeCertificate(1)
```

Now:

```text
isActive = false
```

### Step 7 — Reactivate

```text
reactivateCertificate(1)
```

Now:

```text
isActive = true
```

The certificate is active again with the same ID:

```text
Certificate ID = 1
```

---

# 14. Reuse Already Deployed Contracts

If the contracts are already deployed, you do **not** need to deploy them again.

You need:

```text
Citizen contract address
Skills contract address
Validation contract address
Certificate contract address
```

## Steps

1. Connect MetaMask to the **same network** where the contracts were deployed.
2. Open Remix.
3. Compile the contracts using Solidity `0.8.20`.
4. Select:

```text
Injected Provider - MetaMask
```

5. Select the required contract.
6. Use:

```text
+ Add Contract
```

7. Enter the existing contract address.

For example:

```text
Citizen → + Add Contract → Citizen contract address

Skills → + Add Contract → Skills contract address

Validation → + Add Contract → Validation contract address

Certificate → + Add Contract → Certificate contract address
```

`+ Add Contract` connects Remix to an existing deployed contract and **does not deploy a new contract**.

> Using an existing contract address does not give permission to modify it. Only the configured Government and Authorized Third Party accounts can perform their respective restricted actions.

---

# 15. Contract Relationship

```text
                  Citizen
                     │
                     │ Citizen information
                     ↓
                  Validation
                     ↑
                     │
                   Skills
                     │
                     ↓
                Certificate
                     │
          ┌──────────┼──────────┐
          ↓          ↓          ↓
        Issue      Verify     Revoke
                                │
                                ↓
                            Reactivate
```

The overall system is summarized as:

```text
Citizen + Skills
       ↓
Validation
       ↓
Eligible?
   ↓       ↓
  Yes      No
   ↓       ↓
Certificate  Reject
   ↓
Active Certificate
   ↓
Revoke ↔ Reactivate
```

**Important:** Certificate IDs are generated automatically by the Certificate contract; they are not entered manually when calling `issueCertificate()`.