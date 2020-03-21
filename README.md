## How Kubernetes Ingress works with [aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)

The following diagram details the AWS components that the aws-alb-ingress-controller creates whenever an Ingress resource is defined by the user. The Ingress resource routes ingress traffic from the Application Load Balancer(ALB) to the Kubernetes cluster.

![How Kubernetes Ingress works](https://d2908q01vomqb2.cloudfront.net/ca3512f4dfa95a03169c5a670a4c91a19b3077b4/2018/11/20/image1-1.png "How Kubernetes Ingress works")

## Setup

If you are trying this lab from AWS Submit, the lab would have been set up for you. Please proceed to [Connect to Cloud 9](#connect-to-cloud9). Otherwise, please follow [setup guide](setup/README.md) in setup folder.

## <a name="connect-to-cloud9"></a> Connect to Cloud 9

* Open [AWS Cloud 9 Console](https://console.aws.amazon.com/cloud9/home)
* Find the environment that has *EKSCloud9* as prefix in title and *DevLab EKS ALB 2048 Game Cloud9 environment* in description.
* Click *Open IDE* button.
* Complete the following steps in Cloud 9 to finish the lab.

## Step 0

In Cloud 9 environment, maximize the Terminal, and load the profile with this command:

```
source ~/.bash_profile
``` 

## Step 1

Create a Kubernetes service account named alb-ingress-controller in the kube-system namespace, a cluster role, and a cluster role binding for the ALB Ingress Controller to use with the following command.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
```

## Step 2: 

Deploy the ALB Ingress Controller with the following command

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml
```

## Step 3:

ALB Ingress Controller needs to know the EKS cluster name. Open the ALB Ingress Controller deployment manifest for editing with the following command

```
kubectl edit deployment.apps/alb-ingress-controller -n kube-system
```

Add a line for the cluster name after the --ingress-class=alb line.

```
spec:
  containers:
  - args:
    - --ingress-class=alb
    - --cluster-name=eks-alb-2048game
```

Save the file and exit will trigger ALB Ingress Controller pod to redeploy.

## Step 4:

Confirm that the ALB Ingress Controller is running with the following command. 

```
kubectl get pods -n kube-system
```

Expected output:

```
NAME                                      READY   STATUS    RESTARTS   AGE
alb-ingress-controller-55b5bbcb5b-bc8q9   1/1     Running   0          56s
```

## Step 5:

Create a namespace for 2048 game.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-namespace.yaml
```

Verify the namespace has been created:

```
kubectl get ns
```

Expected output:

```
NAME              STATUS   AGE
2048-game         Active   42h
default           Active   42h
kube-node-lease   Active   42h
kube-public       Active   42h
kube-system       Active   42h
```

## Step 6:

Create a deployment to run 2048 game application pods.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-deployment.yaml
```

Verify the deployment has been created:

```
kubectl get deployment -n 2048-game
```

Expected output:

```
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
2048-deployment   5/5     5            5           42h
```

## Step 7:

Create a service to abstract 2048 game application pods.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-service.yaml
```

Verify the service has been created:

```
kubectl get service -n 2048-game
```

Expected output:

```
NAME           TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service-2048   NodePort   10.100.49.101   <none>        80:32667/TCP   42h
```

## Step 8:

Deploy ALB Ingress resource to expose 2048 Game via AWS Application Load Balancer.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-ingress.yaml
```

After a few minutes, verify that the Ingress resource was created with the following command. 

```
kubectl get ingress/2048-ingress -n 2048-game
```

Expected output:

```
NAME           HOSTS   ADDRESS                                                                     PORTS   AGE
2048-ingress   *       7dfe79d3-2048game-2048ingr-6fa0-35333457.ap-southeast-2.elb.amazonaws.com   80      41h
```

To debug, run the following command to view the Ingress controller log:

```
kubectl logs -n kube-system   deployment.apps/alb-ingress-controller
```

## Step 9:

Navigate to [AWS Console Load Balancer page](https://console.aws.amazon.com/ec2/v2/home#LoadBalancers:sort=loadBalancerName) to see the Load Balancer created by ALB Ingress Controller according to the Ingress resource.

## Step 10:

Open a browser and navigate to the ALB endpoint (shown in ADDRESS field from the previous command `kubectl get ingress/2048-ingress -n 2048-game` output or from AWS Load Balancer Console) to see the 2048 game application.

## Step 11:

When you finish experimenting with the lab, delete it with the following commands.

```
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-ingress.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-service.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-deployment.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-namespace.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
```

## Reference

- [Kubernetes Ingress with AWS ALB Ingress Controller](https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/)
- [Github repository for AWS ALB Ingress Controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)
