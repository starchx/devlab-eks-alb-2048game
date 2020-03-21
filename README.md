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

Open the ALB Ingress Controller deployment manifest for editing with the following command

```
kubectl edit deployment.apps/alb-ingress-controller -n kube-system
```

## Step 4:

Add a line for the cluster name after the --ingress-class=alb line.

```
spec:
  containers:
  - args:
    - --ingress-class=alb
    - --cluster-name=eks-alb-2048game
```

## Step 5:

Confirm that the ALB Ingress Controller is running with the following command. 

```
kubectl get pods -n kube-system
```

Expected output:

```
NAME                                      READY   STATUS    RESTARTS   AGE
alb-ingress-controller-55b5bbcb5b-bc8q9   1/1     Running   0          56s
```

## Step 6:

Deploy the game 2048 as a sample application to verify that the ALB Ingress Controller creates an Application Load Balancer as a result of the Ingress object.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-service.yaml
```

## Step 7:

Deploy ALB Ingress resource to expose 2048 Game via AWS Application Load Balancer.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/2048/2048-ingress.yaml
```

## Step 8:

After a few minutes, verify that the Ingress resource was created with the following command. 

```
kubectl get ingress/2048-ingress -n 2048-game
```

Expected output:

```
NAME           HOSTS   ADDRESS                                                                 PORTS      AGE
2048-ingress   *       example-2048game-2048ingr-6fa0-352729433.region-code.elb.amazonaws.com   80      24h
```

Run the following command to view the Ingress controller log to debug:

```
kubectl logs -n kube-system   deployment.apps/alb-ingress-controller
```

## Step 9:

Open a browser and navigate to the ADDRESS URL from the previous command `kubectl get ingress` output to see the sample application.

## Step 10:

Navigate to AWS Console - EC2 - Applicatoin Load Balancer to see what Ingress controller has created.

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
