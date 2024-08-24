

# **Central Sequence Service API with Secure Opensearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Central Sequence Service within the FountainAI system. The API directly integrates with Opensearch, ensuring efficient and secure management of sequence numbers. Additionally, this document incorporates AWS API Gateway-specific extensions and best practices for securely handling sensitive information.

## **1. Objective**

- **Direct Integration:** Use Opensearch REST API paths directly in the OpenAPI specification for managing sequence numbers.
- **Secure Configuration:** Implement best practices to securely manage sensitive information such as Opensearch domains, API keys, and other secrets.
- **AWS API Gateway Configuration:** Leverage AWS-specific extensions for integration, security, and deployment.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Opensearch and AWS.

## **2. Central Sequence Service API: Full OpenAPI Specification**

### **2.1. Handling Secrets Securely**

Sensitive information such as Opensearch domain endpoints, API keys, and other credentials should not be hardcoded in the OpenAPI document. Instead, placeholders or environment variable references should be used, with the actual values injected during deployment or retrieved at runtime.

#### **Example Configuration:**
- **Opensearch Domain:** Use a placeholder or environment variable reference (`${OPENSEARCH_DOMAIN}`) instead of hardcoding the domain name.
- **AWS Secrets Manager or Parameter Store:** Store sensitive information in AWS Secrets Manager or Parameter Store and retrieve them at runtime.

### **2.2. OpenAPI Specification**

Below is the OpenAPI specification for the Central Sequence Service, configured for secure interaction with Opensearch and optimized for AWS API Gateway.

```yaml
openapi: 3.1.0
info:
  title: Central Sequence Service API
  description: API for managing sequence numbers within the FountainAI system, integrated directly with Opensearch.
  version: 1.0.0
servers:
  - url: https://api.sequences.fountainai.com
    description: FountainAI Central Sequence Service API Server
paths:
  /sequences/_doc:
    post:
      summary: Generate a new sequence number
      description: Generates a new sequence number and stores it in the Opensearch index.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /sequences/_search:
    post:
      summary: Retrieve sequence numbers
      description: Queries the Opensearch index to retrieve sequence numbers for specific elements.
      operationId: searchSequences
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
                  description: The Opensearch Query DSL to filter sequences.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /sequences/_bulk:
    post:
      summary: Reorder sequence numbers
      description: Reorders sequence numbers for elements and updates them in the Opensearch index using bulk operations.
      operationId: reorderSequences
      requestBody:
        description: Bulk data to reorder sequence numbers.
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                elements:
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_bulk
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /sequences/_doc/{sequenceId}/_update:
    post:
      summary: Create a new version of a sequence number
      description: Creates a new version of an existing sequence number in the Opensearch index.
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
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{sequenceId}/_update
        httpMethod: POST
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
  - **`/sequences/_doc`:** Integration with Opensearch to generate a new sequence number, with the domain injected securely.
  - **`/sequences/_search`:** Integration with Opensearch to query and retrieve sequence numbers.
  - **`/sequences/_bulk`:** Integration with Opensearch for bulk reordering of sequence numbers.
  - **`/sequences/_doc/{sequenceId}/_update`:** Integration with Opensearch to create a new version of an existing sequence number.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Generate a sequence number"
  - **API Call:** `POST /sequences/_doc`
  - **Operation:** The GPT model generates a new sequence number for a specific element and stores it in Opensearch via the API Gateway, using secure domain injection.

- **Action:** "Reorder sequence numbers"
  - **API Call:** `POST /sequences/_bulk`
  - **Operation:** The GPT model sends a request to reorder sequence numbers using bulk operations in Opensearch via the API Gateway, with the domain securely injected.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to

 import the OpenAPI specification, which includes placeholders for sensitive information.
- **Secret Management:** Use AWS Secrets Manager, Parameter Store, or environment variables to manage and inject sensitive information at runtime.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`) and ensure that the integrations and settings are functioning as expected with secure configuration.

### **5. Conclusion**

This comprehensive OpenAPI specification integrates Opensearch REST API paths with AWS API Gateway extensions while ensuring that sensitive information is securely managed. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway, without exposing secrets.

This method completes the series of OpenAPI specifications for the FountainAI services, ensuring consistency, security, and reliability across the entire system while simplifying the API management process.

