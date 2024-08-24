
# **Story Factory API with Direct Elasticsearch Integration**

## **Overview**

This document provides a detailed OpenAPI specification for the Story Factory Service within the FountainAI system. The API directly integrates with Elasticsearch, ensuring efficient and straightforward interactions with the backend to assemble and retrieve complete stories.

## **1. Objective**

- **Direct Integration:** Use Elasticsearch REST API paths directly in the OpenAPI specification for managing and retrieving story components.
- **Unified Configuration:** Utilize this specification for configuring GPT model actions and AWS API Gateway.
- **Maintain Expressivity:** Preserve the detailed structure of the API while aligning it directly with Elasticsearch.

## **2. Story Factory API: Full OpenAPI Specification**

Below is the full OpenAPI specification for the Story Factory Service, configured for direct interaction with Elasticsearch.

```yaml
openapi: 3.0.0
info:
  title: Story Factory API
  description: API for assembling and retrieving complete stories in the FountainAI system, integrated directly with Elasticsearch.
  version: 1.0.0
servers:
  - url: https://api.stories.fountainai.com
    description: FountainAI Story Factory API Server
paths:
  /stories/{scriptId}/_search:
    post:
      summary: Retrieve a complete story
      description: Assembles a complete story by querying and combining related components (characters, actions, spoken words, sections) for a specific script from the Elasticsearch index.
      operationId: searchCompleteStory
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose complete story is being assembled.
          schema:
            type: string
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
                  description: The Elasticsearch Query DSL to filter and retrieve story components.
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
  /stories/sections/{sectionId}/_doc:
    get:
      summary: Retrieve a specific section of a story by ID
      description: Retrieves a specific section of a story by its ID from the Elasticsearch index.
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
  /stories/search/_search:
    post:
      summary: Search for stories or story components
      description: Searches for stories or specific story components (like characters, actions, sections) within the Elasticsearch index based on provided criteria.
      operationId: searchStoryComponents
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
                  description: The Elasticsearch Query DSL to filter stories or components.
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
  /stories/orchestration/{scriptId}/_search:
    post:
      summary: Retrieve orchestration data for a script
      description: Retrieves orchestration data (e.g., music, sound cues) linked to a specific script from the Elasticsearch index.
      operationId: searchOrchestrationData
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose orchestration data is being retrieved.
          schema:
            type: string
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
                  description: The Elasticsearch Query DSL to filter orchestration data.
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
  - **URL:** `https://api.stories.fountainai.com` — This server section points directly to the FountainAI Story Factory API server.

- **Paths Section:**
  - **`/stories/{scriptId}/_search`:** Assembles a complete story by querying and combining related components for a specific script from Elasticsearch. The operation expects a query object using Elasticsearch's query DSL.
  - **`/stories/sections/{sectionId}/_doc`:** Retrieves a specific section of a story by its ID from Elasticsearch.
  - **`/stories/search/_search`:** Searches for stories or specific story components (like characters, actions, sections) within Elasticsearch based on provided criteria.
  - **`/stories/orchestration/{scriptId}/_search`:** Retrieves orchestration data linked to a specific script from Elasticsearch.

- **Security Schemes:**
  - **API Key Authentication:** The API requires an API key for all operations, passed in the `X-API-Key` header.

### **3. Using This Specification for GPT Model Actions**

- **Action:** "Retrieve a complete story"
  - **API Call:** `POST /stories/{scriptId}/_search`
  - **Operation:** The GPT model generates a query to retrieve all relevant components (characters, actions, sections) for a specific script and assembles them into a complete story.

- **Action:** "Search for stories or components"
  - **API Call:** `POST /stories/search/_search`
  - **Operation:** The GPT model sends a search query to Elasticsearch to find stories or specific components based on the user’s criteria.

### **4. Using This Specification for AWS API Gateway**

- **Import the OpenAPI Specification:** Use the AWS API Gateway console or CLI to import the OpenAPI specification.
- **Security Setup:** AWS API Gateway will enforce API key authentication as defined in the OpenAPI specification.
- **Deployment:** Deploy the API to a specific stage (e.g., `prod`), making it live and accessible via the specified URL.

### **5. Conclusion**

This comprehensive OpenAPI specification directly integrates Elasticsearch REST API paths into the Story Factory API for FountainAI. It ensures that all interactions with Elasticsearch are direct and secure, without the need for an additional mapping layer. This approach maintains the expressivity of the API, making it easier to manage, configure, and deploy across various platforms, including GPT models and AWS API Gateway.

This method can be extended to other FountainAI services, ensuring consistency and reliability across the entire system while simplifying the API management process.