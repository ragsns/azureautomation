$azureAccountName ="<sp-app-id-from-service-principal>"
$azurePassword = ConvertTo-SecureString "<sp-password-from-service-principal>" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName, $azurePassword)

Add-AzureRmAccount -Credential $psCred -TenantId <sp-tenant-id-from-service-principal> -ServicePrincipal

Write-Output "Downscaling Cluster"

Set-AzureRmHDInsightClusterSize -ClusterName "<ClusterName>" -TargetInstanceCount 1

Write-OutPut ""
Write-OutPut "End of Job"
