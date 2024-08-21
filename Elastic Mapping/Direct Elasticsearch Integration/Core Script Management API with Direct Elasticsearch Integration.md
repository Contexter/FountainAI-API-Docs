# **Core Script Management API with Direct Elasticsearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Core Script Management Service within the FountainAI system. The API directly integrates with Elasticsearch, eliminating the need for an additional mapping layer and ensuring straightforward interactions with the backend.

## **1. Objective**

- **Direct Integration:** Use Elasticsearch REST API paths directly in the OpenAPI specification for managing scripts and sections.
- **Unified Configuration:** Leverage this specification for configuring GPT model actions and AWS API Gateway.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Elasticsearch.

## **2. Core Script Management API: Full OpenAPI Specification**

Below is the full OpenAPI specification for the Core Script Management Service, configured for direct interaction with Elasticsearch.

```yaml
openapi: 3.0.0
info:
  title: Core Script Management API
  description: API for managing scripts and their sections in the FountainAI system, integrated directly with Elasticsearch.
  version: 1.0.0
servers:
  - url: https://api.scripts.fountainai.com
    description: FountainAI Core Script Management API Server
paths:
  /scripts/_search:
    post:
      summary: Retrieve all scripts
      description: Queries the Elasticsearch index to retrieve all script documents.
      operationId: searchScripts
      requestBody:
        description: The Elasticsearch query object.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                query:
                  type: object
                  description: The Elasticsearch Query DSL to filter scripts.
      responses:
        '200':
          description: A list of scripts
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    title:
                      type: string
                    author:
                      type: string
                    description:
                      type: string
  /scripts/_doc:
    post:
      summary: Create a new script
      description: Adds a new script document to the Elasticsearch index.
      operationId: createScript
      requestBody:
        description: Script data to be added.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                title:
                  type: string
                  example: "The Great Adventure"
                author:
                  type: string
                  example: "John Smith"
                description:
                  type: string
                  example: "An epic tale of adventure."
      responses:
        '201':
          description: Script created successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the created document
                  result:
                    type: string
                    example: "created"
  /scripts/_doc/{scriptId}:
    get:
      summary: Retrieve a script by ID
      description: Retrieves a specific script document from the Elasticsearch index by its ID.
      operationId: getScriptById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Script document retrieved
          content:
            application/json:
              schema:
                type: object
                properties:
                  id:
                    type: string
                  title:
                    type: string
                  author:
                    type: string
                  description:
                    type: string
        '404':
          description: Script not found
  /scripts/_doc/{scriptId}:
    put:
      summary: Update a script by ID
      description: Updates an existing script document in the Elasticsearch index.
      operationId: updateScriptById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to update.
          schema:
            type: string
      requestBody:
        description: The new script data.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                title:
                  type: string
                author:
                  type: string
                description:
                  type: string
      responses:
        '200':
          description: Script updated successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the updated document
                  result:
                    type: string
                    example: "updated"
        '404':
          description: Script not found
  /scripts/_doc/{scriptId}:
    delete:
      summary: Delete a script by ID
      description: Deletes a script document from the Elasticsearch index by its ID.
      operationId: deleteScriptById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to delete.
          schema:
            type: string
      responses:
        '200':
          description: Script deleted successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the deleted document
                  result:
                    type: string
                    example: "deleted"
        '404':
          description: Script not found
  /scripts/_doc/{scriptId}/sections/_search:
    post:
      summary: Retrieve sections of a script
      description: Queries the Elasticsearch index for sections linked to a specific script.
      operationId: searchSections
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose sections are being queried.
          schema:
            type: string
      requestBody:
        description: The Elasticsearch query object for sections.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                query:
                  type: object
                  description: The query DSL to filter sections.
      responses:
        '200':
          description: A list of sections
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    sectionId:
                      type: string
                    title:
                      type: string
                    sequence:
                      type: integer
  /scripts/_doc/{scriptId}/sections/_doc:
    post:
      summary: Create a section for a script
      description: Adds a new section document to the Elasticsearch index linked to a specific script.
      operationId: createSection
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to which the section is linked.
          schema:
            type: string
      requestBody:
        description: Section data to be added.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                title:
                  type: string
                  example: "Introduction"
                sequence:
                  type: integer
                  example: 1
      responses:
        '201':
          description: Section created successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the created document
                  result:
                    type: string
                    example: "created"
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    get:
      summary: Retrieve a section by ID
      description: Retrieves a specific section document from the Elasticsearch index by its ID.
      operationId: getSectionById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose section is being retrieved.
          schema:
            type: string
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Section document retrieved
          content:
            application/json:
              schema:
                type: object
                properties:
                  sectionId:
                    type: string
                  title:
                    type: string
                  sequence:
                    type: integer
        '404':
          description: Section not found
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    put:
      summary: Update a section by ID
      description: Updates an existing section document in the Elasticsearch index.
      operationId: updateSectionById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose section is being updated.
          schema:
            type: string
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to update.
          schema:
            type: string
      requestBody:
        description: The new section data.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                title:
                  type: string
                sequence:
                  type: integer
      responses:
        '200':
          description: Section updated successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the updated document
                  result:
                    type: string
                    example: "updated"
        '404':
          description: Section not found
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    delete:
      summary: Delete a section by ID
      description: Deletes a section document from the Elasticsearch index by its ID.
      operationId: deleteSectionById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose section is being deleted.
          schema:
            type: string
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to delete.
          schema:
            type: string
      responses:
        '200':
          description: Section deleted successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the deleted document
                  result:
                    type: string
                    example: "deleted"
        '404':
          description: Section not found
components:
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
security:
  - ApiKeyAuth: []
```

### **2.1. Key Sections Explained**

- **Servers Section:**
  - **URL:** `https://api.scripts.fountainai.com` — This server section points directly to the FountainAI Core Script Management API server.

- **Paths Section:**
  - **`/scripts/_search`:** Queries the Elasticsearch index for scripts. The operation expects a query object using Elasticsearch's query DSL.
  - **`/scripts/_doc`:** Creates a new script document in Elasticsearch.
  - **`/scripts/_doc/{scriptId}`:**
    - **GET:** Retrieves a specific script document by its ID.
    - **PUT:** Updates a specific script document by its ID.
    - **DELETE:** Deletes a specific script document by its ID.
  - **`/scripts/_doc/{scriptId}/sections/_search`:** Queries Elasticsearch for sections linked to a specific script.
  - **`/scripts/_doc/{scriptId}/sections/_doc`:** Creates, retrieves, updates, and deletes section documents linked to a script in Elasticsearch.

- **Security Schemes:**
  - **API Key Authentication:** The API requires an API key for all operations, passed in the `X-API-Key` header.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Search for scripts"
  - **API Call:** `POST /scripts/_search`
  - **Operation:** The GPT model generates a query based on user input and interacts directly with Elasticsearch to retrieve matching script documents.

- **Action:** "Create a script"
  - **API Call:** `POST /scripts/_doc`
  - **Operation:** The GPT model sends a script creation request to Elasticsearch, which then stores the new document in the `scripts` index.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification.
- **Security Setup:** AWS API Gateway will enforce API key authentication as defined in the OpenAPI specification.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`), making it live and accessible via the specified URL.

### **5. Conclusion**

This comprehensive OpenAPI specification directly integrates Elasticsearch REST API paths into the Core Script Management API for FountainAI. It ensures that all interactions with Elasticsearch are direct and secure, without the need for an additional mapping layer. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway.

This method can be extended to other FountainAI services, ensuring consistency and reliability across the entire system while simplifying the API management process.