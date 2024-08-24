# **Character Management API with Secure Opensearch Integration**

## **Overview**

This document provides a comprehensive guide for the Character Management API in FountainAI, integrating directly with Opensearch via secure configurations and AWS API Gateway extensions. This approach ensures straightforward interactions with Opensearch while maintaining best practices for security and deployment.

## **1. Objective**

- **Direct Integration:** Use Opensearch REST API paths directly in the OpenAPI specification.
- **Secure Configuration:** Implement best practices to securely manage sensitive information, such as Opensearch domain and API keys.
- **AWS API Gateway Configuration:** Leverage AWS-specific extensions for integration, security, and deployment.
- **Maintain Expressivity:** Preserve the API's detailed structure while aligning it directly with Opensearch and AWS.

## **2. Character Management API: Full OpenAPI Specification**

### **2.1. Handling Secrets Securely**

Sensitive information such as Opensearch domain endpoints, API keys, and other credentials should not be hardcoded in the OpenAPI document. Instead, placeholders or environment variable references should be used, with the actual values injected during deployment or retrieved at runtime.

#### **Example Configuration:**
- **Opensearch Domain:** Use a placeholder or environment variable reference (`${OPENSEARCH_DOMAIN}`) instead of hardcoding the domain name.
- **AWS Secrets Manager or Parameter Store:** Store sensitive information in AWS Secrets Manager or Parameter Store and retrieve them at runtime.

### **2.2. OpenAPI Specification**

Below is the OpenAPI specification for the Character Management Service, configured for secure interaction with Opensearch and optimized for AWS API Gateway.

```yaml
openapi: 3.1.0
info:
  title: Character Management API
  description: API for managing characters in the FountainAI system, integrated directly with Opensearch.
  version: 1.0.0
servers:
  - url: https://api.characters.fountainai.com
    description: FountainAI Character Management API Server
paths:
  /characters/_search:
    post:
      summary: Retrieve all characters
      description: Queries the Opensearch index to retrieve all character documents.
      operationId: searchCharacters
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
                  description: The Opensearch Query DSL to filter characters.
      responses:
        '200':
          description: A list of characters
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    name:
                      type: string
                    description:
                      type: string
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc:
    post:
      summary: Create a new character
      description: Adds a new character document to the Opensearch index.
      operationId: createCharacter
      requestBody:
        description: Character data to be added.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name:
                  type: string
                  example: "John Doe"
                description:
                  type: string
                  example: "A brave warrior"
      responses:
        '201':
          description: Character created successfully
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
  /characters/_doc/{characterId}:
    get:
      summary: Retrieve a character by ID
      description: Retrieves a specific character document from the Opensearch index by its ID.
      operationId: getCharacterById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Character document retrieved
          content:
            application/json:
              schema:
                type: object
                properties:
                  id:
                    type: string
                  name:
                    type: string
                  description:
                    type: string
        '404':
          description: Character not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}
        httpMethod: GET
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc/{characterId}:
    put:
      summary: Update a character by ID
      description: Updates an existing character document in the Opensearch index.
      operationId: updateCharacterById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to update.
          schema:
            type: string
      requestBody:
        description: The new character data.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name:
                  type: string
                description:
                  type: string
      responses:
        '200':
          description: Character updated successfully
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
          description: Character not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}
        httpMethod: PUT
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc/{characterId}:
    delete:
      summary: Delete a character by ID
      description: Deletes a character document from the Opensearch index by its ID.
      operationId: deleteCharacterById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to delete.
          schema:
            type: string
      responses:
        '200':
          description: Character deleted successfully
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
          description: Character not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}
        httpMethod: DELETE
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc/{characterId}/paraphrases/_search:
    post:
      summary: Retrieve paraphrases for a character
      description: Queries the Opensearch index for paraphrases linked to a specific character.
      operationId: searchParaphrases
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrases are being queried.
          schema:
            type: string
      requestBody:
        description: The Opensearch query object for paraphrases.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                query:
                  type: object
                  description: The query DSL to filter paraphrases.
      responses:
        '200':
          description: A list of paraphrases
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    paraphraseId:
                      type: string
                    text:
                      type: string
                    commentary:
                      type: string
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}/paraphrases/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc/{characterId}/paraphrases/_doc:
    post:
      summary: Create a paraphrase for a character
      description: Adds a new paraphrase document to the Opensearch index linked to a specific character.
      operationId: createParaphrase
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to which the paraphrase is linked.
          schema:
            type: string
      requestBody:
        description: Paraphrase data to be added.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                text:
                  type: string
                  example: "A wise saying"
                commentary:
                  type: string
                  example: "Commentary on the paraphrase"
      responses:
        '201':
          description: Paraphrase created successfully
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
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}/paraphrases/_doc
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    get:
      summary: Retrieve a paraphrase by ID
      description: Retrieves a specific paraphrase document from the Opensearch index by its ID.
      operationId: getParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrase is being retrieved.
          schema:
            type: string
        - name: paraphraseId
          in: path
          required: true
          description: The ID of the paraphrase to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Paraphrase document retrieved
          content:
            application/json:
              schema:
                type: object
                properties:
                  paraphraseId:
                    type: string
                  text:
                    type: string
                  commentary:
                    type: string
        '404':
          description: Paraphrase not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}/paraphrases/_doc/{paraphraseId}
        httpMethod: GET
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    put:
      summary: Update a paraphrase by ID
      description: Updates an existing paraphrase document in the Opensearch index.
      operationId: updateParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrase is being updated.
          schema:
            type: string
        - name: paraphraseId
          in: path
          required: true
          description: The ID of the paraphrase to update.
          schema:
            type: string
      requestBody:
        description: The new paraphrase data.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                text:
                  type: string
                commentary:
                  type: string
      responses:
        '200':
          description: Paraphrase updated successfully
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
          description: Paraphrase not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}/paraphrases/_doc/{paraphraseId}
        httpMethod: PUT
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    delete:
      summary: Delete a paraphrase by ID
      description: Deletes a paraphrase document from the Opensearch index by its ID.
      operationId: deleteParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrase is being deleted.
          schema:
            type: string
        - name: paraphraseId
          in: path
          required: true
          description: The ID of the paraphrase to delete.
          schema:
            type: string
      responses:
        '200':
          description: Paraphrase deleted successfully
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
          description: Paraphrase not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{characterId}/paraphrases/_doc/{paraphraseId}
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
  - **`/characters/_search`:** Integration with Opensearch to retrieve all character documents.
  - **`/characters/_doc`:** Integration with Opensearch to create a new character document.
  - **`/characters/_doc/{characterId}`:**
    - **GET:** Retrieves a specific character document by its ID.
    - **PUT:** Updates a specific character document by its ID.
    - **DELETE:** Deletes a specific character document by its ID.
  - **`/characters/_doc/{characterId}/paraphrases/_search`:** Integration with Opensearch to retrieve paraphrases linked to a specific character.
  - **`/characters/_doc/{characterId}/paraphrases/_doc`:** Creates, retrieves, updates, and deletes paraphrase documents linked to a character in Opensearch.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Search for characters"
  - **API Call:** `POST /characters/_search`
  - **Operation:** The GPT model generates a query based on user input and interacts directly with Opensearch to retrieve matching character documents.

- **Action:** "Create a character"
  - **API Call:** `POST /characters/_doc`
  - **Operation:** The GPT model sends a character creation request to Opensearch, which then stores the new document in the `characters` index.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification, which includes placeholders for sensitive information.
- **Secret Management:** Use AWS Secrets Manager, Parameter Store, or environment variables to manage and inject sensitive information at runtime.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`) and ensure that the integrations and settings are functioning as expected with secure configuration.

### **5. Conclusion**

This comprehensive OpenAPI specification integrates Opensearch REST API paths with AWS API Gateway extensions while ensuring that sensitive information is securely managed. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway, without exposing secrets.

This method completes the series of OpenAPI specifications for the FountainAI services, ensuring consistency, security, and reliability across the entire system while simplifying the API management process.

