# Auto-Remover


# Deploying locally

You can use the below command to deploy locally.

```
cd .\bicep-deploy\

az login

az deployment mg what-if --management-group-id yourManagementGroupId --name rollout -f .\main.bicep -l westeurope

az deployment mg create --management-group-id yourManagementGroupId --name rollout -f .\main.bicep -l westeurope
```