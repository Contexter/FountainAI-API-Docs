## FountainAI OpenAPI Documentation Update Pipeline

This document provides a comprehensive guide for setting up and using the FountainAI OpenAPI documentation update pipeline. This pipeline automates the process of updating OpenAPI documentation by adding new routes to the OpenAPI YAML files, validating them, generating HTML documentation, and committing the changes to the repository.

### Table of Contents

1. [Introduction](#introduction)
2. [Setup Instructions](#setup-instructions)
   - [Prerequisites](#prerequisites)
   - [Step 1: Clone the Repository](#step-1-clone-the-repository)
   - [Step 2: Create the `update-api` Branch](#step-2-create-the-update-api-branch)
   - [Step 3: Run the Setup Script](#step-3-run-the-setup-script)
3. [Using the Pipeline](#using-the-pipeline)
   - [Step 1: Create the `api-insert.yaml` File](#step-1-create-the-api-insert-yaml-file)
   - [Step 2: Commit and Push the `api-insert.yaml` File](#step-2-commit-and-push-the-api-insert-yaml-file)
   - [Step 3: Monitor the GitHub Actions Workflow](#step-3-monitor-the-github-actions-workflow)
   - [Step 4: Verify the Documentation](#step-4-verify-the-documentation)
4. [Reverting Changes](#reverting-changes)
5. [Summary](#summary)

### Introduction

The objective of the FountainAI project is to streamline the deployment and management of multiple Vapor applications using Docker Swarm and Caddy. This approach eliminates unnecessary intermediate applications, reduces complexity, and leverages modern DevOps practices to ensure a robust and efficient workflow. The project uses OpenAPI specifications available at [FountainAI-API-Docs](https://github.com/Contexter/FountainAI-API-Docs) to generate and manage Vapor services.

### Setup Instructions

#### Prerequisites

Ensure the following tools are installed on your machine:

- Git: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- Node.js and npm: [Install Node.js and npm](https://nodejs.org/)

#### Step 1: Clone the Repository

Clone the FountainAI-API-Docs repository to your local machine:

```bash
git clone https://github.com/Contexter/FountainAI-API-Docs.git
cd FountainAI-API-Docs
```

#### Step 2: Create the `update-api` Branch

Create and push the `update-api` branch if it doesn't already exist:

```bash
git checkout -b update-api
git push origin update-api
```

#### Step 3: Run the Setup Script

Save the following setup script to a file (e.g., `setup_pipeline.sh`), make it executable, and run it:

```bash
#!/bin/bash

# Exit on any error
set -e

# Repository and branch configuration
REPO_URL="https://github.com/Contexter/FountainAI-API-Docs.git"
BRANCH_NAME="update-api"
SCRIPT_NAME="setup_pipeline.sh"

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
}

# Clone the repository and create the update-api branch if not exists
setup_repository() {
  echo "Cloning repository..."
  git clone $REPO_URL
  cd FountainAI-API-Docs

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
  mkdir -p FountainAI-API-Docs/.github/workflows
  cat <<EOL > FountainAI-API-Docs/.github/workflows/update_openapi.yml
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
        uses: ./.github/actions/load-parse-api-insert

      - name: Update OpenAPI files
        uses: ./.github/actions/update-openapi-files

      - name: Validate OpenAPI files
        uses: ./.github/actions/validate-openapi-files

      - name: Generate documentation
        uses: ./.github/actions/generate-docs

      - name: Commit and push changes
        uses: ./.github/actions/commit-push-changes
        with:
          branch-name: \${{ github.ref_name }}
EOL
}

# Create the custom GitHub actions
create_custom_actions() {
  echo "Creating custom GitHub actions..."

  # Load and Parse API Insert File
  mkdir -p FountainAI-API-Docs/.github/actions/load-parse-api-insert
  cat <<EOL > FountainAI-API-Docs/.github/actions/load-parse-api-insert/action.yml
name: Load and Parse API Insert File
description: Load and parse the API insert file.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > FountainAI-API-Docs/.github/actions/load-parse-api-insert/index.js
const core = require('@actions/core');
const fs = require('fs');
const yaml = require('js-yaml');

try {
  const files = fs.readdirSync('.');
  const apiInsertFile = files.find(file => file.startsWith('api-insert') && file.endsWith('.yaml'));

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
  mkdir -p FountainAI-API-Docs/.github/actions/update-openapi-files
  cat <<EOL > FountainAI-API-Docs/.github/actions/update-openapi-files/action.yml
name: Update OpenAPI Files
description: Update OpenAPI files with the new route and components.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > FountainAI-API-Docs/.github/actions/update-openapi-files/index.js
const core = require('@actions/core');
const fs = require('fs');
const yaml = require('js-yaml');
const path = require('path');

try {
  const apiInsertPath = core.getInput('api-insert-path');
  const apiInsertRoute = JSON.parse(core.getInput('api-insert-route'));
  const apiInsertComponents = JSON.parse(core.getInput('api-insert-components'));

  const docsDir = 'FountainAI-API-Docs/docs';

  fs.readdirSync(docsDir).forEach(file => {
    if (file.endsWith('.yaml')) {
      const filePath = path.join(docsDir, file);
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
    }
  });

  core.setOutput('docs-dir', docsDir);
} catch (error) {
  core.setFailed(error.message);
}
EOL

  # Validate OpenAPI Files
  mkdir -p FountainAI-API-Docs/.github/actions/validate-openapi-files
  cat <<EOL > FountainAI-API-Docs/.github/actions/validate-openapi-files/action.yml
name: Validate OpenAPI Files
description: Validate the updated OpenAPI files.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > FountainAI-API-Docs/.github/actions/validate-openapi-files/index.js
const core = require('@actions/core');
const fs = require('fs');
const path = require('path');
const SwaggerParser = require

('@apidevtools/swagger-parser');

(async () => {
  try {
    const docsDir = core.getInput('docs-dir');
    const files = fs.readdirSync(docsDir).filter(file => file.endsWith('.yaml'));

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
  mkdir -p FountainAI-API-Docs/.github/actions/generate-docs
  cat <<EOL > FountainAI-API-Docs/.github/actions/generate-docs/action.yml
name: Generate Documentation
description: Generate HTML documentation from the OpenAPI files.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > FountainAI-API-Docs/.github/actions/generate-docs/index.js
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
    if (file.endsWith('.yaml')) {
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
  mkdir -p FountainAI-API-Docs/.github/actions/commit-push-changes
  cat <<EOL > FountainAI-API-Docs/.github/actions/commit-push-changes/action.yml
name: Commit and Push Changes
description: Commit the updated OpenAPI files and push to the branch.
runs:
  using: 'node12'
  main: 'index.js'
EOL

  cat <<EOL > FountainAI-API-Docs/.github/actions/commit-push-changes/index.js
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
  if [[ ! -f FountainAI-API-Docs/$SCRIPT_NAME ]]; then
    echo "Moving script to repository..."
    cp $SCRIPT_NAME FountainAI-API-Docs/
    cd FountainAI-API-Docs
    git add $SCRIPT_NAME
    git commit -m "Add setup script to repository"
    git push origin $BRANCH_NAME
    cd ..
  fi
}

# Main function to run the setup
main() {
  check_dependencies
  setup_repository
  create_workflow_file
  create_custom_actions
  move_script_to_repo

  echo "Setup complete. You can now push changes to the update-api branch and the workflow will trigger automatically."
}

main
```

Make the script executable and run it:

```bash
chmod +x setup_pipeline.sh
./setup_pipeline.sh
```

### Using the Pipeline

#### Step 1: Create the `api-insert.yaml` File

Create an `api-insert.yaml` file that contains the new route you want to add to the OpenAPI documentation. Here is an example content for a "Hello World" endpoint:

```yaml
# GPT-4 Prompt: Create a complete OpenAPI path for a "Hello World" endpoint.
# The endpoint should respond to a GET request at /hello and return a JSON object with a message property.
# The path should be documented with summary, description, and operationId.
# Additionally, provide a response schema under the components section that includes a "HelloResponse" object 
# with a "message" property of type string.
path: /hello
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

#### Step 2: Commit and Push the `api-insert.yaml` File

1. Save the `api-insert.yaml` file in the root directory of the `FountainAI-API-Docs` repository.
2. Commit and push the file to the `update-api` branch:

```bash
git add api-insert.yaml
git commit -m "Add new Hello World endpoint"
git push origin update-api
```

#### Step 3: Monitor the GitHub Actions Workflow

1. Go to your GitHub repository.
2. Click on the "Actions" tab.
3. Monitor the "Update OpenAPI Documentation" workflow to ensure it runs successfully.

#### Step 4: Verify the Documentation

1. Once the workflow completes, check the `gh-pages` branch for the updated HTML documentation.
2. The documentation will be available at:
   - Main page: `https://Contexter.github.io/FountainAI-API-Docs/index.html`
   - Core API: `https://Contexter.github.io/FountainAI-API-Docs/core.html`
   - Character API: `https://Contexter.github.io/FountainAI-API-Docs/character.html`
   - Session API: `https://Contexter.github.io/FountainAI-API-Docs/session.html`

### Reverting Changes

If you need to revert the changes made by the script, follow these steps:

1. **Identify the commit to revert**: Find the commit hash that you want to revert. You can use the `git log` command to see the commit history.

   ```bash
   git log
   ```

2. **Revert the commit**: Use the `git revert` command to create a new commit that undoes the changes introduced by the specified commit.

   ```bash
   git revert <commit-hash>
   ```

   For example, if the commit hash is `abc123`, you would run:

   ```bash
   git revert abc123
   ```

3. **Push the changes**: Push the new commit to the `update-api` branch to trigger the pipeline and update the documentation.

   ```bash
   git push origin update-api
   ```

Alternatively, if you need to revert multiple commits:

1. **Identify the commit to reset to**: Find the commit hash that you want to reset to. You can use the `git log` command to see the commit history.

   ```bash
   git log
   ```

2. **Reset the branch**: Use the `git reset` command to reset the branch to the specified commit. The `--hard` option will discard all changes made after the specified commit.

   ```bash
   git reset --hard <commit-hash>
   ```

   For example, if the commit hash is `abc123`, you would run:

   ```bash
   git reset --hard abc123
   ```

3. **Force push the changes**: Push the changes to the `update-api` branch. Note that this is a force push, which can overwrite history, so use it with caution.

   ```bash
   git push --force origin update-api
   ```

### Summary

This document provides a detailed guide for setting up and using the FountainAI OpenAPI documentation update pipeline. The setup script creates the necessary GitHub Actions workflow and custom actions to automate the process of updating OpenAPI documentation. The instructions ensure that you can easily update and maintain the OpenAPI documentation with minimal manual intervention. By following these steps, you can ensure your OpenAPI documentation is always up-to-date and accessible via GitHub Pages.

Additionally, the setup script ensures that it moves itself into the repository if it's not already there, preventing the repository from being cloned recursively into itself.

---