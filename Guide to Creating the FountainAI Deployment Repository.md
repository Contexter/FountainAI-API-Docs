# **Guide to Creating the FountainAI Deployment Repository**

## **Introduction**

This document provides a comprehensive, step-by-step guide for creating and structuring the FountainAI deployment repository using GitHub. The guide is designed for users who want to manage and deploy the FountainAI API services using GitHub Actions and AWS infrastructure. The approach outlined ensures a clean and organized structure, avoiding redundant directory names.

## **Prerequisites**

Before you start, ensure you have the following:

1. **GitHub Account:** You need a GitHub account. If you don't have one, sign up at [GitHub](https://github.com/).
2. **Git Installed:** Git must be installed on your local machine. You can download it from [git-scm.com](https://git-scm.com/).
3. **Basic Command Line Knowledge:** Familiarity with command-line operations.
4. **Access to the OpenAPI Markdown Files:** You should have access to the OpenAPI specifications currently stored in Markdown files that need to be converted to `.yml`.

## **Step 1: Create the Repository on GitHub**

### **1.1 Go to GitHub**

- Open your web browser and go to [GitHub](https://github.com/).

### **1.2 Create a New Repository**

1. Click on the "+" icon in the upper right corner of the GitHub interface and select "New repository."
2. **Repository Name:** Enter `fountainai-deployment` (or your desired name).
3. **Description:** Optionally, add a description, such as "Deployment repository for FountainAI API services."
4. **Visibility:** Choose whether the repository should be public or private.
5. **Initialize with a README:** **Do not** check this option. Leave it unchecked to avoid creating an initial file that might cause redundant directory structures.
6. Click on the "Create repository" button.

## **Step 2: Clone the Repository to Your Local Machine**

### **2.1 Navigate to the Parent Directory**

First, navigate to the parent directory where you want the repository to reside:

```bash
cd /path/to/your/desired/parent-directory
```

### **2.2 Clone the Repository**

Clone the repository directly into the desired directory:

```bash
git clone https://github.com/contexter/fountainai-deployment.git fountainai-deployment
```

### **2.3 Navigate into the Cloned Directory**

After cloning, navigate into the cloned directory:

```bash
cd fountainai-deployment
```

This method ensures the repository is cloned directly into the `fountainai-deployment` directory without creating redundant nested directories.

## **Step 3: Set Up the Repository Structure**

### **3.1 Create the Shell Script**

In the terminal, create a new shell script named `setup_repo.sh`:

```bash
nano setup_repo.sh
```

### **3.2 Write the Script**

Copy and paste the following script into the `setup_repo.sh` file:

```bash
#!/bin/bash

# Create the directory structure
mkdir -p .github/workflows
mkdir -p api
mkdir -p infrastructure

# Create empty file stubs
touch .github/workflows/deploy.yml
touch api/central-sequence.yml
touch api/character-management.yml
touch api/core-script-management.yml
touch api/session-and-context-management.yml
touch api/story-factory.yml
touch infrastructure/cloudformation-template.yml

# Output the structure to verify
echo "Repository structure created:"
tree .
```

- Save the file and exit the editor (`CTRL + X`, then `Y`, and press `Enter`).

### **3.3 Make the Script Executable**

Run the following command to make the script executable:

```bash
chmod +x setup_repo.sh
```

### **3.4 Run the Script**

Execute the script to create the directory structure and file stubs:

```bash
./setup_repo.sh
```

### **3.5 Verify the Structure**

After running the script, you should see an output showing the created directory structure:

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml
├── api/
│   ├── central-sequence.yml
│   ├── character-management.yml
│   ├── core-script-management.yml
│   ├── session-and-context-management.yml
│   └── story-factory.yml
└── infrastructure/
    └── cloudformation-template.yml
```

## **Step 4: Populate the Initial Content**

### **4.1 Convert and Populate OpenAPI YAML Files**

The provided Markdown files contain OpenAPI specifications that need to be converted to `.yml` format and placed in the corresponding files. Here's what you need to do:

1. **Open each `.yml` file** in the `api` directory using a text editor (e.g., `nano`):
   ```bash
   nano api/central-sequence.yml
   ```

2. **Copy the OpenAPI content** from the corresponding Markdown file and paste it into the `.yml` file, ensuring that the syntax is correct.

   Repeat this process for each API:

   - `api/central-sequence.yml`
   - `api/character-management.yml`
   - `api/core-script-management.yml`
   - `api/session-and-context-management.yml`
   - `api/story-factory.yml`

   These `.yml` files will contain the OpenAPI specifications that define the API endpoints, methods, and data models for each service.

### **4.2 Populate `deploy.yml` (GitHub Actions Workflow)**

#### **Purpose**

This file defines the CI/CD pipeline that will automate the deployment of your APIs and infrastructure using GitHub Actions and AWS CloudFormation.

#### **Initial Content**

1. Open `deploy.yml` for editing:

   ```bash
   nano .github/workflows/deploy.yml
   ```

2. Paste the following content into `deploy.yml`:

   ```yaml
   name: FountainAI API Deployment

   on:
     push:
       branches:
         - main

   jobs:
     deploy:
       name: Deploy FountainAI APIs
       runs-on: ubuntu-latest

       steps:
         - name: Checkout Code
           uses: actions/checkout@v3

         - name: Set up AWS CLI
           uses: aws-actions/configure-aws-credentials@v2
           with:
             aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
             aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
             aws-region: us-east-1

         - name: Upload OpenAPI Specs to S3
           run: |
             aws s3 sync api/ s3://fountainai-api-spec-${{ secrets.AWS_REGION }}/

         - name: Validate CloudFormation Template
           run: |
             aws cloudformation validate-template --template-body file://infrastructure/cloudformation-template.yml

         - name: Deploy CloudFormation Stack
           run: |
             aws cloudformation deploy \
               --template-file infrastructure/cloudformation-template.yml \
               --stack-name fountainai-stack \
               --capabilities CAPABILITY_NAMED_IAM

         - name: Notify Deployment Success
           if: success()
           run: echo "Deployment completed successfully!"

         - name: Notify Deployment Failure
           if: failure()
           run: echo "Deployment failed!"
   ```

### **4.3 Populate `cloudformation-template.yml` (AWS Infrastructure Configuration)**

#### **Purpose**

This file defines the AWS infrastructure (like API Gateway, S3 buckets, etc.) required to host the FountainAI services.

#### **Initial Content**

1. Open `cloudformation-template.yml` for editing:

   ```bash
   nano infrastructure/cloudformation-template.yml
   ```

2. Paste the following comprehensive CloudFormation template:

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Description: FountainAI API Infrastructure

   Resources:
     ApiSpecBucket:
       Type: AWS::S3::Bucket
       Properties:
         BucketName: !Sub fountainai-api-spec-${AWS::Region}

     CentralSequenceApiGateway:
       Type: AWS::ApiGateway::RestApi
       Properties:
         Name: Central Sequence API
         Body:
           Fn::Transform:
             Name: AWS::Include
             Parameters:
               Location: !Sub s3://${ApiSpecBucket}/central-sequence.yml

     CharacterManagementApiGateway:
       Type: AWS::ApiGateway::RestApi
       Properties:
         Name: Character Management API
         Body:
           Fn::Transform:
             Name: AWS::Include
             Parameters:
               Location: !Sub s3://${ApiSpecBucket}/character-management.yml

     CoreScriptManagementApiGateway:
       Type: AWS::ApiGateway::RestApi
       Properties:
         Name: Core Script Management API
         Body:
           Fn::Transform:
             Name: AWS::Include
             Parameters:
               Location: !Sub s3://${ApiSpecBucket}/core-script-management.yml

     SessionAndContextManagementApiGateway:
       Type: AWS::ApiGateway::RestApi
       Properties:
         Name: Session and Context Management API
         Body:
           Fn::Transform:
             Name: AWS::Include
             Parameters:
               Location: !Sub s3://${ApiSpecBucket}/session-and-context-management.yml

     StoryFactoryApiGateway:
       Type: AWS::ApiGateway::RestApi
       Properties:
         Name: Story Factory API
         Body:
           Fn::Transform:
             Name: AWS::Include
             Parameters:
               Location: !Sub s3://${ApiSpecBucket}/story-factory.yml

   Outputs:
     ApiSpecBucketName:
       Value: !Ref ApiSpecBucket
       Export:
         Name: ApiSpecBucketName
   ```

## **Step 5: Commit and Push the Changes to GitHub**

Now that the structure is set up and initial content is added, you'll commit these changes to your GitHub repository.

### **5.1 Stage the Files for Commit**

Run the following command to stage all the files and directories for commit:

```bash
git add .
```

### **5.2 Commit the Changes**

Commit the changes with a descriptive message:

```bash
git commit -m "Initial repository structure and file stubs with full content"
```

### **5.3 Push the Changes to GitHub**

Push the changes to the `main` branch on GitHub:

```bash
git push origin main
```

### **5.4 Verify on GitHub**

Go back to your GitHub repository in the browser and refresh the page. You should see the entire structure and the initial content you added.

## **Conclusion**

You have now successfully set up the FountainAI deployment repository with a clean and organized structure. You’ve also populated the file stubs with the complete content, including the conversion of OpenAPI specifications from Markdown to YAML and the inclusion of a comprehensive CloudFormation template. This setup avoids redundant directory names and ensures a clear path for further development and deployment processes.

By following this guide, even beginners can confidently set up a structured deployment repository on GitHub, ensuring a strong foundation for managing and deploying FountainAI API services.