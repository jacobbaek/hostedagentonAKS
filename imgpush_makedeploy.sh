#!/bin/bash

IMGNAME="devopsagent4aks"
TAGNAME="v1"
ACRNAME="jacob4acr"

DEPLOY_NAME="devopsagent-deploy"
NS_NAME="default"

buildandpush() {
  ## image build using docker command
  docker build . -t $ACRNAME.azurecr.io/$IMGNAME:$TAGNAME
  docker push $ACRNAME.azurecr.io/$IMGNAME:$TAGNAME
}

createdeployfile() {
  echo "## references : https://aka.ms/vstsagentroles"
  echo -n "## write organization name: "
  read 
  AZP_URL="https://dev.azure.com/"$REPLY
  
  echo -n "## write agentpool name (def: Default): "
  read 
  AZP_POOL=$REPLY
  
  echo "## reference : https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows"
  echo -n "## write token: "
  read 
  AZP_TOKEN=$REPLY
  
  cat << EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "${DEPLOY_NAME}" # name of Deployment
  namespace: "${NS_NAME}" # namespace name
  labels:
    app: "devopsagent"
spec:
  selector:
    matchLabels:
      app: "devopsagent"
  template:
    metadata:
      labels:
        app: "devopsagent"
    spec:
      nodeSelector:
        kubernetes.io/os: linux
      containers:
        - name: "devopsagent" # container name
          image: "${ACRNAME}.azurecr.io/${IMGNAME}:${TAGNAME}"
          imagePullPolicy: Always
          env:
            - name: AGENT_TOOLSDIRECTORY
              value: "/tools"
            - name: AZP_URL
              value: "${AZP_URL}"
            - name: AZP_POOL
              value: "${AZP_POOL}"
            - name: AZP_TOKEN # values from agent pool creation
              value: "${AZP_TOKEN}"
          resources:
            requests:
              cpu: 500m
EOF
}

buildandpush
createdeployfile
