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
    if (file endsWith('.yaml')) {
      const filePath = path.join(docsDir, file);
      const baseName = path.basename(file, '.yaml');
      execSync(`redocly build-docs ${filePath} --output ${path.join(outputDir, baseName + '.html')}`);
    }
  });

  core.setOutput('output-dir', outputDir);
} catch (error) {
  core.setFailed(error.message);
}
