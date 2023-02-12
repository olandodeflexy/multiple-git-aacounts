#!/bin/sh
#Log Stdout to log.out and Stderr to Error.out
exec 1>>./log.out 2>>error.out
#Print the current Date and Time
today=$(date +%d-%m-%y)
time=$(date +%T)
echo "Starting the VM's now $today - $time"
#Save credentials for Azure Service Principal
SUBSCRIPTION_ID=$1
SERVICE_PRINCIPAL_ID=$2
SERVICE_PRINCIPAL_SECRET=$3
TENANT_ID=$4
#Login to Azure --> (Need help here)
az login  --service-principal  --username "${SERVICE_PRINCIPAL_ID}"  --password "${SERVICE_PRINCIPAL_SECRET}"  --tenant "${TENANT_ID}"
#Set Subscription ID
#az account set -s "${SUBSCRIPTION_ID}"
#Start the VM Scale Set.
az vmss start --resource-group {resource-group} --name {name}

