<#
    .SYNOPSIS
        Perform connectivity tests to validate Azure Stack HCI network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs: 
        https://learn.microsoft.com/en-us/azure-stack/hci/concepts/firewall-requirements#recommended-firewall-urls
#>
function Check-Stack-HCI-Dependencies {
    Write-Host ">> Running Stack HCI cluster checks" -ForegroundColor Green

    try
    {
        Test-NetConnection login.microsoftonline.com -Port 443 -WarningAction Stop 
        Test-NetConnection graph.windows.net -Port 443 -WarningAction Stop
        Test-NetConnection dp.stackhci.azure.com -Port 443 -WarningAction Stop 

        Test-NetConnection windowsupdate.microsoft.com -Port 80 -WarningAction Stop
        Test-NetConnection update.microsoft.com -Port 80 -WarningAction Stop
        Test-NetConnection download.windowsupdate.com -Port 80 -WarningAction Stop
        # Test-NetConnection wustat.windows.com -Port 80 -WarningAction Stop               # <-- Endpoint not reachable
        # Test-NetConnection ntservicepack.microsoft.com -Port 80 -WarningAction Stop      # <-- Endpoint not reachable
        Test-NetConnection go.microsoft.com -Port 80 -WarningAction Stop
        Test-NetConnection dl.delivery.mp.microsoft.com -Port 80 -WarningAction Stop

        Test-NetConnection windowsupdate.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection update.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection download.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection www.powershellgallery.com -Port 443 -WarningAction Stop
        $script:stackHciSucceeded = $true
    }
    catch
    {
        $script:stackHciSucceeded = $false
        $script:stackHciError = $_

    }
}

<#
    .SYNOPSIS
        Perform connectivity tests to validate AKS HCI network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs:
        https://learn.microsoft.com/en-us/azure-stack/aks-hci/system-requirements?tabs=allow-table#network-requirements 
#>
function Check-AKS-HCI-Dependencies {
    Write-Host ">> Running AKS HCI checks" -ForegroundColor Green

    try {
        Test-NetConnection msk8s.api.cdp.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection msk8s.b.tlu.dl.delivery.mp.microsoft.com -Port 80 -WarningAction Stop
        Test-NetConnection msk8s.f.tlu.dl.delivery.mp.microsoft.com -Port 80 -WarningAction Stop
        Test-NetConnection login.microsoftonline.com -Port 443 -WarningAction Stop
        Test-NetConnection login.windows.net -Port 443 -WarningAction Stop
        Test-NetConnection management.azure.com -Port 443 -WarningAction Stop
        Test-NetConnection www.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection msft.sts.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection graph.windows.net -Port 443 -WarningAction Stop
        Test-NetConnection ecpacr.azurecr.io -Port 443 -WarningAction Stop
        Test-NetConnection contoso.blob.core.windows.net -Port 443 -WarningAction Stop
        Test-NetConnection mcr.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection akshci.azurefd.net -Port 443 -WarningAction Stop
        Test-NetConnection v20.events.data.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection adhs.events.data.microsoft.com -Port 443 -WarningAction Stop
        $script:aksHciSucceeded = $true
    }
    catch
    {
        $script:aksHciSucceeded = $false
        $script:aksHciError = $_
    }
}

<#
    .SYNOPSIS
        Perform connectivity tests to validate Arc for Kubernetes network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs: 
        https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements 
#>
function Check-Arc-For-K8s-Dependencies {
    Write-Host ">> Running Arc-For-K8s checks" -ForegroundColor Green

    try {
        Test-NetConnection management.azure.com -Port 443 -WarningAction Stop
        Test-NetConnection westeurope.dp.kubernetesconfiguration.azure.com -Port 443 -WarningAction Stop 
        Test-NetConnection login.microsoftonline.com -Port 443 -WarningAction Stop
        Test-NetConnection westeurope.login.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection mcr.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection mcrflowprodcentralus.data.mcr.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection gbl.his.arc.azure.com -Port 443 -WarningAction Stop
        Test-NetConnection k8connecthelm.azureedge.net -Port 443 -WarningAction Stop

        Test-NetConnection guestnotificationservice.azure.com -Port 443 -WarningAction Stop
        Test-NetConnection sts.windows.net -Port 443 -WarningAction Stop
        Test-NetConnection k8sconnectcsp.azureedge.net -Port 443 -WarningAction Stop

        <#
            To translate the *.servicebus.windows.net wildcard into specific endpoints, use the command 
            \GET https://guestnotificationservice.azure.com/urls/allowlist?api-version=2020-01-01&location=<location>. 
            Within this command, the region must be specified for the <location> placeholder.

            This script tests an arbitrary public service bus endpoint:
        #>

        Test-NetConnection azgnrelay-westeurope-l1.servicebus.windows.net -Port 443 -WarningAction Stop
         $script:arcForK8sSucceeded = $true
    }
    catch
    {
        $script:arcForK8sSucceeded = $false
        $script:arcForK8sError = $_
    }
}

<#
    .SYNOPSIS
        Perform connectivity tests to validate Arc Resource Bridge network requirements

    .NOTES
        Review most up-to-date network requirements in the official docs: 
        https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements 
#>
function Check-Azure-Resource-Bridge-Dependencies {
    Write-Host ">> Running Arc Resource Bridge checks" -ForegroundColor Green

    try
    {
        Test-NetConnection mcr.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection gbl.his.arc.azure.com -Port 443 -WarningAction Stop                               
        Test-NetConnection westeurope.dp.kubernetesconfiguration.azure.com -Port 443 -WarningAction Stop
        Test-NetConnection northwind.servicebus.windows.net -Port 443 -WarningAction Stop
        Test-NetConnection guestnotificationservice.azure.com -Port 443 -WarningAction Stop
        Test-NetConnection westeurope.dp.prod.appliances.azure.com -Port 443 -WarningAction Stop
        Test-NetConnection ecpacr.azurecr.io -Port 443 -WarningAction Stop
        Test-NetConnection contoso.blob.core.windows.net -Port 443 -WarningAction Stop
        Test-NetConnection tlu.dl.delivery.mp.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection geo-prod.do.dsp.mp.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection azurearcfork8sdev.azurecr.io -Port 443 -WarningAction Stop
        Test-NetConnection adhs.events.data.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection v20.events.data.microsoft.com -Port 443 -WarningAction Stop
        Test-NetConnection gcr.io -Port 443 -WarningAction Stop
        Test-NetConnection pypi.org -Port 443 -WarningAction Stop
        $script:arcResBridgeSucceeded = $true
    }
    catch
    {
        $script:arcResBridgeSucceeded = $false
        $script:arcResBridgeError = $_
    }
}

function Get-WarningMessage {
    param ($testNetConnectionError)

    $position = $testNetConnectionError.Exception.Message.IndexOf(":")      
    return $testNetConnectionError.Exception.Message.Substring($position+1)  

}

function Write-CheckResult {
    param (
        [string]$testName,
        [bool]$testSucceded, 
        $testNetConnectionError)

    if ($testSucceded -eq "$true") 
    {
        Write-Host "$testName network dependency checks [SUCCEEDED]" -BackgroundColor Green
    }
    else    {
        $error = Get-WarningMessage $testNetConnectionError
        Write-Host "$testName network dependencies checks [ FAILED]:$error" -BackgroundColor Red
    }
}

Check-Stack-HCI-Dependencies
Check-AKS-HCI-Dependencies
Check-Arc-For-K8s-Dependencies
Check-Azure-Resource-Bridge-Dependencies

Write-CheckResult "Stack HCI cluster" $script:stackHciSucceeded $script:stackHciError
Write-CheckResult "AKS HCI" $script:aksHciSucceeded $script:aksHciError
Write-CheckResult "Arc for Kubernetes" $script:arcForK8sSucceeded $script:arcForK8sError
Write-CheckResult "Arc Resource Bridge" $script:arcResBridgeSucceeded $script:arcResBridgeError