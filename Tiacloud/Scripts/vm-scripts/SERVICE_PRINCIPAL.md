# Create Custom Role && Service Principal Assignment  


## Create Custom Role

1. Create a new file vm_admin.json
```sh
touch vm_admin.json 
```

 2. Copy the subscription ID using the az account list command
```sh
az account list --output table
```

 3. Edit new file with Vim Text Editor 
```sh
vim vm_admin.json
```

 4. Add the following script the vm_admin.json file
```sh
Replace subscription ID in assignableScopes 

 {
        "Name": "VM Admin Login",
        "description": "View Virtual Machines in the portal and login as administrator",
        "assignableScopes": [
             "/subscriptions/00000000-0000-0000-0000-000000000000"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.Network/publicIPAddresses/read",
                    "Microsoft.Network/virtualNetworks/read",
                    "Microsoft.Network/loadBalancers/read",
                    "Microsoft.Network/networkInterfaces/read",
                    "Microsoft.Compute/virtualMachines/*/read",
                    "Microsoft.HybridCompute/machines/*/read",
                    "Microsoft.HybridConnectivity/endpoints/listCredentials/action"
                ],
                "notActions": [],
                "dataActions": [
                    "Microsoft.Compute/virtualMachines/login/action",
                    "Microsoft.Compute/virtualMachines/loginAsAdmin/action",
                    "Microsoft.HybridCompute/machines/login/action",
                    "Microsoft.HybridCompute/machines/loginAsAdmin/action"
                ],
                "notDataActions": []
            }
        ]
    }
"
```

5. To list all your custom roles, use the az role definition list command with the --custom-role-only parameter.
 ```sh
 az role definition list --custom-role-only true
```
## Create Service Principal && Assign Custom Role

6. To create service principal name testsp 
```sh
az ad sp create-for-rbac -n "testsp"
```

7. To display service principal name testsp
```sh
az ad sp list --display-name "testsp"
```

8. To display role name VM Admin Login
```sh
az role definition list --name "VM Admin Login""
```

9. Assign role using az role assignment create command
```sh
az role assignment create --assignee "00000000-0000-0000-0000-000000000000" \
--role "VM Admin Login" \
--subscription "00000000-0000-0000-0000-000000000000"
```

10. Reference :

- [Create an Azure custom role using Azure CLI](https://docs.microsoft.com/en-us/azure/role-based-access-control/tutorial-custom-role-cli)
- [Create an Azure service principal with the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli)
- [Assign Azure roles using Azure CLI](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-cli)


