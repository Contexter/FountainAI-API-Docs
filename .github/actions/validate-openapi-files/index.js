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
      console.log(`${file} is valid`);
    }
  } catch (error) {
    core.setFailed(error.message);
  }
})();
