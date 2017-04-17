#!/bin/bash
# To be run on the Head Node of the cluster
# Monitors jobs contnually and does the autoscaling
upscale="false"
while [ 1 ]
do
  jobcount=$(yarn application -list | wc -l)
# echo "Looping and job count = " $jobcount
  if [ "$upscale" = "true" ] && [ $jobcount -lt 3 ]
  then
    echo downscale
    upscale="false"
    curl --connect-timeout 900 -L https://HDIAutoScale.azurewebsites.net/api/DownScaleCluster?code=<DownScaleCluster-function-Apikey>
  fi
  if [ "$upscale" = "false" ] && [ $jobcount -gt 7 ]
  then
    echo upscale
    upscale="true"
    curl --connect-timeout 900 https://HDIAutoScale.azurewebsites.net/api/UpScaleCluster?code=<UpScaleCluster-function-Apikey>
  fi
# sleep for 10 secs and check the jobs again
sleep 10
done
