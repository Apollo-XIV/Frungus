#!/bin/bash
set -e # Remove to ignore errors

echo "
    ------------------------------------------------------------------------------------------------------
 ::::::::  :::       :::    :::  :::::::: ::::::::::: :::::::::: :::::::::               :::    ::: :::::::::
:+:    :+: :+:       :+:    :+: :+:    :+:    :+:     :+:        :+:    :+:              :+:    :+: :+:    :+:
+:+        +:+       +:+    +:+ +:+           +:+     +:+        +:+    +:+              +:+    +:+ +:+    +:+
+#+        +#+       +#+    +:+ +#++:++#++    +#+     +#++:++#   +#++:++#:   ++:++#++:   +#+    +:+ +#++:++#+
+#+        +#+       +#+    +#+        +#+    +#+     +#+        +#+    +#+              +#+    +#+ +#+  
#+#    #+# #+#       #+#    #+# #+#    #+#    #+#     #+#        #+#    #+#              #+#    #+# #+#
 ########  ########## ########   ########     ###     ########## ###    ###               ########  ###
                                        AUTOMATIC EKS CLUSTER BUILDER
    -----------------------------------------------------------------------------------------------------
"

# Opens a browser with the lab env.
echo "🧪  Opening Lab Environment..."
xdg-open https://awsacademy.instructure.com/courses/45941/modules/items/3947119

# User needs to enter the AWS Creds provided
echo "📋  Copy and Paste the AWS CLI Credentials:"
creds=$(cat)
echo "$creds" > ~/.aws/credentials

# Setting env. vars. so that Terraform can still read the config
echo "⚙️  Configuring Environment Variables..."
export AWS_ACCESS_KEY_ID=$(aws configure get default.aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get default.aws_secret_access_key)
export AWS_SESSION_TOKEN=$(aws configure get default.aws_session_token)

# Using Terraform to setup the environment, can take a very long time though
echo "⚒️  Running Terraform Apply... please wait (can take > 10mins)"
terraform apply --auto-approve


# Adds the kubeconfig file to the local users computer so they can connect to the cluster
echo "📩  Fetching Config from AWS ..."
aws eks update-kubeconfig --region us-east-1 --name my-cluster




echo "💻  Configuring Dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f ./k8s/dashboard-adminuser.yaml
kubectl apply -f k8s/dashboard-RBAC.yml
token=kubectl -n kubernetes-dashboard create token admin-user
echo "$token" > ./k8s/token
echo "$token" | clip.exe
echo "🔑  Your Token to Log in is $token, and has been copied to your clipboard"



echo "🙌  Opening Dashboard..."
kubectl proxy &
sleep 15
xdg-open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=default
echo "✨  Cluster Configuration Complete!"