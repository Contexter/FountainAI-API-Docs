const core = require('@actions/core');
const fs = require('fs');
const yaml = require('js-yaml');

try {
  const files = fs.readdirSync('.');
  const apiInsertFile = files.find(file => file.startsWith('api-insert') && file endsWith('.yaml'));

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
