$token ="xx"
$subscriptionid = "yyyyyyyy-zzzz-aaaa-bbbb-cccccccccccc"
$resourceGroupName = $token + "rags"
$clusterName = $token

Write-OutPut ""
Write-OutPut "Logging Into Azure"
$connectionName = "AzureRunAsConnection"
$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName

Add-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $servicePrincipalConnection.TenantId `
    -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

Write-OutPut ""
Write-OutPut "Selecting Subscription"
Select-AzureRmSubscription -SubscriptionId $subscriptionid

Write-OutPut ""
Write-OutPut "Deleting Cluster"
Remove-AzureRmHDInsightCluster `
    -ClusterName $clusterName


Write-OutPut ""
Write-OutPut "End of Job"
