#!/bin/bash

# Check if the docs directory exists
if [ -d "docs" ]; then
  echo "docs directory exists. Proceeding with patching..."
else
  echo "Error: docs directory does not exist."
  exit 1
fi

# Copy or generate the necessary files in the docs directory
# Assuming you have some files to copy or generate here
# For example, creating an index.html file
echo "<!DOCTYPE html>
<html>
<head>
  <title>API Documentation Index</title>
</head>
<body>
  <h1>API Documentation Index</h1>
  <ul>
    <li><a href='character.html'>Character API</a></li>
    <li><a href='core.html'>Core API</a></li>
    <li><a href='session.html'>Session API</a></li>
  </ul>
</body>
</html>" > docs/index.html

echo "All files created successfully."

# Commit and push the changes
cd docs
git add .
git commit -m "Update API documentation"
git push origin main

echo "Patch applied successfully! You can view your documentation at: https://Contexter.github.io/FountainAI-API-Docs/index.html"
