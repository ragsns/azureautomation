$token ="xx"
$subscriptionid = "yyyyyyyy-zzzz-aaaa-bbbb-cccccccccccc"
$resourceGroupName = $token + "rags"
$clusterName = $token
$defaultStorageAccountName = $token + "str1"
$defaultStorageContainerName = $token + "cnt1"
$location = "East US 2"
$clusterNodes = 1

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
Write-OutPut "Creating Resource Group"
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

Write-OutPut ""
Write-OutPut "Creating Storage Account and Container"
New-AzureRmStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -StorageAccountName $defaultStorageAccountName `
    -Location $location `
    -Type Standard_LRS
$defaultStorageAccountKey = (Get-AzureRmStorageAccountKey -Name $defaultStorageAccountName -ResourceGroupName $resourceGroupName)[0].Value
$destContext = New-AzureStorageContext -StorageAccountName $defaultStorageAccountName -StorageAccountKey $defaultStorageAccountKey
New-AzureStorageContainer -Name $defaultStorageContainerName -Context $destContext


Write-OutPut ""
Write-OutPut "Creating Cluster Level and SSH Level Credentials"
$secpasswd = ConvertTo-SecureString "Sample1234" -AsPlainText -Force
$clusterCredentials = New-Object System.Management.Automation.PSCredential("userone",$secpasswd)
$sshCredentials = New-Object System.Management.Automation.PSCredential ("usertwo", $secpasswd)

Write-OutPut ""
Write-OutPut "Creating Cluster"
New-AzureRmHDInsightCluster `
    -ClusterName $clusterName `
    -ResourceGroupName $resourceGroupName `
    -HttpCredential $clusterCredentials `
    -Location $location `
    -DefaultStorageAccountName "$defaultStorageAccountName.blob.core.windows.net" `
    -DefaultStorageAccountKey $defaultStorageAccountKey `
    -DefaultStorageContainer $defaultStorageContainerName  `
   -ClusterSizeInNodes $clusterNodes `
    -ClusterType Hadoop `
    -OSType Linux `
    -Version "3.4" `
    -SshCredential $sshCredentials

Write-OutPut ""
Write-OutPut "End of Job"
