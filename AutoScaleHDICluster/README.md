Autoscaling HDInsight Cluster
=================

The steps are as below. Test the different steps individually since we're hooking up a number of scripts here.

* Create a Service Principal to be used in the PowerShell scripts
* Create Azure functions with Webhook and PowerShell scripts which upscale and downscale the cluster
* Create a script on the Master node that monitors the load and scales the cluster appropriately
* Test it

Create a Service Principal to be used in the PowerShell scripts
---

Use the following command

```
az ad sp create-for-rbac 
```

This should output something like

```
{

  "appId": "<sp-app-id>",

  "displayName": "azure-cli-2017-04-08-16-54-05",

  "name": "http://azure-cli-2017-04-08-16-54-05",

  "password": "<sp-password>",

  "tenant": "<sp-tenant>"


}
```

Create Azure functions with Webhook and PowerShell scripts which upscale and downscale the cluster
---

The scripts are included and the upscale script would include something as below.

```
$azureAccountName ="<sp-app-id-from-service-principal>"
$azurePassword = ConvertTo-SecureString "<sp-password-from-service-principal>" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName, $azurePassword)

Add-AzureRmAccount -Credential $psCred -TenantId <sp-tenant-id-from-service-principal> -ServicePrincipal

Set-AzureRmHDInsightClusterSize -ClusterName "<ClusterName>" -TargetInstanceCount 3
```

Create a script on the Master node that monitors the load and scales the cluster appropriately
---

You can test the Azure function as below.

```
curl --connect-timeout 900 https://<yourapp>.azurewebsites.net/api/<function>?code=<ApiKey>
```

something like

```
https://HDIAutoScale.azurewebsites.net/api/UpScaleCluster?code=<ApiKey>
```
Where `HDIAutoScale` is the function app and `UpScaleCluster` and `DownScaleCluster` are PowerShell functions triggered by a webhook.

Get the names of `yourapp`, `function` and `ApiKey` from the Azure portal and plug them into a script which upscales when there are 5 or more jobs running and downscales when there is no jobs running.

**Make sure this script runs when the cluster is created and make sure it's continually monitoring jobs on the cluster.**

Test it
---

You can create jobs on the cluster by running any of the samples to test the upscale and downscale of the cluster.

```
yarn jar /usr/hdp/2.6.0.2-76/hadoop-mapreduce/hadoop-mapreduce-examples-2.7.3.2.6.0.2-76.jar pi 16 1000 &
```
