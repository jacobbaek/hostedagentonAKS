# Intro
make a hosted devops agent on AKS.

# Prerequites
* docker cli
* azure container registry
* azure devops project

# How to run
First, run below command. 
```
$ bash imgpush_makedeploy.sh
## write organization name: devopsprojectname
## write agentpool name (def: Default): defpool
## reference
## https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows
## write token: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
After run this, deployment.yaml file will be on your directory.

# References
https://aka.ms/vstsagentroles
