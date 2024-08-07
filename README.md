## FountainAI OpenAPI Documentation Update Pipeline

> Continuous Contextual Consistency **(C3)** in Generative Language Models: A Case Study with **FountainAI**

#### Abstract

This paper presents Continuous Contextual Consistency (C3), a framework to enhance generative language models by providing persistent, contextually relevant memory. We demonstrate its implementation in FountainAI, a platform for managing storytelling elements. By integrating subdomain-specific APIs, FountainAI achieves scalable and efficient context management, improving long-term interaction coherence and user experience.

### Table of Contents

1. [Overview](#overview)
2. [Continuous Contextual Consistency (C3) in FountainAI](#continuous-contextual-consistency-c3-in-fountainai)
   - [Abstract](#abstract)
   - [Introduction](#introduction)
   - [Background](#background)
   - [Implementation of C3 in FountainAI](#implementation-of-c3-in-fountainai)
   - [API Documentation](#api-documentation)
   - [Conclusion](#conclusion)
3. [Setup Instructions](#setup-instructions)
   - [Prerequisites](#prerequisites)
   - [Step 1: Prepare the Repository](#step-1-prepare-the-repository)
   - [Step 2: Run the Setup Script](#step-2-run-the-setup-script)
4. [Using the Pipeline](#using-the-pipeline)
   - [Step 1: Create the `api-insert.yaml` File](#step-1-create-the-api-insert-yaml-file)
   - [Step 2: Commit and Push the `api-insert.yaml` File](#step-2-commit-and-push-the-api-insert-yaml-file)
   - [Step 3: Monitor the GitHub Actions Workflow](#step-3-monitor-the-github-actions-workflow)
   - [Step 4: Verify the Documentation](#step-4-verify-the-documentation)
5. [Reverting Changes](#reverting-changes)
6. [Creating the `api-insert.yaml` File Using GPT](#creating-the-api-insert-yaml-file-using-gpt)
   - [Prompting the GPT Model](#prompting-the-gpt-model)
   - [Crafting Prompts for Other Routes](#crafting-prompts-for-other-routes)
   - [Using the `target-file` Mechanism](#using-the-target-file-mechanism)
   - [Saving and Using the File](#saving-and-using-the-file)
7. [Summary](#summary)

### Overview

This document provides a comprehensive guide for setting up and using the FountainAI OpenAPI documentation update pipeline. The pipeline automates the process of updating OpenAPI documentation by adding new routes to specific OpenAPI YAML files, validating them, generating HTML documentation, and committing the changes to the repository.

### Continuous Contextual Consistency (C3) in FountainAI

#### Abstract

This section presents Continuous Contextual Consistency (C3), a framework designed to enhance generative language models by providing persistent, contextually relevant memory. We demonstrate its implementation in FountainAI, a platform for managing storytelling elements. By integrating subdomain-specific APIs, FountainAI achieves scalable and efficient context management, improving long-term interaction coherence and user experience.

#### Introduction

Generative language models like GPT-4 have advanced natural language processing, enabling sophisticated conversational agents. However, maintaining context over extended interactions remains challenging. Continuous Contextual Consistency (C3) aims to embed long-term memory into AI systems, ensuring coherent and contextually relevant interactions.

FountainAI, a platform for managing storytelling elements such as characters, actions, and dialogues, is ideal for demonstrating C3. This section details the development and integration of C3 within FountainAI, focusing on user interactions represented as characters in a narrative.

#### Background

Generative language models generate contextually relevant responses within a single interaction but struggle with continuity over multiple sessions. The lack of persistent memory results in disjointed and repetitive interactions, undermining user experience.

C3 addresses this by introducing a structured memory system that tracks user interactions, preferences, and context across sessions. FountainAI's storytelling management system, with its need for character and narrative continuity, provides an excellent framework for implementing and testing C3.

#### Implementation of C3 in FountainAI

The implementation of C3 within FountainAI involves several key components:

1. **Subdomain-Specific APIs**: The system is divided into several main APIs, each responsible for distinct functionalities:
   - Core Story Management API
   - Character Management API
   - Session and Context Management API
   - Central Sequence Service API
   - Story Factory API

2. **Persistent Memory and Context Tracking**: Each user interaction is modeled as a character within FountainAI, allowing for detailed tracking of preferences, history, and current context.

3. **API Integration and Context Management**: The APIs are designed to manage specific aspects of the system while sharing a common goal of maintaining context. Redis caching and RedisAI middleware support efficient data retrieval and recommendation.

#### API Documentation

- [Docs.Fountain.Coach](http://docs.fountain.coach)

#### Conclusion

By implementing C3 through structured, subdomain-specific APIs, FountainAI effectively manages long-term context and memory, enhancing user interactions and maintaining narrative coherence. This practical approach demonstrates how AI systems can be more advanced and user-friendly by integrating long-term memory.

### Setup Instructions

#### Prerequisites

Ensure the following tools are installed on your machine:

- Git: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- Node.js and npm: [Install Node.js and npm](https://nodejs.org/)
- Homebrew (for macOS): [Install Homebrew](https://brew.sh/)

#### Step 1: Prepare the Repository

1. **Clone the Repository**

   Clone the FountainAI-API-Docs repository to your local machine:

   ```bash
   git clone https://github.com/Contexter/FountainAI-API-Docs.git
   cd FountainAI-API-Docs
   ```

2. **Create the `update-api` Branch**

   Create and push the `update-api` branch if it doesn't already exist:

   ```bash
   git checkout -b update-api
   git push origin update-api
   ```

#### Step 2: Run the Setup Script

Save the following setup script to a file (e.g., `setup_pipeline.sh`), make it executable, and run it:

```bash
#!/bin/bash

# Exit on any error
set -e

# Repository and branch configuration
REPO_URL="https://github.com/Contexter/FountainAI-API-Docs.git"
BRANCH_NAME="update-api"
SCRIPT_NAME="setup_pipeline.sh"
REPO_NAME="FountainAI-API-Docs"

# Ensure required tools are installed
check_dependencies() {
  if ! command -v git &> /dev/null; then
    echo "Git is required. Please install Git."
    exit 1
  fi
  if ! command -v node &> /dev/null; then
    echo "Node.js is required. Please install Node.js."
    exit 1
  fi
  if ! command -v npm &> /dev/null; then
    echo "npm is required. Please install npm."
    exit 1
  fi
  if ! command -v yq &> /dev/null; then
    echo "yq is required. Installing yq..."
    brew install yq
  fi
}

# Check if the script is running within the target repository
is_in_target_repo() {
  if [ -d ".git" ] && grep -q "$REPO_URL" .git/config; then
    echo "Script is running inside the target repository. Exiting to prevent recursive actions."
    exit 1
  fi
}

# Clone the repository and create the update-api branch if not exists
setup_repository() {
  echo "Cloning repository..."
  git clone $REPO_URL
  cd $REPO_NAME

  if ! git show-ref --quiet refs/heads/$BRANCH_NAME; then
    echo "Creating branch $BRANCH_NAME..."
    git checkout -b $BRANCH_NAME
    git push origin $BRANCH_NAME
  else
    echo "Branch $BRANCH_NAME already exists."
  fi

  git checkout $BRANCH_NAME
  cd ..
}

# Create the GitHub Actions workflow file
create_workflow_file() {
  echo "Creating GitHub Actions workflow file..."
  mkdir -p $REPO_NAME/.github/workflows
  cat <<EOL > $REPO_NAME/.github/workflows/update_openapi.yml
name: Update OpenAPI Documentation

on:
  push:
    branches:
      - update-api
    paths:
      - 'api-insert*.yaml'

jobs:
  update-openapi:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      - name: Install dependencies
        run: npm install -g @redocly/cli @apidevtools/swagger-parser yq

      - name: Load and parse API insert file
        id: load-parse
        run: |
          api_insert_file=$(ls api-insert*.yaml | head -n 1)
          api_insert=$(cat \$api_insert_file | yq eval '.')
          target_file=$(echo "\$api_insert" | yq eval '.target-file' -)
          path=$(echo "\$api_insert" | yq eval '.path' -)


          route=$(echo "\$api_insert" | yq eval '.route' -o=json -)
          components=$(echo "\$api_insert" | yq eval '.components' -o=json -)

          echo "target-file=\$target_file" >> \$GITHUB_ENV
          echo "path=\$path" >> \$GITHUB_ENV
          echo "route=\$route" >> \$GITHUB_ENV
          echo "components=\$components" >> \$GITHUB_ENV

      - name: Update OpenAPI files
        run: node ./.github/actions/update-openapi-files/index.js

      - name: Validate OpenAPI files
        run: node ./.github/actions/validate-openapi-files/index.js

      - name: Generate documentation
        run: node ./.github/actions/generate-docs/index.js

      - name: Commit and push changes
        run: node ./.github/actions/commit-push-changes/index.js
EOL
}

# Create the custom GitHub actions
create_custom_actions() {
  echo "Creating custom GitHub actions..."

  # Load and Parse API Insert File
  mkdir -p $REPO_NAME/.github/actions/load-parse-api-insert
  cat <<EOL > $REPO_NAME/.github/actions/load-parse-api-insert/action.yml
name: Load and Parse API Insert File
description: Load and parse the API insert file.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > $REPO_NAME/.github/actions/load-parse-api-insert/index.js
const core = require('@actions/core');
const fs = require('fs');
const yaml = require('js-yaml');

try {
  const files = fs.readdirSync('.');
  const apiInsertFile = files.find(file => file starts with('api-insert') && file ends with('.yaml'));

  if (!apiInsertFile) {
    core.setFailed('No api-insert file found');
    process.exit(1);
  }

  const apiInsertContent = fs.readFileSync(apiInsertFile, 'utf8');
  const apiInsert = yaml.load(apiInsertContent);

  core.setOutput('api-insert-path', apiInsert.path);
  core.setOutput('api-insert-route', JSON.stringify(apiInsert.route));
  core.setOutput('api-insert-components', JSON.stringify(apiInsert.components));
  core.setOutput('api-insert-file', apiInsertFile);
} catch (error) {
  core.setFailed(error.message);
}
EOL

  # Update OpenAPI Files
  mkdir -p $REPO_NAME/.github/actions/update-openapi-files
  cat <<EOL > $REPO_NAME/.github/actions/update-openapi-files/action.yml
name: Update OpenAPI Files
description: Update OpenAPI files with the new route and components.
runs:
  using: 'node12'
  main: 'index.js'
inputs:
  api-insert-path:
    description: 'Path for the new API route'
    required: true
  api-insert-route:
    description: 'Route details for the new API route'
    required: true
  api-insert-components:
    description: 'Components details for the new API route'
    required: true
  target-file:
    description: 'The specific OpenAPI file to update'
    required: true
EOL

  cat <<EOL > $REPO_NAME/.github/actions/update-openapi-files/index.js
const core = require('@actions/core');
const fs = require('fs');
const yaml = require('js-yaml');
const path = require('path');

try {
  const apiInsertPath = process.env.path;
  const apiInsertRoute = JSON.parse(process.env.route);
  const apiInsertComponents = JSON.parse(process.env.components);
  const targetFile = process.env['target-file']; // Specify the target file in api-insert.yaml

  const docsDir = 'FountainAI-Docs/docs';
  const filePath = path.join(docsDir, targetFile);
  if (!fs.existsSync(filePath)) {
    throw new Error(`Target file ${targetFile} does not exist in ${docsDir}`);
  }

  const doc = yaml.load(fs.readFileSync(filePath, 'utf8'));

  if (!doc.paths) {
    doc.paths = {};
  }
  doc.paths[apiInsertPath] = apiInsertRoute;

  if (!doc.components) {
    doc.components = {};
  }
  if (!doc.components.schemas) {
    doc.components.schemas = {};
  }
  doc.components.schemas = { ...doc.components.schemas, ...apiInsertComponents.schemas };

  fs.writeFileSync(filePath, yaml.dump(doc));

  core.setOutput('docs-dir', docsDir);
} catch (error) {
  core.setFailed(error.message);
}
EOL

  # Validate OpenAPI Files
  mkdir -p $REPO_NAME/.github/actions/validate-openapi-files
  cat <<EOL > $REPO_NAME/.github/actions/validate-openapi-files/action.yml
name: Validate OpenAPI Files
description: Validate the updated OpenAPI files.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > $REPO_NAME/.github/actions/validate-openapi-files/index.js
const core = require('@actions/core');
const fs = require('fs');
const path = require('path');
const SwaggerParser = require('@apidevtools/swagger-parser');

(async () => {
  try {
    const docsDir = core.getInput('docs-dir');
    const files are fs.readdirSync(docsDir).filter(file => file ends with('.yaml'));

    for (const file of files) {
      const filePath = path.join(docsDir, file);
      await SwaggerParser.validate(filePath);
      console.log(\`\${file} is valid\`);
    }
  } catch (error) {
    core.setFailed(error.message);
  }
})();
EOL

  # Generate Documentation
  mkdir -p $REPO_NAME/.github/actions/generate-docs
  cat <<EOL > $REPO_NAME/.github/actions/generate-docs/action.yml
name: Generate Documentation
description: Generate HTML documentation from the OpenAPI files.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > $REPO_NAME/.github/actions/generate-docs/index.js
const core = require('@actions/core');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

try {
  const docsDir = core.getInput('docs-dir');
  const outputDir = 'docs_output';

  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir);
  }

  fs.readdirSync(docsDir).forEach(file => {
    if (file ends with('.yaml')) {
      const filePath = path.join(docsDir, file);
      const baseName = path.basename(file, '.yaml');
      execSync(\`redocly build-docs \${filePath} --output \${path.join(outputDir, baseName + '.html')}\`);
    }
  });

  core.setOutput('output-dir', outputDir);
} catch (error) {
  core.setFailed(error.message);
}
EOL

  # Commit and Push Changes
  mkdir -p $REPO_NAME/.github/actions/commit-push-changes
  cat <<EOL > $REPO_NAME/.github/actions/commit-push-changes/action.yml
name: Commit and Push Changes
description: Commit the updated OpenAPI files and push to the branch.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > $REPO_NAME/.github/actions/commit-push-changes/index.js
const core = require('@actions/core');
const { execSync } = require('child_process');

try {
  const branchName = core.getInput('branch-name');
  const apiInsertFile = core.getInput('api-insert-file');

  execSync('git config --global user.name "github-actions[bot]"');
  execSync('git config --global user.email "github-actions[bot]@users.noreply.github.com"');
  execSync('git add .');
  execSync(\`git commit -m "Update OpenAPI documentation with \${apiInsertFile}"\`);
  execSync(\`git push origin \${branchName}\`);
} catch (error) {
  core.setFailed(error.message);
}
EOL
}

# Move script to repository if not already there
move_script_to_repo() {
  if [[ ! -f $REPO_NAME/$SCRIPT_NAME ]]; then
    echo "Moving script to repository..."
    cp $SCRIPT_NAME $REPO_NAME/
    cd $REPO_NAME
    git add $SCRIPT_NAME
    git commit -m "Add setup script to repository"
    git push origin $BRANCH_NAME
    cd ..
  fi
}

# Main function to run the setup
main() {
  check_dependencies
  is_in_target_repo
  setup_repository
  create_workflow_file
  create_custom_actions
  move_script_to_repo

  echo "Setup complete. You can now push changes to the update-api branch and the workflow will trigger automatically."
}

main
```

### Explanation of the Script's Behavior

#### Copying the Script to the Target Repository

The script copies itself to the target repository for the following reasons:

1. **Persistent Availability:** By copying itself to the target repository, the setup script becomes part of the repository's history, ensuring that anyone who clones the repository in the future has immediate access to the setup script.

2. **Ease of Use:** Developers working on the repository can easily re-run the setup script if needed. This is particularly useful for onboarding new team members or setting up new development environments.

3. **Version Control:** Including the setup script in the repository allows it to be version-controlled along with the rest of the project. Any updates or improvements to the script can be tracked, reviewed, and reverted if necessary.

#### The `is_in_target_repo` Check

The `is_in_target_repo` function ensures that the script does not run recursively, which could lead to severe system issues. Here's why this check is crucial:

1. **Preventing Recursive Cloning:**
   - **Problem:** If the setup script were to run inside the cloned repository, it could attempt to clone the repository again inside itself. This recursive action could consume disk space and system resources, leading to system instability or crashes.
   - **Solution:** The `is_in_target_repo` function checks if the script is running within a cloned repository by looking for a `.git` directory and verifying the repository URL in the git configuration. If the script detects that it is running within the target repository, it exits immediately to prevent recursive cloning.

2. **Ensuring Script Safety:**
   - **Problem:** Recursive actions caused by the script can lead to infinite loops, filling up disk space, and rendering the system unresponsive.
   - **Solution:** By adding a safeguard that exits the script if it detects that it is running inside the target repository, we ensure that the script operates safely and only performs the intended one-time setup actions.

3. **Consistency and Reliability:**
   - **Problem:** Running the script multiple times, especially if it clones the repository recursively, can lead to inconsistent states and unreliable setup processes.
   - **Solution:** The check ensures that the script only runs its intended actions once in the correct environment, providing a consistent and reliable setup process for the repository.

### Using the Pipeline

#### Step 1: Create the `api-insert.yaml` File

To create the `api-insert.yaml` file using a GPT model, follow these steps:

##### Prompting the GPT Model

1. **Understanding the Prompt Principle:**
   When prompting a GPT model to generate OpenAPI documentation, it's important to be clear and specific about the endpoint details. Your prompt should include information about the HTTP method, the path, the expected response, and any relevant components or schemas.

2. **Example Prompt for a Basic Endpoint:**
   Use the following prompt to generate the OpenAPI path for a new "Hello World" endpoint:

   ```
   Create a complete OpenAPI path for a "Hello World" endpoint. The endpoint should respond to a GET request at /hello and return a JSON object with a message property. The path should be documented with summary, description, and operationId. Additionally, provide a response schema under the components section that includes a "HelloResponse" object with a "message" property of type string.
   ```

3. **Example Output:**
   Here is an example output that you can expect from the GPT model:

   ```yaml
   path: /hello
   target-file: specific-openapi-file.yaml # The file you want to update
   route:
     get:
       summary: "Say Hello"
       description: "An endpoint to say hello."
       operationId: "sayHello"
       responses:
         "200":
           description: "A successful response"
           content:
             application/json:
               schema:
                 $ref: '#/components/schemas/HelloResponse'
   components:
     schemas:
       HelloResponse:
         type: object
         properties:
           message:
             type: string
             description: "The hello message"
   ```

4. **Modify as Needed:**
   Modify the generated `api-insert.yaml` file as needed to match the specific requirements of your API.

5. **Save the File:**
   Save the file with a name starting with `api-insert` (e.g., `api-insert-hello.yaml`) in the root directory of the `FountainAI-API-Docs` repository.

##### Crafting Prompts for Other Routes

1. **Creating More Complex Endpoints:**
   To create more complex endpoints, adjust your prompt to include additional details. For example, if you need a POST endpoint that accepts a JSON body with user information, your prompt might look like this:

   ```
   Create a complete OpenAPI path for a "Create User" endpoint. The endpoint should respond to a POST request at /users and accept a JSON body with "name" and "email" properties. The path should be documented with summary, description, and operationId. Additionally, provide request and response schemas under the components section that includes a "UserRequest" object with "name" and "email" properties and a "UserResponse" object with "id", "name", and "email" properties.
   ```

2. **Example Output for a More Complex Endpoint:**
   Here is an example output for the "Create User" endpoint:

   ```yaml
   path: /users
   target-file: specific-openapi-file.yaml # The file you want to update
   route:
     post:
       summary: "Create User"
       description: "An endpoint to create a new user."
       operationId: "createUser"
       requestBody:
         description: "User object that needs to be added"
         content:
           application/json:
             schema:
               $ref: '#/components/schemas/UserRequest'
       responses:
         "201":
           description: "User created successfully"
           content:
             application/json:
               schema:
                 $ref: '#/components/schemas/UserResponse'
   components:
     schemas:
       UserRequest:
         type: object
         properties:
           name:
             type: string
             description: "The user's name"
           email:
             type: string
             description: "The user's email"
       UserResponse:
         type: object
         properties:
           id:
             type: integer
             description: "The user ID"
           name:
             type: string
             description: "The user's name"
           email:
             type: string
             description: "The user's email"
   ```

##### Using the `target-file` Mechanism

1. **Understanding the `target-file` Mechanism:**
   The `target-file` field in the `api-insert.yaml` file specifies the exact OpenAPI YAML file that should be updated with the new route. This mechanism allows you to target specific files for updates, ensuring that your API documentation remains organized and modular.

2. **Special Feature - Not Part of OpenAPI Spec:**
   The `target-file` field is a special feature of our pipeline. It is not part of the standard OpenAPI specification. This field will not be included in the resulting OpenAPI file. It is used solely to determine which file to update.

3. **Specifying the `target-file`:**
   In your `api-insert.yaml` file, include the `target-file` field to indicate which OpenAPI YAML file should be updated. For example:

   ```yaml
   path: /hello
   target-file: core-api.yaml # The file you want to update
   route:
     get:
       summary: "Say Hello"
       description: "An endpoint to say hello."
       operationId: "sayHello"
       responses:
         "200":
           description: "A successful response"
           content:
             application/json:
               schema:
                 $ref: '#/components/schemas/HelloResponse'
   components:
     schemas:
       HelloResponse:
         type: object
         properties:
           message:
             type: string
             description: "The hello message"
   ```

4. **Uniqueness of the `target-file`:**
   Ensure that the specified `target-file` is unique and exists in the `docs` directory of your repository. The script will throw an error if the specified file does not exist.

5. **Using the `target-file` Mechanism in Prompts:**
   When crafting prompts for the GPT model, remember to include instructions to generate the `target-file` field. This ensures that the generated `api-insert.yaml` file includes the necessary information for the update script to function correctly.

6. **Dependency Evaluation in Code:**
   The dependency on the `docs` folder is evaluated in the `update-openapi-files` action, specifically in the `index.js` file. Here is the relevant section of the code:

   ```javascript
   const core = require('@actions/core');
   const fs = require('fs');
   const yaml = require('js-yaml');
   const path = require('path');

   try {
     const apiInsertPath = process.env.path;
     const apiInsertRoute = JSON.parse(process.env.route);
     const apiInsertComponents = JSON.parse(process.env.components);
     const targetFile = process.env['target-file']; // Specify the target file in api-insert.yaml

     const docsDir = 'FountainAI-Docs/docs';
     const filePath = path.join(docsDir, targetFile);
     if (!fs.existsSync(filePath)) {
       throw new Error(`Target file ${targetFile} does not exist in ${docsDir}`);
     }

     const doc = yaml.load(fs.readFileSync(filePath, 'utf8'));

     if (!doc.paths) {
       doc.paths = {};
     }
     doc.paths[apiInsertPath] = apiInsertRoute;

     if (!doc.components) {
       doc.components = {};
     }
     if (!doc.components.schemas) {
       doc.components.schemas = {};
     }
     doc.components.schemas = { ...doc.components.schemas, ...apiInsertComponents.schemas };

     fs.writeFileSync(filePath, yaml.dump(doc));

     core.setOutput('docs-dir', docsDir);
   } catch (error) {
     core.setFailed(error.message);
   }
   ```

##### Proceed with the Pipeline

1. **Commit and Push the `api-insert.yaml` File:**

   - Save the `api-insert.yaml` file in the root directory of the `FountainAI-API-Docs` repository.
   - Commit and push the file to the `update-api` branch:

     ```bash
     git add api-insert*.yaml
     git commit -m "Add new endpoint"
     git push origin update-api
     ```

2. **Monitor the GitHub Actions Workflow:**

   - Go to your GitHub repository.
   - Click on the "Actions" tab.
   - Monitor the "Update OpenAPI Documentation" workflow to ensure it runs successfully.

3. **Verify the Documentation:**

   - Once the workflow completes, check the `gh-pages` branch for the updated HTML documentation.
   - The documentation will be available at:
     - Main page: `https://Contexter.github.io/FountainAI-API-Docs/index.html`
     - DNS Mapped Domain: `https://docs.fountain.coach`


### Reverting Changes

If you need to revert the changes made by the script, follow these steps:

1. **Identify the commit to revert:** Find the commit hash that you want to revert. You can use the `git log` command to see the commit history.

   ```bash
   git log
   ```

2. **Revert the commit:** Use the `git revert` command to create a new commit that undoes the changes introduced by the specified commit.

   ```bash
   git revert <commit-hash>
   ```

   For example, if the commit hash is `abc123`, you would run:

   ```bash
   git revert abc123
   ```

3. **Push the changes:** Push the new commit to the `update-api` branch to trigger the pipeline and update the documentation.

   ```bash
   git push origin update-api
   ```

Alternatively, if you need to revert multiple commits:

1. **Identify the commit to reset to:** Find the commit hash that you want to reset to. You can use the `git log` command to see the commit history.

   ```bash
   git log
   ```

2. **Reset the branch:** Use the `git reset` command to reset the branch to the specified commit. The `--hard` option will discard all changes made after the specified commit.

   ```bash
   git reset --hard <commit-hash>
   ```

   For example, if the commit hash is `abc123`, you would run:

   ```bash
   git reset --hard abc123
   ```

3. **Force push the changes:** Push the changes to the `update-api` branch. Note that this is a force push, which can overwrite history, so use it with caution.

   ```bash
   git push --force origin update-api
   ```

### Summary

This document provides a detailed guide for setting up and using the FountainAI OpenAPI documentation update pipeline. The setup script creates the necessary GitHub Actions workflow and custom actions to automate the process of updating OpenAPI documentation. The instructions ensure that you can easily update and maintain the OpenAPI documentation with minimal manual intervention. By following these steps, you can ensure your OpenAPI documentation is always up-to-date and accessible via GitHub Pages.


