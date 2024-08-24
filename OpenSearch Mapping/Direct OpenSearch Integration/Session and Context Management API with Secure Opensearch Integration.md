# **Session and Context Management API with Secure Opensearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Session and Context Management Service within the FountainAI system. The API integrates directly with Opensearch, ensuring efficient and secure interactions with the backend.

## **1. Objective**

- **Direct Integration:** Use Opensearch REST API paths directly in the OpenAPI specification for managing sessions and context data.
- **Secure Configuration:** Implement best practices to securely manage sensitive information, such as Opensearch domain and API keys.
- **AWS API Gateway Configuration:** Leverage AWS-specific extensions for integration, security, and deployment.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Opensearch and AWS.

## **2. Session and Context Management API: Full OpenAPI Specification**

### **2.1. Handling Secrets Securely**

Sensitive information such as Opensearch domain endpoints, API keys, and other credentials should not be hardcoded in the OpenAPI document. Instead, placeholders or environment variable references should be used, with the actual values injected during deployment or retrieved at runtime.

#### **Example Configuration:**
- **Opensearch Domain:** Use a placeholder or environment variable reference (`${OPENSEARCH_DOMAIN}`) instead of hardcoding the domain name.
- **AWS Secrets Manager or Parameter Store:** Store sensitive information in AWS Secrets Manager or Parameter Store and retrieve them at runtime.

### **2.2. OpenAPI Specification**

Below is the OpenAPI specification for the Session and Context Management Service, configured for secure interaction with Opensearch and optimized for AWS API Gateway.

```yaml
openapi: 3.1.0
info:
  title: Session and Context Management API
  description: API for managing sessions and contextual data in the FountainAI system, integrated directly with Opensearch.
  version: 1.0.0
servers:
  - url: https://api.sessions.fountainai.com
    description: FountainAI Session and Context Management API Server
paths:
  /sessions/_search:
    post:
      summary: Retrieve all sessions
      description: Queries the Opensearch index to retrieve all session documents.
      operationId: searchSessions
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
                  description: The Opensearch Query DSL to filter sessions.
      responses:
        '200':
          description: A list of sessions
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    characterId:
                      type: string
                    sequence:
                      type: integer
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /sessions/_doc:
    post:
      summary: Create a new session
      description: Adds a new session document to the Opensearch index.
      operationId: createSession
      requestBody:
        description: Session data to be added.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                characterId:
                  type: string
                  example: "abc123"
                sequence:
                  type: integer
                  example: 1
      responses:
        '201':
          description: Session created successfully
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
  /sessions/_doc/{sessionId}:
    get:
      summary: Retrieve a session by ID
      description: Retrieves a specific session document from the Opensearch index by its ID.
      operationId: getSessionById
      parameters:
        - name: sessionId
          in: path
          required: true
          description: The ID of the session to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Session document retrieved
          content:
            application/json:
              schema:
                type: object
                properties:
                  id:
                    type: string
                  characterId:
                    type: string
                  sequence:
                    type: integer
        '404':
          description: Session not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{sessionId}
        httpMethod: GET
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /sessions/_doc/{sessionId}:
    delete:
      summary: Delete a session by ID
      description: Deletes a session document from the Opensearch index by its ID.
      operationId: deleteSessionById
      parameters:
        - name: sessionId
          in: path
          required: true
          description: The ID of the session to delete.
          schema:
            type: string
      responses:
        '200':
          description: Session deleted successfully
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
          description: Session not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{sessionId}
        httpMethod: DELETE
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /contexts/_search:
    post:
      summary: Retrieve all contexts
      description: Queries the Opensearch index to retrieve all context documents.
      operationId: searchContexts
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
                  description: The Opensearch Query DSL to filter contexts.
      responses:
        '200':
          description: A list of contexts
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    characterId:
                      type: string
                    sequence:
                      type: integer
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /contexts/_doc:
    post:
      summary: Create a new context
      description: Adds a new context document to the Opensearch index.
      operationId: createContext
      requestBody:
        description: Context data to be added.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                characterId:
                  type: string
                  example: "abc123"
                sequence:
                  type: integer
                  example: 1
      responses:
        '201':
          description: Context created successfully
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
  /contexts/_doc/{contextId}:
    get:
      summary: Retrieve a context by ID
      description: Retrieves a specific context document from the Opensearch index by its ID.
      operationId: getContextById
      parameters:
        - name: contextId
          in: path
          required: true
          description: The ID of the context to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Context document retrieved
          content:
            application/json:
              schema:
                type: object
                properties:
                  id:
                    type: string
                  characterId:
                    type: string
                  sequence:
                    type: integer
        '404':
          description: Context not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{contextId}
        httpMethod: GET
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /contexts/_doc/{contextId}:
    delete:
      summary: Delete a context by ID
      description: Deletes a context document from the Opensearch index by its ID.
      operationId: deleteContextById
      parameters:
        - name: contextId
          in: path
          required: true
          description: The ID of the context to delete.
          schema:
            type: string
      responses:
        '200':
          description: Context deleted successfully
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
          description: Context not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{contextId}
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
  - **`/sessions/_search`:** Integration with Opensearch to retrieve all session documents.
  - **`/sessions/_doc`:** Integration with Opensearch to create a new session document.
  - **`/sessions/_doc/{sessionId}`:**
    - **GET:** Retrieves a specific session document by its ID.
    - **DELETE:** Deletes a specific session document by its ID.
  - **`/contexts/_search`:** Integration with Opensearch to retrieve all context documents.
  - **`/contexts/_doc`:** Integration with Opensearch to create a new context document.
  - **`/contexts/_doc/{contextId}`:**
    - **GET:** Retrieves a specific context document by its ID.
    - **DELETE:** Deletes a specific context document by its ID.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Search for sessions"
  - **API Call:** `POST /sessions/_search`
  - **Operation:** The GPT model generates a query based on user input and interacts directly with Opensearch to retrieve matching session documents.

- **Action:** "Create a session"
  - **API Call:** `POST /sessions/_doc`
  - **Operation:** The GPT model sends a session creation request to Opensearch, which then stores the new document in the `sessions` index.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification, which includes placeholders for sensitive information.
- **Secret Management:** Use AWS Secrets Manager, Parameter Store, or environment variables to manage and inject sensitive information at runtime.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`) and ensure that the integrations and settings are functioning as expected with secure configuration.

### **5. Conclusion**

This comprehensive OpenAPI specification integrates Opensearch REST API paths with AWS API Gateway extensions while ensuring that sensitive information is securely managed. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway, without exposing secrets.

This method completes the series of OpenAPI specifications for the FountainAI services, ensuring consistency, security, and reliability across the entire system while simplifying the API management process.
