const core = require('@actions/core');
const { execSync } = require('child_process');

try {
  const branchName = core.getInput('branch-name');
  const apiInsertFile = core.getInput('api-insert-file');

  execSync('git config --global user.name "github-actions[bot]"');
  execSync('git config --global user.email "github-actions[bot]@users.noreply.github.com"');
  execSync('git add .');
  execSync(`git commit -m "Update OpenAPI documentation with ${apiInsertFile}"`);
  execSync(`git push origin ${branchName}`);
} catch (error) {
  core.setFailed(error.message);
}
