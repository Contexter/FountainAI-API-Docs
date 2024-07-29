### Tutorial: Updating GitHub Pages for OpenAPI Documentation after YAML File Changes

Updating your GitHub Pages for OpenAPI documentation after changes to the YAML files involves several steps. Follow this guide to ensure your documentation remains up-to-date and correctly published.

#### Prerequisites

1. **Git**: Ensure Git is installed on your machine.
2. **Node.js and npm**: Install Node.js and npm if they are not already installed.
3. **redoc-cli**: Install the Redoc CLI globally.
   ```bash
   npm install -g @redocly/cli
   ```

#### Step 1: Update the OpenAPI YAML Files

1. Navigate to your local repository directory:
   ```bash
   cd path/to/your/repository
   ```
2. Edit the OpenAPI YAML files (`openapi-character.yaml`, `openapi-core.yaml`, `openapi-session.yaml`) as needed.

#### Step 2: Generate Updated HTML Documentation

1. Use the Redoc CLI to generate HTML files for each of the updated YAML files:
   ```bash
   redocly build-docs openapi-character.yaml --output character.html
   redocly build-docs openapi-core.yaml --output core.html
   redocly build-docs openapi-session.yaml --output session.html
   ```

2. Ensure that the generated HTML files are in the root directory of your repository.

#### Step 3: Commit and Push Changes to GitHub

1. Create and switch to the `gh-pages` branch if you haven't already:
   ```bash
   git checkout -b gh-pages
   ```

2. Add the changes to Git:
   ```bash
   git add character.html core.html session.html
   git add openapi-character.yaml openapi-core.yaml openapi-session.yaml
   ```

3. Commit the changes:
   ```bash
   git commit -m "Update OpenAPI documentation"
   ```

4. Push the changes to your GitHub repository:
   ```bash
   git push origin gh-pages
   ```

#### Step 4: Publish on GitHub Pages

1. Go to the repository settings on GitHub.
2. Scroll down to the "GitHub Pages" section.
3. Under "Source", select the branch (`gh-pages`) and the root directory (`/`).
4. Save the settings.

Your documentation will be available at:
- Main page: `https://Contexter.github.io/FountainAI-API-Docs/index.html`
- Core API: `https://Contexter.github.io/FountainAI-API-Docs/core.html`
- Character API: `https://Contexter.github.io/FountainAI-API-Docs/character.html`
- Session API: `https://Contexter.github.io/FountainAI-API-Docs/session.html`

#### Summary of Commands

1. **Update YAML and Generate HTML**:
   ```bash
   redocly build-docs openapi-character.yaml --output character.html
   redocly build-docs openapi-core.yaml --output core.html
   redocly build-docs openapi-session.yaml --output session.html
   ```

2. **Commit and Push Changes**:
   ```bash
   git checkout -b gh-pages
   git add character.html core.html session.html
   git add openapi-character.yaml openapi-core.yaml openapi-session.yaml
   git commit -m "Update OpenAPI documentation"
   git push origin gh-pages
   ```

3. **Configure GitHub Pages**:
   - Go to GitHub repository settings.
   - Configure GitHub Pages to serve from the `gh-pages` branch and root directory.

By following these steps, you ensure that your OpenAPI documentation is always up-to-date and accessible via GitHub Pages.