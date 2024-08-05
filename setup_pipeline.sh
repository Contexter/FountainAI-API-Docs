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
  if [ -d "$REPO_NAME" ] && [ -d "$REPO_NAME/.git" ]; then
    echo "Already in the $REPO_NAME repository."
    return 0
  fi
  return 1
}

# Clone the repository and create the update-api branch if not exists
setup_repository() {
  if ! is_in_target_repo; then
    echo "Cloning repository..."
    git clone $REPO_URL
    cd $REPO_NAME
  else
    cd $REPO_NAME
  fi

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
  setup_repository
  create_workflow_file
  create_custom_actions
  move_script_to_repo

  echo "Setup complete. You can now push changes to the update-api branch and the workflow will trigger automatically."
}

main
