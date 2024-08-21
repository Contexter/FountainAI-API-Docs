# **Session and Context Management API with Direct Elasticsearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Session and Context Management Service within the FountainAI system. The API directly integrates with Elasticsearch, ensuring straightforward and efficient interactions with the backend.

## **1. Objective**

- **Direct Integration:** Use Elasticsearch REST API paths directly in the OpenAPI specification for managing sessions and context data.
- **Unified Configuration:** Utilize this specification for configuring GPT model actions and AWS API Gateway.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Elasticsearch.

## **2. Session and Context Management API: Full OpenAPI Specification**

Below is the full OpenAPI specification for the Session and Context Management Service, configured for direct interaction with Elasticsearch.

```yaml
openapi: 3.0.0
info:
  title: Session and Context Management API
  description: API for managing sessions and contextual data in the FountainAI system, integrated directly with Elasticsearch.
  version: 1.0.0
servers:
  - url: https://api.sessions.fountainai.com
    description: FountainAI Session and Context Management API Server
paths:
  /sessions/_search:
    post:
      summary: Retrieve all sessions
      description: Queries the Elasticsearch index to retrieve all session documents.
      operationId: searchSessions
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
                  description: The Elasticsearch Query DSL to filter sessions.
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
  /sessions/_doc:
    post:
      summary: Create a new session
      description: Adds a new session document to the Elasticsearch index.
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
  /sessions/_doc/{sessionId}:
    get:
      summary: Retrieve a session by ID
      description: Retrieves a specific session document from the Elasticsearch index by its ID.
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
  /sessions/_doc/{sessionId}:
    delete:
      summary: Delete a session by ID
      description: Deletes a session document from the Elasticsearch index by its ID.
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
  /contexts/_search:
    post:
      summary: Retrieve all contexts
      description: Queries the Elasticsearch index to retrieve all context documents.
      operationId: searchContexts
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
                  description: The Elasticsearch Query DSL to filter contexts.
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
  /contexts/_doc:
    post:
      summary: Create a new context
      description: Adds a new context document to the Elasticsearch index.
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
  /contexts/_doc/{contextId}:
    get:
      summary: Retrieve a context by ID
      description: Retrieves a specific context document from the Elasticsearch index by its ID.
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
  /contexts/_doc/{contextId}:
    delete:
      summary: Delete a context by ID
      description: Deletes a context document from the Elasticsearch index by its ID.
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
  - **URL:** `https://api.sessions.fountainai.com` — This server section points directly to the FountainAI Session and Context Management API server.

- **Paths Section:**
  - **`/sessions/_search`:** Queries the Elasticsearch index for sessions. The operation expects a query object using Elasticsearch's query DSL.
  - **`/sessions/_doc`:** Creates a new session document in Elasticsearch.
  - **`/sessions/_doc/{sessionId}`:**
    - **GET:** Retrieves a specific session document by its ID.
    - **DELETE:** Deletes a specific session document by its ID.
  - **`/contexts/_search`:** Queries the Elasticsearch index for contexts. The operation expects a query object using Elasticsearch's query DSL.
  - **`/contexts/_doc`:** Creates a new context document in Elasticsearch.
  - **`/contexts/_doc/{contextId}`:**
    - **GET:** Retrieves a specific context document by its ID.
    - **DELETE:** Deletes a specific context document by its ID.

- **Security Schemes:**
  - **API Key Authentication:** The API requires an API key for all operations, passed in the `X-API-Key` header.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Search for sessions"
  - **API Call:** `POST /sessions/_search`
  - **Operation:** The GPT model generates a query based on user input and interacts directly with Elasticsearch to retrieve matching session documents.

- **Action:** "Create a session"
  - **API Call:** `POST /sessions/_doc`
  - **Operation:** The GPT model sends a session creation request to Elasticsearch, which then stores the new document in the `sessions` index.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification.
- **Security Setup:** AWS API Gateway will enforce API key authentication as defined in the OpenAPI specification.


- **Deployment:** Deploy the API to a specific stage (e.g., `prod`), making it live and accessible via the specified URL.

### **5. Conclusion**

This comprehensive OpenAPI specification directly integrates Elasticsearch REST API paths into the Session and Context Management API for FountainAI. It ensures that all interactions with Elasticsearch are direct and secure, without the need for an additional mapping layer. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway.

This method can be extended to other FountainAI services, ensuring consistency and reliability across the entire system while simplifying the API management process.