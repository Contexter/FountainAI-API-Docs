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
    throw new Error();
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
