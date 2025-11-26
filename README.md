# TLS Protocol and Certificate Checker

## Overview
This PowerShell script checks which TLS versions (TLS 1.0, 1.1, 1.2, and 1.3) are supported by a given URL and retrieves SSL certificate details. It also validates whether the certificate is currently valid based on its date range.

## Features
- Tests multiple TLS versions for a given URL.
- Displays certificate details:
  - Subject
  - Issuer
  - Valid From / Valid Until
  - Days until expiry
- Indicates if the certificate is valid (YES/NO).
- Ignores invalid certificates during testing.

## Parameters
- `Url` (string): The target domain (default: `www.google.com`).
- `Port` (int): The port for SSL/TLS (default: `443`).

## Usage
```powershell
# Basic usage
./Check-TLS.ps1 -Url "www.example.com"

# URL With Port
./Check-TLS.ps1 -Url "www.example.com" 8888
```

## Output Example
```
https://www.example.com supports Tls12
Certificate Subject: CN=www.example.com
Issuer: CN=Example CA
Valid From: 01/01/2024 00:00:00
Valid Until: 01/01/2025 00:00:00
Days Until Expiry: 365
Certificate Valid: YES
```

## Notes
- Requires PowerShell 5.1 or later.
- Uses `HttpWebRequest` instead of `Invoke-WebRequest` to avoid session reuse.
- Restores original `SecurityProtocol` and certificate validation callback after each test.

## License
This script is provided as-is without warranty. Use at your own risk.
