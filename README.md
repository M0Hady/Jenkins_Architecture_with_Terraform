# Jenkins_Architecture_with_Terraform
This Terraform project provisions a Jenkins server and agent on AWS. The setup includes a VPC, subnet, security group, internet gateway, and necessary route table configurations.

## Prerequisites
Before deploying, ensure you have:
- Terraform installed
- An AWS account
- Configured AWS authentication (via IAM user, AWS CLI profile, or environment variables)

## Deployment Steps

### 1. Authenticate with AWS
Terraform requires authentication with AWS. Choose your preferred method:
- **AWS CLI Profile**: `aws configure`
- **Environment Variables**:
  ```sh
  export AWS_ACCESS_KEY_ID="your-access-key"
  export AWS_SECRET_ACCESS_KEY="your-secret-key"
  ```

### 2. Deploy the Jenkins Server
a. set vpc.tf / jenkins_server.tf files then run :
```sh
terraform init
terraform plan
terraform apply -auto-approve
```
b. URL Will be shown for you to Access Jenkins in your browser and complete the setup wizard.
c. Once the Jenkins server is up and running, manually configure the agent before deployment:
    - for jenkins_agent.tf we will have variable for agent name / agent secret
d. set jenkins agent home to be >> /home/jenkins ( you can change it and make it variable also).


### 3. Prevent Accidental Destruction of Jenkins Server
use Terraform's `prevent_destroy` lifecycle rule in `jenkins_server.tf`:
```hcl
lifecycle {
        prevent_destroy = true
        ignore_changes  = all  # Ignore all changes
    }
```

### 4. Deploy Jenkins Agent
With the Jenkins server configured and protected, deploy the agent:
```sh
terraform apply -auto-approve -var="agent_secret=your-agent-secret" -var="agent_name=your-agent-name"
```

## Outputs
- **Jenkins URL**: `http://<public-ip>:8080`


## Cleanup
To remove the entire infrastructure (excluding the protected server):
```sh
terraform destroy -auto-approve
```
Ensure you remove the `prevent_destroy` lifecycle rule before attempting to destroy the server manually.

---

This setup ensures a structured and safe deployment of a Jenkins master-agent architecture using Terraform.

