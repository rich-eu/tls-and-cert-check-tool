param(
    [string]$Url = "www.google.com",
    [int]$Port = 443
)

$TlsVersions = @(
    [System.Net.SecurityProtocolType]::Tls,
    [System.Net.SecurityProtocolType]::Tls11,
    [System.Net.SecurityProtocolType]::Tls12,
    [System.Net.SecurityProtocolType]::Tls13
)

$Url = "https://" + $Url
$originalProtocol = [Net.ServicePointManager]::SecurityProtocol
$originalCallback = [System.Net.ServicePointManager]::ServerCertificateValidationCallback


foreach ($Tls in $TlsVersions) {

    try {
        [Net.ServicePointManager]::SecurityProtocol = $Tls
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 10
        Write-Host "$Url supports $Tls" -ForegroundColor Green

        # Get certificate details
        $tcpClient = New-Object System.Net.Sockets.TcpClient($Url.Replace("https://",""), $Port)
        $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false, ({$true}))
        $sslStream.AuthenticateAsClient($Url.Replace("https://",""))
        $cert = $sslStream.RemoteCertificate
        $cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $cert

        Write-Host "Certificate Subject: $($cert2.Subject)"
        Write-Host "Issuer: $($cert2.Issuer)"
        Write-Host "Valid From: $($cert2.NotBefore)"
        Write-Host "Valid Until: $($cert2.NotAfter)"
        Write-Host "Days Until Expiry: $((New-TimeSpan -Start (Get-Date) -End $cert2.NotAfter).Days)"                
    }
    catch {
        Write-Host "$Url does NOT support $Tls ($($_.Exception.Message))" -ForegroundColor Red

    }
    finally {

        if ($sslStream -ne $null) { $sslStream.Close() }
        if ($tcpClient -ne $null) { $tcpClient.Close() }

        # Restore original protocol after each iteration
        [Net.ServicePointManager]::SecurityProtocol = $originalProtocol
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $originalCallback       
    }
}

$servicePoint = [System.Net.ServicePointManager]::FindServicePoint($Url)
if ($servicePoint -ne $null) { $servicePoint.CloseConnectionGroup("") | Out-Null }


