# **Core Script Management API with Secure Opensearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Core Script Management Service within the FountainAI system. The API integrates directly with Opensearch, ensuring straightforward and secure interactions with the backend.

## **1. Objective**

- **Direct Integration:** Use Opensearch REST API paths directly in the OpenAPI specification for managing scripts and sections.
- **Secure Configuration:** Implement best practices to securely manage sensitive information, such as Opensearch domain and API keys.
- **AWS API Gateway Configuration:** Leverage AWS-specific extensions for integration, security, and deployment.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Opensearch and AWS.

## **2. Core Script Management API: Full OpenAPI Specification**

### **2.1. Handling Secrets Securely**

Sensitive information such as Opensearch domain endpoints, API keys, and other credentials should not be hardcoded in the OpenAPI document. Instead, placeholders or environment variable references should be used, with the actual values injected during deployment or retrieved at runtime.

#### **Example Configuration:**
- **Opensearch Domain:** Use a placeholder or environment variable reference (`${OPENSEARCH_DOMAIN}`) instead of hardcoding the domain name.
- **AWS Secrets Manager or Parameter Store:** Store sensitive information in AWS Secrets Manager or Parameter Store and retrieve them at runtime.

### **2.2. OpenAPI Specification**

Below is the OpenAPI specification for the Core Script Management Service, configured for secure interaction with Opensearch and optimized for AWS API Gateway.

```yaml
openapi: 3.1.0
info:
  title: Core Script Management API
  description: API for managing scripts and their sections in the FountainAI system, integrated directly with Opensearch.
  version: 1.0.0
servers:
  - url: https://api.scripts.fountainai.com
    description: FountainAI Core Script Management API Server
paths:
  /scripts/_search:
    post:
      summary: Retrieve all scripts
      description: Queries the Opensearch index to retrieve all script documents.
      operationId: searchScripts
      requestBody:
        description: The Opensearch query object.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                query:
                  type: object
                  description: The Opensearch Query DSL to filter scripts.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc:
    post:
      summary: Create a new script
      description: Adds a new script document to the Opensearch index.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}:
    get:
      summary: Retrieve a script by ID
      description: Retrieves a specific script document from the Opensearch index by its ID.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{scriptId}
        httpMethod: GET
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}:
    put:
      summary: Update a script by ID
      description: Updates an existing script document in the Opensearch index.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{scriptId}
        httpMethod: PUT
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}:
    delete:
      summary: Delete a script by ID
      description: Deletes a script document from the Opensearch index by its ID.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{scriptId}
        httpMethod: DELETE
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}/sections/_search:
    post:
      summary: Retrieve sections of a script
      description: Queries the Opensearch index for sections linked to a specific script.
      operationId: searchSections
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose sections are being queried.
          schema:
            type: string
      requestBody:
        description: The Opensearch query object for sections.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}/sections/_doc:
    post:
      summary: Create a section for a script
      description: Adds a new section document to the Opensearch index linked to a specific script.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    get:
      summary: Retrieve a section by ID
      description: Retrieves a specific section document from the Opensearch index by its ID.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{sectionId}
        httpMethod: GET
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    put:
      summary: Update a section by ID
      description: Updates an existing section document in the Opensearch index.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{sectionId}
        httpMethod: PUT
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    delete:
      summary: Delete a section by ID
      description: Deletes a section document from the Opensearch index by its ID.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{sectionId}
        httpMethod: DELETE
        passthroughBehavior: when_no_match
        connectionType: INTERNET
components:
  schemas: {}
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
x-amazon-apigateway-endpoint-configuration:
  types:
    - REGIONAL
x-amazon-apigateway-cors:
  allowOrigins:
    - "*"
  allowMethods:
    - GET
    - POST
    - OPTIONS
  allowHeaders:
    - Content-Type
    - X-Amz-Date
    - Authorization
    - X-Api-Key
    - X-Amz-Security-Token
  maxAge: 600
security:
  - ApiKeyAuth: []
```

### **2.3. Key Sections Explained**

- **AWS API Gateway Extensions:**
  - **`x-amazon-apigateway-integration`:** Specifies the backend integration for each path, using placeholders for sensitive information like the Opensearch domain.
  - **`x-amazon-apigateway-endpoint-configuration`:** Configures the API Gateway as a Regional endpoint.
  - **`x-amazon-apigateway-cors`:** Defines CORS settings to allow cross-origin requests.
  - **`x-amazon-apigateway-auth`:** Specifies the authorization method, here using API Key Authentication.

- **Security with Placeholders:**
  - **Environment Variables:** Use environment variables or secure storage like AWS Secrets Manager or Parameter Store to inject values for placeholders at runtime.
  - **Example Placeholder:** `${OPENSEARCH_DOMAIN}` is used instead of hardcoding the domain, and the actual value is injected during deployment.

- **Paths Section:**
  - **`/scripts/_search`:** Integration with Opensearch to retrieve all script documents.
  - **`/scripts/_doc`:** Integration with Opensearch to create a new script document.
  - **`/scripts/_doc/{scriptId}`:**
    - **GET:** Retrieves a specific script document by its ID.
    - **PUT:** Updates a specific script document by its ID.
    - **DELETE:** Deletes a specific script document by its ID.
  - **`/scripts/_doc/{scriptId}/sections/_search`:** Integration with Opensearch to retrieve sections linked to a specific script.
  - **`/scripts/_doc/{scriptId}/sections/_doc`:** Integration with Opensearch to create, retrieve, update, and delete section documents linked to a script.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Search for scripts"
  - **API Call:** `POST /scripts/_search`
  - **Operation:** The GPT model generates a query based on user input and interacts directly with Opensearch to retrieve matching script documents.

- **Action:** "Create a script"
  - **API Call:** `POST /scripts/_doc`
  - **Operation:** The GPT model sends a script creation request to Opensearch, which then stores the new document in the `scripts` index.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification, which includes placeholders for sensitive information.
- **Secret Management:** Use AWS Secrets Manager, Parameter Store, or environment variables to manage and inject sensitive information at runtime.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`) and ensure that the integrations and settings are functioning as expected with secure configuration.

### **5. Conclusion**

This comprehensive OpenAPI specification integrates Opensearch REST API paths with AWS API Gateway extensions while ensuring that sensitive information is securely managed. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway, without exposing secrets.

This method completes the series of OpenAPI specifications for the FountainAI services, ensuring consistency, security, and reliability across the entire system while simplifying the API management process.
