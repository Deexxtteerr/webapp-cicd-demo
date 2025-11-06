# Jenkins CI/CD Pipeline with GitHub Integration

## Overview
Complete CI/CD pipeline that automatically builds and deploys a web application to AWS S3 using Jenkins, GitHub, and Terraform.

**Live Website**: http://webapp-demo-bucket-nilesh.s3-website-us-west-1.amazonaws.com/

## Architecture Flow
```
GitHub Push → SCM Polling → Jenkins → Terraform → AWS S3 → Live Website
```

## Project Structure
```
webapp-project/
├── src/
│   └── index.html          # Web application
├── terraform/
│   ├── main.tf            # AWS infrastructure
│   ├── variables.tf       # Configuration variables
│   └── outputs.tf         # Deployment outputs
├── Jenkinsfile            # Pipeline configuration
└── README.md             # This file
```

## Prerequisites
- Jenkins running on port 8090
- AWS Account with programmatic access
- GitHub repository
- Terraform installed on Jenkins server

## Step-by-Step Implementation

### 1. Jenkins Setup
- Install required plugins:
  - GitHub Integration Plugin
  - Git Plugin
  - Pipeline Plugin
  - Terraform Plugin

### 2. AWS Credentials Configuration
- Added AWS Access Key and Secret Key to Jenkins credentials
- Credential IDs: `aws-access-key`, `aws-secret-key`

### 3. Project Structure Creation
- Created web application in `src/index.html`
- Terraform infrastructure code in `terraform/` directory
- Jenkins pipeline defined in `Jenkinsfile`

### 4. Terraform Infrastructure
- S3 bucket for static website hosting
- Public access configuration
- Bucket policy for public read access
- Website configuration with index.html

### 5. Jenkins Pipeline Configuration
- Pipeline script from SCM
- Three stages: Checkout, Build, Deploy
- AWS credentials integration
- Terraform automation

## Issues Encountered & Solutions

### Issue 1: Jenkinsfile Not Found
**Problem**: Jenkins couldn't find Jenkinsfile from Git repository
**Cause**: File was named `jenkinsfile` (lowercase)
**Solution**: Renamed to `Jenkinsfile` (capital J)

### Issue 2: Terraform Not Found
**Problem**: `terraform: not found` error in Jenkins
**Cause**: Terraform binary not installed on Jenkins server
**Solution**: 
```bash
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### Issue 3: AWS Credentials Missing
**Problem**: "No valid credential sources found"
**Cause**: Jenkins didn't have AWS access credentials
**Solution**: Added AWS credentials to Jenkins and updated Jenkinsfile with `withCredentials` block

### Issue 4: S3 Bucket Name Validation
**Problem**: "only lowercase alphanumeric characters and hyphens allowed"
**Cause**: Bucket name contained uppercase letters
**Solution**: Changed bucket name to `webapp-demo-bucket-nilesh`

### Issue 5: S3 Website 403 Forbidden
**Problem**: Website returned 403 Forbidden error
**Cause**: S3 bucket not configured for public access
**Solution**: Added public access block configuration and bucket policy

### Issue 6: Resource Creation Order
**Problem**: Bucket policy creation failed due to public access blocks
**Cause**: Resources created in wrong order
**Solution**: Added `depends_on` attributes to ensure proper resource creation sequence

### Issue 7: GitHub Webhook Failures
**Problem**: Webhook deliveries failing with network errors
**Cause**: Jenkins not accessible from external network (ISP/firewall restrictions)
**Solution**: Implemented SCM polling instead of webhooks
- Configuration: `H/2 * * * *` (polls every 2 minutes)

### Issue 8: Website Not Updating
**Problem**: Code changes not reflected on website after deployment
**Cause**: Terraform not detecting file content changes
**Solution**: Added `etag = filemd5("../src/index.html")` to force S3 object updates

## Final Working Configuration

### Jenkinsfile
```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Deexxtteerr/webapp-cicd-demo.git'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building web application...'
                sh 'ls -la src/'
            }
        }
        
        stage('Deploy') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('terraform') {
                        sh 'export AWS_DEFAULT_REGION=us-west-1'
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
```

### Jenkins Build Triggers
- **SCM Polling**: `H/2 * * * *` (checks GitHub every 2 minutes)
- **Alternative to webhooks**: Solves network accessibility issues

## Key Learnings

1. **File Naming**: Jenkins is case-sensitive for `Jenkinsfile`
2. **Dependencies**: Tools like Terraform must be installed separately from plugins
3. **AWS Permissions**: S3 public access requires both bucket policy and access block configuration
4. **Resource Dependencies**: Terraform resources need proper ordering with `depends_on`
5. **Network Limitations**: Home networks often block incoming connections, SCM polling is a reliable alternative
6. **File Change Detection**: Use file hashing (`etag`) to ensure Terraform detects content changes

## Testing the Pipeline

1. **Make a code change**:
   ```bash
   vim src/index.html
   # Update version number or content
   ```

2. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Update website content"
   git push origin main
   ```

3. **Wait 2-3 minutes** for SCM polling to detect changes

4. **Verify deployment**:
   - Check Jenkins for automatic build
   - Visit website URL to see updates

## Resources Created

- **S3 Bucket**: `webapp-demo-bucket-nilesh`
- **S3 Website Configuration**: Static website hosting
- **S3 Bucket Policy**: Public read access
- **S3 Object**: index.html file

## Success Metrics

✅ **Automated CI/CD Pipeline**: Code changes trigger automatic builds
✅ **Infrastructure as Code**: Terraform manages AWS resources
✅ **Live Website Deployment**: Changes reflected on public website
✅ **Error Handling**: All encountered issues resolved
✅ **Documentation**: Complete troubleshooting guide

## Conclusion

Successfully implemented a complete CI/CD pipeline demonstrating:
- Source code management with GitHub
- Continuous integration with Jenkins
- Infrastructure automation with Terraform
- Cloud deployment to AWS S3
- Automated testing and deployment workflow

The pipeline automatically deploys every code change to a live website, achieving the core DevOps objective of rapid, reliable software delivery.