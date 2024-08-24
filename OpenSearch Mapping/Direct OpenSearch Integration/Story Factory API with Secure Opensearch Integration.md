# **Story Factory API with Secure Opensearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Story Factory Service within the FountainAI system. The API integrates directly with Opensearch, ensuring efficient and secure interactions with the backend to assemble and retrieve complete stories.

## **1. Objective**

- **Direct Integration:** Use Opensearch REST API paths directly in the OpenAPI specification for managing and retrieving story components.
- **Secure Configuration:** Implement best practices to securely manage sensitive information, such as Opensearch domain and API keys.
- **AWS API Gateway Configuration:** Leverage AWS-specific extensions for integration, security, and deployment.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Opensearch and AWS.

## **2. Story Factory API: Full OpenAPI Specification**

### **2.1. Handling Secrets Securely**

Sensitive information such as Opensearch domain endpoints, API keys, and other credentials should not be hardcoded in the OpenAPI document. Instead, placeholders or environment variable references should be used, with the actual values injected during deployment or retrieved at runtime.

#### **Example Configuration:**
- **Opensearch Domain:** Use a placeholder or environment variable reference (`${OPENSEARCH_DOMAIN}`) instead of hardcoding the domain name.
- **AWS Secrets Manager or Parameter Store:** Store sensitive information in AWS Secrets Manager or Parameter Store and retrieve them at runtime.

### **2.2. OpenAPI Specification**

Below is the OpenAPI specification for the Story Factory Service, configured for secure interaction with Opensearch and optimized for AWS API Gateway.

```yaml
openapi: 3.1.0
info:
  title: Story Factory API
  description: API for assembling and retrieving complete stories in the FountainAI system, integrated directly with Opensearch.
  version: 1.0.0
servers:
  - url: https://api.stories.fountainai.com
    description: FountainAI Story Factory API Server
paths:
  /stories/{scriptId}/_search:
    post:
      summary: Retrieve a complete story
      description: Assembles a complete story by querying and combining related components (characters, actions, spoken words, sections) for a specific script from the Opensearch index.
      operationId: searchCompleteStory
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose complete story is being assembled.
          schema:
            type: string
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
                  description: The Opensearch Query DSL to filter and retrieve story components.
      responses:
        '200':
          description: A complete story
          content:
            application/json:
              schema:
                type: object
                properties:
                  scriptId:
                    type: string
                  title:
                    type: string
                  author:
                    type: string
                  sections:
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
                  characters:
                    type: array
                    items:
                      type: object
                      properties:
                        characterId:
                          type: string
                        name:
                          type: string
                        description:
                          type: string
                  actions:
                    type: array
                    items:
                      type: object
                      properties:
                        actionId:
                          type: string
                        description:
                          type: string
                  spokenWords:
                    type: array
                    items:
                      type: object
                      properties:
                        dialogueId:
                          type: string
                        text:
                          type: string
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /stories/sections/{sectionId}/_doc:
    get:
      summary: Retrieve a specific section of a story by ID
      description: Retrieves a specific section of a story by its ID from the Opensearch index.
      operationId: getStorySectionById
      parameters:
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: A story section
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
                  content:
                    type: string
        '404':
          description: Section not found
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_doc/{sectionId}
        httpMethod: GET
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /stories/search/_search:
    post:
      summary: Search for stories or story components
      description: Searches for stories or specific story components (like characters, actions, sections) within the Opensearch index based on provided criteria.
      operationId: searchStoryComponents
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
                  description: The Opensearch Query DSL to filter stories or components.
      responses:
        '200':
          description: Search results
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
                    type:
                      type: string
                    description:
                      type: string
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
        httpMethod: POST
        passthroughBehavior: when_no_match
        connectionType: INTERNET
  /stories/orchestration/{scriptId}/_search:
    post:
      summary: Retrieve orchestration data for a script
      description: Retrieves orchestration data (e.g., music, sound cues) linked to a specific script from the Opensearch index.
      operationId: searchOrchestrationData
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose orchestration data is being retrieved.
          schema:
            type: string
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
                  description: The Opensearch Query DSL to filter orchestration data.
      responses:
        '200':
          description: Orchestration data
          content:
            application/json:
              schema:
                type: object
                properties:
                  orchestrationId:
                    type: string
                  csoundFilePath:
                    type: string
                  lilyPondFilePath:
                    type: string
                  midiFilePath:
                    type: string
      x-amazon-apigateway-integration:
        type: http
        uri: ${OPENSEARCH_DOMAIN}/_search
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
  - **`/stories/{scriptId}/_search`:** Integration with Opensearch to retrieve and assemble a complete story by querying related components for a specific script.
  - **`/stories/sections/{sectionId}/_doc`:** Integration with Opensearch to retrieve a specific section of a story by its ID.
  - **`

/stories/search/_search`:** Integration with Opensearch to search for stories or specific story components based on provided criteria.
  - **`/stories/orchestration/{scriptId}/_search`:** Integration with Opensearch to retrieve orchestration data linked to a specific script.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Retrieve a complete story"
  - **API Call:** `POST /stories/{scriptId}/_search`
  - **Operation:** The GPT model generates a query to retrieve all relevant components (characters, actions, sections) for a specific script and assembles them into a complete story.

- **Action:** "Search for stories or components"
  - **API Call:** `POST /stories/search/_search`
  - **Operation:** The GPT model sends a search query to Opensearch to find stories or specific components based on the user’s criteria.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification, which includes placeholders for sensitive information.
- **Secret Management:** Use AWS Secrets Manager, Parameter Store, or environment variables to manage and inject sensitive information at runtime.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`) and ensure that the integrations and settings are functioning as expected with secure configuration.

### **5. Conclusion**

This comprehensive OpenAPI specification integrates Opensearch REST API paths with AWS API Gateway extensions while ensuring that sensitive information is securely managed. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway, without exposing secrets.

This method completes the series of OpenAPI specifications for the FountainAI services, ensuring consistency, security, and reliability across the entire system while simplifying the API management process.

---

This updated documentation ensures that sensitive information is handled securely and does not appear directly in the OpenAPI document. It provides a clear approach for managing and injecting secrets during deployment, maintaining the security and integrity of your API.