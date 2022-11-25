# Stack HCI network requirements validator 

A simple powershell script to validate that required outbound network connectivity are met for Stack HCI installations.

## Verified network requirements

| Component | Official Documentation |
| --------- | -------------------------- |
| Stack HCI Cluster | [Outbound connectivity requirements](https://learn.microsoft.com/en-us/azure-stack/hci/concepts/firewall-requirements#recommended-firewall-urls) |
| AKS Hybrid | [Outbound connectivity requirements](https://learn.microsoft.com/en-us/azure-stack/aks-hci/system-requirements?tabs=allow-table#network-requirements ) |
| Arc for Kubernetes | [Outbound connectivity requirements](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements) |
| Arc Resource Bridge | [Outbound connectivity requirements](https://learn.microsoft.com/en-us/azure-stack/hci/manage/azure-arc-vm-management-prerequisites) |

## Getting Started

```powershell
PS> .\Stack-HCI-Network-Requirements-Checker.ps1
```

If forward proxy is required pass the proxy address and port as a parameter

```powershell
PS> .\Stack-HCI-Network-Requirements-Checker.ps1 -Proxy "http://proxy:8080"
```
