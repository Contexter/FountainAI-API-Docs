# **Central Sequence Service API with Direct Elasticsearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Central Sequence Service within the FountainAI system. The API directly integrates with Elasticsearch, ensuring efficient and straightforward management of sequence numbers.

## **1. Objective**

- **Direct Integration:** Use Elasticsearch REST API paths directly in the OpenAPI specification for managing sequence numbers.
- **Unified Configuration:** Utilize this specification for configuring GPT model actions and AWS API Gateway.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Elasticsearch.

## **2. Central Sequence Service API: Full OpenAPI Specification**

Below is the full OpenAPI specification for the Central Sequence Service, configured for direct interaction with Elasticsearch.

```yaml
openapi: 3.0.0
info:
  title: Central Sequence Service API
  description: API for managing sequence numbers within the FountainAI system, integrated directly with Elasticsearch.
  version: 1.0.0
servers:
  - url: https://api.sequences.fountainai.com
    description: FountainAI Central Sequence Service API Server
paths:
  /sequences/_doc:
    post:
      summary: Generate a new sequence number
      description: Generates a new sequence number and stores it in the Elasticsearch index.
      operationId: createSequence
      requestBody:
        description: Data related to the sequence number to be generated.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                elementType:
                  type: string
                  example: "script"
                elementId:
                  type: string
                  example: "abc123"
                sequenceNumber:
                  type: integer
                  example: 1
      responses:
        '201':
          description: Sequence number created successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the created sequence document
                  result:
                    type: string
                    example: "created"
  /sequences/_search:
    post:
      summary: Retrieve sequence numbers
      description: Queries the Elasticsearch index to retrieve sequence numbers for specific elements.
      operationId: searchSequences
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
                  description: The Elasticsearch Query DSL to filter sequences.
      responses:
        '200':
          description: A list of sequences
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    elementType:
                      type: string
                    elementId:
                      type: string
                    sequenceNumber:
                      type: integer
  /sequences/_bulk:
    post:
      summary: Reorder sequence numbers
      description: Reorders sequence numbers for elements and updates them in the Elasticsearch index using bulk operations.
      operationId: reorderSequences
      requestBody:
        description: Bulk data to reorder sequence numbers.
        required: true
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  elementId:
                    type: string
                  newSequence:
                    type: integer
      responses:
        '200':
          description: Sequence numbers reordered successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  result:
                    type: string
                    example: "success"
  /sequences/_doc/{sequenceId}/_update:
    post:
      summary: Create a new version of a sequence number
      description: Creates a new version of an existing sequence number in the Elasticsearch index.
      operationId: createSequenceVersion
      parameters:
        - name: sequenceId
          in: path
          required: true
          description: The ID of the sequence whose version is being created.
          schema:
            type: string
      requestBody:
        description: Data related to the new version of the sequence number.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                elementType:
                  type: string
                  example: "script"
                elementId:
                  type: string
                  example: "abc123"
                versionNumber:
                  type: integer
                  example: 2
      responses:
        '200':
          description: Sequence version created successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  _id:
                    type: string
                    description: ID of the created sequence version document
                  result:
                    type: string
                    example: "created"
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
  - **URL:** `https://api.sequences.fountainai.com` — This server section points directly to the FountainAI Central Sequence Service API server.

- **Paths Section:**
  - **`/sequences/_doc`:** Generates a new sequence number and stores it in Elasticsearch.
  - **`/sequences/_search`:** Queries Elasticsearch to retrieve sequence numbers for specific elements. The operation expects a query object using Elasticsearch's query DSL.
  - **`/sequences/_bulk`:** Reorders sequence numbers for elements and updates them in Elasticsearch using bulk operations.
  - **`/sequences/_doc/{sequenceId}/_update`:** Creates a new version of an existing sequence number in Elasticsearch.

- **Security Schemes:**
  - **API Key Authentication:** The API requires an API key for all operations, passed in the `X-API-Key` header.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Generate a sequence number"
  - **API Call:** `POST /sequences/_doc`
  - **Operation:** The GPT model generates a new sequence number for a specific element and stores it in Elasticsearch.

- **Action:** "Reorder sequence numbers"
  - **API Call:** `POST /sequences/_bulk`
  - **Operation:** The GPT model sends a request to reorder sequence numbers for specific elements using bulk operations in Elasticsearch.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification.
- **Security Setup:** AWS API Gateway will enforce API key authentication as defined in the OpenAPI specification.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`), making it live and accessible via the specified URL.

### **5. Conclusion**

This comprehensive OpenAPI specification directly integrates Elasticsearch REST API paths into the Central Sequence Service API for FountainAI. It ensures that all interactions with Elasticsearch are direct and secure, without the need for an additional mapping layer. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway.

This method completes the series of OpenAPI specifications for the FountainAI services, ensuring consistency and reliability across the entire system while simplifying the API management process.