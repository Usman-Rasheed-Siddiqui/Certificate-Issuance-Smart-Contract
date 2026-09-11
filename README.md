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
- **Certificate.sol** — Issues, verifies, and revokes certificates.

## Roles

### Government
Can:
- Revoke certificates
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

- [Remix IDE](https://remix.ethereum.org/?utm_source=chatgpt.com)
- [MetaMask](https://metamask.io/?utm_source=chatgpt.com)
- ETH for gas when using a public testnet

In Remix, compile all contracts using Solidity version:

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

Copy the deployed **Citizen contract address**.

### 2. Deploy Skills

Constructor:

```text
_government
_thirdParty
```

Copy the deployed **Skills contract address**.

### 3. Deploy Validation

Use the previously deployed addresses:

```text
_citizenContract = Citizen contract address
_skillsContract = Skills contract address
```

Copy the deployed **Validation contract address**.

### 4. Deploy Certificate

Enter:

```text
_government = Government address
_thirdParty = Authorized Third Party address
_validationContract = Validation contract address
_citizenContract = Citizen contract address
```

The complete system is now deployed.

## Using the System

The normal workflow is:

```text
1. Add Citizen
        ↓
2. Add Skills
        ↓
3. Check Validation
        ↓
4. Issue Certificate
        ↓
5. Verify Certificate
```

### Add a Citizen

Using the **Authorized Third Party** account, call:

```text
addCitizen(name, cnic, age, intermediatePassed)
```

### Add Skills

For Graphic Designing:

```text
setGraphicDesigningSkills(cnic, adobeCreativeTool, figma, premiere, photoshop)
```

For Web Development:

```text
setWebDevelopmentSkills(cnic, react, typescript, django, api)
```

All scores must be between `0` and `100`.

### Check Eligibility

A citizen must:

- Exist
- Be at least `18` years old
- Have passed Intermediate

For **Graphic Designing**:

- Adobe Creative Tool ≥ `60`
- Photoshop ≥ `60`

For **Web Development**:

- React ≥ `60`
- Django ≥ `60`

Check using:

```text
graphicDesigningCertificateCondition(cnic)
webDevelopmentCertificateCondition(cnic)
```

### Issue Certificate

Using the **Authorized Third Party** account:

```text
issueCertificate(cnic, type)
```

Certificate types:

```text
0 = Graphic Designing
1 = Web Development
```

A citizen can only have **one active certificate of each type**.

### Verify Certificate

Anyone can call:

```text
verifyCertificate(certificateId)
```

This returns the citizen information, certificate type, issue date, and whether the certificate is active.

### Revoke Certificate

Only the **Government** can call:

```text
revokeCertificate(certificateId)
```

After revocation, the certificate remains on-chain but:

```text
isActive = false
```

---

# 2. Reuse Already Deployed Contracts

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
2. Open Remix and compile the contracts using Solidity `0.8.20`.
3. Select `Injected Provider - MetaMask`.
4. Select each contract and use:

```text
At Address
```

5. Enter its existing contract address.

For example:

```text
Citizen → At Address → Citizen contract address
Skills → At Address → Skills contract address
Validation → At Address → Validation contract address
Certificate → At Address → Certificate contract address
```

`At Address` connects Remix to an existing deployed contract and **does not deploy a new contract**.

> Using an existing contract address does not give permission to modify it. Only the configured Government and Authorized Third Party accounts can perform their respective restricted actions.

## Summary

```text
Citizen + Skills
       ↓
   Validation
       ↓
   Certificate
```

**Deploy from scratch:** Deploy all contracts in the required order and use the previous contract addresses when deploying dependent contracts.

**Reuse existing deployment:** Connect to the correct network and use Remix's `At Address` option with the deployed contract addresses.