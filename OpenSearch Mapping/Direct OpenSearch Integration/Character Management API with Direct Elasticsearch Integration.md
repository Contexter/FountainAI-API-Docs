# **Character Management API with Direct Elasticsearch Integration**

## **Overview**

This document provides a comprehensive guide for the Character Management API in FountainAI, directly integrating Elasticsearch REST API paths into the OpenAPI specification. This approach ensures straightforward interactions with Elasticsearch, eliminating the need for an additional mapping layer.

## **1. Objective**

- **Direct Integration:** Use Elasticsearch REST API paths directly in the OpenAPI specification.
- **Unified Configuration:** Utilize the OpenAPI files for GPT model actions and AWS API Gateway configurations.
- **Maintain Expressivity:** Preserve the API's detailed structure while aligning it directly with Elasticsearch.

## **2. Character Management API: Full OpenAPI Specification**

Below is the full OpenAPI specification for the Character Management Service, configured to directly interact with Elasticsearch.

```yaml
openapi: 3.0.0
info:
  title: Character Management API
  description: API for managing characters in the FountainAI system, integrated directly with Elasticsearch.
  version: 1.0.0
servers:
  - url: https://api.characters.fountainai.com
    description: FountainAI Character Management API Server
paths:
  /characters/_search:
    post:
      summary: Retrieve all characters
      description: Queries the Elasticsearch index to retrieve all character documents.
      operationId: searchCharacters
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
                  description: The Elasticsearch Query DSL to filter characters.
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
  /characters/_doc:
    post:
      summary: Create a new character
      description: Adds a new character document to the Elasticsearch index.
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
  /characters/_doc/{characterId}:
    get:
      summary: Retrieve a character by ID
      description: Retrieves a specific character document from the Elasticsearch index by its ID.
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
  /characters/_doc/{characterId}:
    put:
      summary: Update a character by ID
      description: Updates an existing character document in the Elasticsearch index.
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
  /characters/_doc/{characterId}:
    delete:
      summary: Delete a character by ID
      description: Deletes a character document from the Elasticsearch index by its ID.
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
  /characters/_doc/{characterId}/paraphrases/_search:
    post:
      summary: Retrieve paraphrases for a character
      description: Queries the Elasticsearch index for paraphrases linked to a specific character.
      operationId: searchParaphrases
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrases are being queried.
          schema:
            type: string
      requestBody:
        description: The Elasticsearch query object for paraphrases.
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
  /characters/_doc/{characterId}/paraphrases/_doc:
    post:
      summary: Create a paraphrase for a character
      description: Adds a new paraphrase document to the Elasticsearch index linked to a specific character.
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
  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    get:
      summary: Retrieve a paraphrase by ID
      description: Retrieves a specific paraphrase document from the Elasticsearch index by its ID.
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
  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    put:
      summary: Update a paraphrase by ID
      description: Updates an existing paraphrase document in the Elasticsearch index.
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
  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    delete:
      summary: Delete a paraphrase by ID
      description: Deletes a paraphrase document from the Elasticsearch index by its ID.
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
  - **URL:** `https://api.characters.fountainai.com` — This server section points directly to the FountainAI Character Management API server, ensuring that all requests are routed correctly.

- **Paths Section:**
  - **`/characters/_search`:** Queries the Elasticsearch index for characters. The operation expects a query object following Elasticsearch's query DSL.
  - **`/characters/_doc`:** Creates a new character document in Elasticsearch.
  - **`/characters/_doc/{characterId}`:**
    - **GET:** Retrieves a specific character document by its ID.
    - **PUT:** Updates a specific character document by its ID.
    - **DELETE:** Deletes a specific character document by its ID.
  - **`/characters/_doc/{characterId}/paraphrases/_search`:** Queries Elasticsearch for paraphrases linked to a specific character.
  - **`/characters/_doc/{characterId}/paraphrases/_doc`:** Creates, retrieves, updates, and deletes paraphrase documents linked to a character in Elasticsearch.

- **Security Schemes:**
  - **API Key Authentication:** The API requires an API key for all operations, passed in the `X-API-Key` header.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Search for characters"
  - **API Call:** `POST /characters/_search`
  - **Operation:** The GPT model generates a query based on user input and interacts directly with Elasticsearch to retrieve matching character documents.

- **Action:** "Create a character"
  - **API Call:** `POST /characters/_doc`
  - **Operation:** The GPT model sends a character creation request to Elasticsearch, which then stores the new document in the `characters` index.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification.
- **Security Setup:** AWS API Gateway will enforce API key authentication as defined in the OpenAPI specification.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`), making it live and accessible via the specified URL.

### **5. Conclusion**

This comprehensive OpenAPI specification directly integrates Elasticsearch REST API paths into the Character Management API for FountainAI. It ensures that all interactions with Elasticsearch are direct and secure, without the need for an additional mapping layer. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway.

This method can be extended to other FountainAI services, ensuring consistency and reliability across the entire system while simplifying the API management process.