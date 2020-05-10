#!/bin/bash

EKS_CLUSTER_NAME=eks-alb-2048game

echo; echo "Clean up Kubernetes resources if haven't:"

kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-ingress.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-service.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-namespace.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml

echo; echo "'Not found error' is OK to ignore. It means the resource has already been cleaned up."

echo; echo "Delete EKS cluster:"
sleep 30
eksctl delete cluster --name $EKS_CLUSTER_NAME --wait

if [ $? -eq 0 ]; then
    echo; echo "EKS cluster and its resources have been deleted."
else
    echo; echo "Try again by deleting the EKS cluster via CloudFormation."
    sleep 10
    aws cloudformation delete-stack --stack-name eksctl-$EKS_CLUSTER_NAME-cluster
    aws cloudformation wait stack-delete-complete --stack-name eksctl-$EKS_CLUSTER_NAME-cluster
    if [ $? -eq 0 ]; then
        echo; echo "EKS cluster and its resources have been deleted."
    fi
fi