# Jenkins Configuration Steps - CI/CD Pipeline Setup

## Step 1: Jenkins Plugin Installation
1. Go to `localhost:8090`
2. Manage Jenkins → Manage Plugins → Available
3. Install these plugins:
   - GitHub Integration Plugin
   - Git Plugin
   - Pipeline Plugin
   - Terraform Plugin
4. Restart Jenkins after installation

## Step 2: AWS Credentials Setup
1. Manage Jenkins → Manage Credentials
2. Click "Global" → "Add Credentials"
3. **First Credential**:
   - Kind: "Secret text"
   - Secret: `[AWS_ACCESS_KEY_HIDDEN_FOR_SECURITY]`
   - ID: `aws-access-key`
4. **Second Credential**:
   - Kind: "Secret text"
   - Secret: `[AWS_SECRET_KEY_HIDDEN_FOR_SECURITY]`
   - ID: `aws-secret-key`

## Step 3: Create Jenkins Pipeline Job
1. New Item → Enter name: `webapp-pipeline`
2. Select "Pipeline" → OK
3. **Pipeline Configuration**:
   - Definition: "Pipeline script from SCM"
   - SCM: "Git"
   - Repository URL: `https://github.com/Deexxtteerr/webapp-cicd-demo.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
4. Save

## Step 4: Configure Build Triggers
1. Pipeline → Configure
2. **Build Triggers Section**:
   - Uncheck "GitHub hook trigger for GITScm polling"
   - Check "Poll SCM"
   - Schedule: `H/2 * * * *` (polls every 2 minutes)
3. Save

## Step 5: Test Manual Build
1. Click "Build Now"
2. Monitor "Console Output"
3. Verify all stages complete successfully:
   - Checkout ✅
   - Build ✅
   - Deploy ✅

## Step 6: Verify Automatic Builds
1. Make code change in repository
2. Push to GitHub
3. Wait 2-3 minutes
4. Jenkins automatically triggers build
5. Check Console Output for successful deployment

## Jenkins Pipeline Stages Configured

### Stage 1: Checkout
- Pulls latest code from GitHub repository
- Uses Git SCM integration

### Stage 2: Build
- Validates web application files
- Lists source directory contents

### Stage 3: Deploy
- Uses AWS credentials from Jenkins
- Runs Terraform commands:
  - `terraform init`
  - `terraform plan`
  - `terraform apply -auto-approve`
- Deploys to AWS S3

## Key Jenkins Configurations Applied

1. **SCM Polling**: `H/2 * * * *` for automatic builds
2. **Credentials Integration**: AWS keys securely stored
3. **Pipeline from SCM**: Jenkinsfile managed in repository
4. **Multi-stage Pipeline**: Checkout → Build → Deploy
5. **Automatic Deployment**: Code changes trigger infrastructure updates

## Jenkins Build Results
- **Build Status**: SUCCESS
- **Deployment Target**: AWS S3 Static Website
- **Automation Level**: Fully automated on code push
- **Build Frequency**: Every 2 minutes (SCM polling)

## Troubleshooting Issues in Jenkins

### Issue 1: Jenkinsfile Not Found
- **Problem**: Jenkins couldn't find Jenkinsfile
- **Solution**: Renamed `jenkinsfile` to `Jenkinsfile` (capital J)

### Issue 2: Terraform Not Found
- **Problem**: `terraform: not found` error
- **Solution**: Installed Terraform binary on Jenkins server

### Issue 3: AWS Credentials Missing
- **Problem**: "No valid credential sources found"
- **Solution**: Added AWS credentials to Jenkins credentials store

### Issue 4: Webhook Failures
- **Problem**: GitHub webhook deliveries failing
- **Solution**: Used SCM polling instead of webhooks

### Issue 5: Website Not Updating
- **Problem**: Code changes not reflected on website
- **Solution**: Added `etag = filemd5()` to Terraform S3 object

## Final Jenkins Configuration Summary

✅ **Plugins Installed**: GitHub, Git, Pipeline, Terraform
✅ **Credentials Configured**: AWS access keys stored securely
✅ **Pipeline Created**: webapp-pipeline with SCM integration
✅ **Build Triggers**: SCM polling every 2 minutes
✅ **Automation Working**: Code push → Auto build → Deploy
✅ **All Issues Resolved**: Complete working CI/CD pipeline