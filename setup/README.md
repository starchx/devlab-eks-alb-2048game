## Lab Setup

Requirements:

* AWS CLI
* AWS Console Access

### Step 1

Clone the repository:

```
git clone git@github.com:starchx/devlab-eks-alb-2048game.git
cd devlab-eks-alb-2048game
```

### Step 2

Create Cloud 9 CloudFormation stack

```
cd setup
chmod +x cloud9.sh
./cloud9.sh
```

### Optional Step

If AWS Console login is not the same user as AWS CLI, the Cloud 9 environment created can not be used by AWS Console user until it is shared. To share the environment with AWS Console user:

* Update share-cloud9.sh Line #6 with ARN of Console User:

```
AWS_CONSOLE_USER_ARN=<AWS CONSOLE LOGIN ARN>
```

* Run the script to share the environment:

```
chmod +x share-cloud9.sh
./share-cloud9.sh
```

### Step 3

Navigate to AWS Cloud 9 Console, find the environment and open IDE. The environment title starts *EKSCloud9* and has *DevLab EKS ALB 2048 Game Cloud9 environment* in description. The following steps to be completed on Cloud 9 environment.

### Step 4

Disable Cloud 9 Managed Credentials

* Top menu **AWS Cloud9** and choose **Preferences**
* Left menu **AWS SETTINGS** and choose **Credentials**
* Disable AWS managed temporary credentials:

![Disable Cloud 9 Managed Credentials](https://github.com/starchx/devlab-eks-alb-2048game/tree/master/setup/disable-cloud9-credentials.png?raw=true "Disable Cloud 9 Managed Credentials")

### Step 5

Clone the repository again via Cloud 9 terminal:

```
git clone git@github.com:starchx/devlab-eks-alb-2048game.git
cd devlab-eks-alb-2048game
```

### Step 6

Run bootstrap.sh from Cloud 9 to create EKS cluster

```
cd setup
chmod +x bootstrap.sh
./bootstrap.sh
```

## Lab Reset

Run reset.sh from Cloud 9 to reset for next customer

```
cd setup
chmod +x reset.sh
./reset.sh
```

## Lab Clean Up

Run cleanup.sh from Cloud 9 to create EKS cluster

```
cd setup
chmod +x cleanup.sh
./cleanup.sh
```

Delete the Cloud 9 CloudFormation stack from AWS Console
