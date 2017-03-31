Converting ARM Templates to Automation Scripts
==============================================

Let's take the example of creating a HDinsight/Hadoop/Linux cluster. Replace the TODOs with the appropriate values.

Step 1
-------

From the portal, just before you hit create (when the cluster deployment starts) on the Summary blade, there is an option to "Download template and parameters".

Click on the option "Download template and parameters" and hit "Download".

This will save a bunch of scripts (including bash, PowerShell) and the `templates.json` and `parameters.json` file.

You can run the PowerShell from the command line, but it'll need to be massaged a bit to convert it as a runbook that can be automated based on a schedule.

Step 2
-------

Basically, this involves moving the templates into another PowerShell script - [NewHDiClusterTemplate.ps1](NewHDiClusterTemplate.ps1) that will return a TemplatePath that we will use in the `ResourceGroup` creation command (belo)

Step 3
-------

We will flatten the parameters and do the RunAS which is required to login to Azure.

Sample values are in the file [NewHDiCluster.ps1](NewHDiCluster.ps1) which involved massaging of the Powershell script generated from the portal.

Step 4
-------

The final step involves importing both these runbooks and running the script  [NewHDiCluster.ps1](NewHDiCluster.ps1) which incorporates the template path from the other script and calls the ResourceGroupDeployment as the final step.
