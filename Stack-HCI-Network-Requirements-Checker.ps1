#Requires -Version 7
param(
    [Parameter(Mandatory=$False, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $Proxy
)

<#
    .SYNOPSIS
        Perform connectivity tests to validate Azure Stack HCI network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs:
        https://learn.microsoft.com/en-us/azure-stack/hci/concepts/firewall-requirements#recommended-firewall-urls
#>
function Test-Stack-HCI-Dependencies {
    Write-Host "Running Stack HCI cluster checks" -BackgroundColor DarkCyan

    $checks = @(
        "login.microsoftonline.com:443"
        "graph.windows.net:443"
        "dp.stackhci.azure.com:443"
        "management.azure.com:443"
        "windowsupdate.microsoft.com:80"
        "windowsupdate.microsoft.com:443"
        "update.microsoft.com:80"
        "update.microsoft.com:443"
        "download.windowsupdate.com:80"
        "go.microsoft.com:80"
        "dl.delivery.mp.microsoft.com:80"
        "download.microsoft.com:443"
        "www.powershellgallery.com:443"

        # "wustat.windows.com:80"           # <-- Endpoint not reachable
        # "ntservicepack.microsoft.com:80"  # <-- Endpoint not reachable
    )

    Invoke-Checks $checks
    Write-Host ""
}

<#
    .SYNOPSIS
        Perform connectivity tests to validate AKS HCI network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs:
        https://learn.microsoft.com/en-us/azure-stack/aks-hci/system-requirements?tabs=allow-table#network-requirements
#>
function Test-AKS-HCI-Dependencies {
    Write-Host "Running AKS HCI checks" -BackgroundColor DarkCyan

    $checks = @(
        "msk8s.api.cdp.microsoft.com:443"
        "msk8s.b.tlu.dl.delivery.mp.microsoft.com:80"
        "msk8s.f.tlu.dl.delivery.mp.microsoft.com:80"
        "login.microsoftonline.com:443"
        "login.windows.net:443"
        "management.azure.com:443"
        "www.microsoft.com:443"
        "msft.sts.microsoft.com:443"
        "graph.windows.net:443"
        "ecpacr.azurecr.io:443"
        "contoso.blob.core.windows.net:443"
        "mcr.microsoft.com:443"
        "akshci.azurefd.net:443"
        "v20.events.data.microsoft.com:443"
        "adhs.events.data.microsoft.com:443"
    )

    Invoke-Checks $checks
    Write-Host ""
}

<#
    .SYNOPSIS
        Perform connectivity tests to validate Arc for Kubernetes network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs:
        https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements
#>
function Test-Arc-For-K8s-Dependencies {
    Write-Host "Running Arc-For-K8s checks" -BackgroundColor DarkCyan

    $checks = @(
        "management.azure.com:443"
        "westeurope.dp.kubernetesconfiguration.azure.com:443"
        "login.microsoftonline.com:443"
        "westeurope.login.microsoft.com:443"
        "mcr.microsoft.com:443"
        "mcrflowprodcentralus.data.mcr.microsoft.com:443"
        "gbl.his.arc.azure.com:443"
        "k8connecthelm.azureedge.net:443"
        "guestnotificationservice.azure.com:443"
        "sts.windows.net:443"
        "k8sconnectcsp.azureedge.net:443"
        "azgnrelay-westeurope-l1.servicebus.windows.net:443"
    )

    <#
        To translate the *.servicebus.windows.net wildcard into specific endpoints, use the command
        \GET https://guestnotificationservice.azure.com/urls/allowlist?api-version=2020-01-01&location=<location>.
        Within this command, the region must be specified for the <location> placeholder.

        This script tests an arbitrary public service bus endpoint:
    #>

    Invoke-Checks $checks
    Write-Host ""
}

<#
    .SYNOPSIS
        Perform connectivity tests to validate Arc Resource Bridge network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs:
        https://learn.microsoft.com/en-us/azure-stack/hci/manage/azure-arc-enabled-virtual-machines#firewall-url-exceptions
#>
function Test-Arc-Resource-Bridge-Dependencies {
    Write-Host "Running Arc Resource Bridge checks" -BackgroundColor DarkCyan

    $checks = @(
        "mcr.microsoft.com:443"
        "gbl.his.arc.azure.com:443"
        "westeurope.dp.kubernetesconfiguration.azure.com:443"
        "azgnrelay-westeurope-l1.servicebus.windows.net:443"
        "guestnotificationservice.azure.com:443"
        "westeurope.dp.prod.appliances.azure.com:443"
        "ecpacr.azurecr.io:443"
        "contoso.blob.core.windows.net:443"
        "tlu.dl.delivery.mp.microsoft.com:443"
        "geo-prod.do.dsp.mp.microsoft.com:443"
        "azurearcfork8sdev.azurecr.io:443"
        "adhs.events.data.microsoft.com:443"
        "v20.events.data.microsoft.com:443"
        "pypi.org:443"

        # "gcr.io:443"     # <-- Dependency removed from official docs
    )

    Invoke-Checks $checks
    Write-Host ""
}

function Get-WarningMessage {
    param ($testNetConnectionError)

    $position = $testNetConnectionError.Exception.Message.IndexOf(":")
    return $testNetConnectionError.Exception.Message.Substring($position+1)

}

function Invoke-Checks {
    param ($checks)

    foreach ($check in $checks) {
        $success = $false

        $parsed = $check.Split(":")
        $hostname = $parsed[0]
        $port = $parsed[1]

        if ($port -eq 443) {
            $uri = "https://$hostname/"
        } else {
            $uri = "http://$hostname/"
        }

        try
        {
            if ([string]::IsNullOrEmpty($Proxy)) {
                $null = Invoke-WebRequest -Uri $uri -UseBasicParsing -SkipHttpErrorCheck -SkipCertificateCheck -WarningAction Stop 3>$null
            } else {
                $null = Invoke-WebRequest -Uri $uri -UseBasicParsing -SkipHttpErrorCheck -SkipCertificateCheck -Proxy $Proxy -WarningAction Stop 3>$null
            }

            #$null = Invoke-WebRequest -Uri $uri -UseBasicParsing -SkipHttpErrorCheck -Proxy 'http://127.0.0.1:8888/' -WarningAction Stop 3>$null
            $success = $true
        }
        catch
        {
            # $warning = Get-WarningMessage $_
            $warning = $_
        }

        Write-Host "Connection to $($hostname):$($port) " -NoNewline

        if ($success -eq $true)
        {
            Write-Host "SUCCEEDED" -ForegroundColor Green
        }
        else
        {
            Write-Host "FAILED" -ForegroundColor Red
            Write-Host "--> " -NoNewline
            Write-Warning $warning
        }
    }
}

Test-Stack-HCI-Dependencies
Test-AKS-HCI-Dependencies
Test-Arc-For-K8s-Dependencies
Test-Arc-Resource-Bridge-Dependencies
