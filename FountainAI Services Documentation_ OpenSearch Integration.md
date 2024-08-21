# **FountainAI Services Documentation: OpenSearch Integration**

## **Overview**

FountainAI is a suite of services designed to manage and assemble various components of stories, including characters, actions, scripts, sessions, and more. Each service interacts with OpenSearch to store, retrieve, and manipulate data. This document provides a comprehensive overview of how each service's OpenAPI endpoints map to OpenSearch REST API operations, ensuring efficient data management and retrieval.

### **Services Covered:**

1. **Character Management Service**
2. **Core Script Management Service**
3. **Session and Context Management Service**
4. **Story Factory Service**
5. **Central Sequence Service**

---

## **1. Character Management Service**

### **Purpose:**
The Character Management Service is responsible for handling all aspects of character data, including creation, retrieval, updating, and deletion. It also manages related entities such as actions and spoken words linked to characters.

### **API Endpoints and OpenSearch Mappings:**

| **OpenAPI Endpoint**                          | **OpenSearch REST API Endpoint**                                                                                 | **Description**                                                                                      |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **POST /characters**                          | [POST /characters/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)              | Indexes a new character document.                                                                    |
| **GET /characters/{characterId}**             | [GET /characters/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/get/)                 | Retrieves a specific character document by ID.                                                       |
| **PUT /characters/{characterId}**             | [POST /characters/_update/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/update/)          | Updates a specific character document.                                                               |
| **DELETE /characters/{characterId}**          | [DELETE /characters/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/delete/)           | Deletes a character document.                                                                        |
| **GET /characters**                           | [GET /characters/_search](https://opensearch.org/docs/latest/api-reference/search/)                              | Retrieves all character documents.                                                                   |
| **GET /characters/{characterId}/paraphrases** | [GET /paraphrases/_search](https://opensearch.org/docs/latest/api-reference/search/)                              | Retrieves all paraphrases linked to a character.                                                     |
| **POST /characters/{characterId}/paraphrases**| [POST /paraphrases/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)              | Indexes a new paraphrase linked to a character.                                                      |
| **GET /actions**                              | [GET /actions/_search](https://opensearch.org/docs/latest/api-reference/search/)                                  | Retrieves all action documents.                                                                      |
| **POST /actions**                             | [POST /actions/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)                  | Indexes a new action document.                                                                       |
| **GET /spokenWords**                          | [GET /spokenWords/_search](https://opensearch.org/docs/latest/api-reference/search/)                              | Retrieves all spoken word documents.                                                                 |
| **POST /spokenWords**                         | [POST /spokenWords/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)              | Indexes a new spoken word document.                                                                  |
| **GET /spokenWords/{spokenWordId}/paraphrases**| [GET /paraphrases/_search](https://opensearch.org/docs/latest/api-reference/search/)                              | Retrieves all paraphrases linked to a spoken word.                                                   |
| **POST /spokenWords/{spokenWordId}/paraphrases**| [POST /paraphrases/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)              | Indexes a new paraphrase linked to a spoken word.                                                    |

### **Key OpenSearch Concepts:**
- **[Indexing Documents](https://opensearch.org/docs/latest/api-reference/document-apis/index/)**: How data is stored in OpenSearch as documents.
- **[Search API](https://opensearch.org/docs/latest/api-reference/search/)**: Used to retrieve documents based on queries.
- **[Update API](https://opensearch.org/docs/latest/api-reference/document-apis/update/)**: Allows modification of existing documents.
- **[Get API](https://opensearch.org/docs/latest/api-reference/document-apis/get/)**: Retrieves documents by their unique ID.

---

## **2. Core Script Management Service**

### **Purpose:**
The Core Script Management Service handles the creation, retrieval, updating, and deletion of scripts and their sections. This service ensures that scripts are structured correctly and that their components are managed effectively.

### **API Endpoints and OpenSearch Mappings:**

| **OpenAPI Endpoint**                                 | **OpenSearch REST API Endpoint**                                                                                 | **Description**                                                                                      |
|------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **POST /scripts**                                    | [POST /scripts/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)                 | Indexes a new script document.                                                                       |
| **GET /scripts/{scriptId}**                          | [GET /scripts/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/get/)                    | Retrieves a specific script document by ID.                                                          |
| **PUT /scripts/{scriptId}**                          | [POST /scripts/_update/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/update/)             | Updates a specific script document.                                                                  |
| **DELETE /scripts/{scriptId}**                       | [DELETE /scripts/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/delete/)              | Deletes a script document.                                                                           |
| **GET /scripts**                                     | [GET /scripts/_search](https://opensearch.org/docs/latest/api-reference/search/)                                 | Retrieves all script documents.                                                                      |
| **POST /scripts/{scriptId}/sections**                | [POST /sections/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)                | Indexes a new section for a script.                                                                  |
| **GET /scripts/{scriptId}/sections**                 | [GET /sections/_search](https://opensearch.org/docs/latest/api-reference/search/)                                | Retrieves all sections linked to a specific script.                                                  |
| **GET /scripts/{scriptId}/sections/{sectionId}**     | [GET /sections/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/get/)                   | Retrieves a specific section by ID.                                                                  |
| **PUT /scripts/{scriptId}/sections/{sectionId}**     | [POST /sections/_update/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/update/)            | Updates a specific section document.                                                                 |
| **DELETE /scripts/{scriptId}/sections/{sectionId}**  | [DELETE /sections/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/delete/)             | Deletes a section document.                                                                          |
| **POST /scripts/{scriptId}/sections/reorder**        | [POST /_bulk](https://opensearch.org/docs/latest/api-reference/document-apis/bulk/)                              | Reorders section headings within a script by updating their sequence numbers.                        |

### **Key OpenSearch Concepts:**
- **[Managing Documents](https://opensearch.org/docs/latest/api-reference/document-apis/index/)**: How to create, retrieve, update, and delete documents.
- **[Search API](https://opensearch.org/docs/latest/api-reference/search/)**: Fundamental for retrieving documents based on specific criteria.
- **[Bulk API](https://opensearch.org/docs/latest/api-reference/document-apis/bulk/)**: Used to perform multiple document operations in a single request.

---

## **3. Session and Context Management Service**

### **Purpose:**
This service manages session data and contextual information, ensuring continuity in character and script interactions. It stores session-specific details and retrieves context data as needed.

### **API Endpoints and OpenSearch Mappings:**

| **OpenAPI Endpoint**                        | **OpenSearch REST API Endpoint**                                                                                 | **Description**                                                                                      |
|---------------------------------------------|------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **POST /sessions**                          | [POST /sessions/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)                 | Indexes a new session document.                                                                      |
| **GET /sessions/{sessionId}**               | [GET /sessions/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/get/)                    | Retrieves a specific session document by ID.                                                         |
| **PUT /sessions/{sessionId}**               | [POST /sessions/_update/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/update/)             | Updates a specific session document.                                                                 |
| **DELETE /sessions/{sessionId}**            | [DELETE /sessions/_doc/{id}](https

://opensearch.org/docs/latest/api-reference/document-apis/delete/)              | Deletes a session document.                                                                          |
| **GET /sessions**                           | [GET /sessions/_search](https://opensearch.org/docs/latest/api-reference/search/)                                 | Retrieves all session documents.                                                                     |
| **POST /contexts**                          | [POST /contexts/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/)                 | Indexes new context data.                                                                            |
| **GET /contexts/{contextId}**               | [GET /contexts/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/get/)                    | Retrieves specific context data by ID.                                                               |
| **DELETE /contexts/{contextId}**            | [DELETE /contexts/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/delete/)              | Deletes context data.                                                                                |

### **Key OpenSearch Concepts:**
- **[Indexing and Retrieving Sessions](https://opensearch.org/docs/latest/api-reference/document-apis/index/)**: Handling session data in OpenSearch.
- **[Managing Context Data](https://opensearch.org/docs/latest/api-reference/document-apis/index/)**: Storing and retrieving contextual information.

---

## **4. Story Factory Service**

### **Purpose:**
The Story Factory Service is responsible for assembling complete stories by querying and combining various data components such as characters, actions, spoken words, and scripts stored in OpenSearch.

### **API Endpoints and OpenSearch Mappings:**

| **OpenAPI Endpoint**                           | **OpenSearch REST API Endpoint**                                                                                                                                                                                                 | **Description**                                                                                                      |
|------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **GET /stories/{scriptId}**                    | [POST /characters/_search](https://opensearch.org/docs/latest/api-reference/search/), [POST /actions/_search](https://opensearch.org/docs/latest/api-reference/search/), [POST /spokenWords/_search](https://opensearch.org/docs/latest/api-reference/search/), [POST /sections/_search](https://opensearch.org/docs/latest/api-reference/search/) | Retrieves and assembles a complete story by fetching related components.                                             |
| **GET /stories/sections/{sectionId}**          | [GET /sections/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/get/)                                                                                                                                     | Retrieves a specific section of a story by ID.                                                                       |
| **POST /stories/search**                       | [POST /scripts/_search](https://opensearch.org/docs/latest/api-reference/search/), [POST /sections/_search](https://opensearch.org/docs/latest/api-reference/search/), [POST /characters/_search](https://opensearch.org/docs/latest/api-reference/search/), [POST /actions/_search](https://opensearch.org/docs/latest/api-reference/search/) | Searches for stories or story components based on criteria.                                                          |
| **GET /stories/orchestration/{scriptId}**      | [POST /orchestration/_search](https://opensearch.org/docs/latest/api-reference/search/)                                                                                                                                             | Retrieves orchestration data (e.g., music, sound cues) linked to a script.                                           |

### **Key OpenSearch Concepts:**
- **[Assembling Data from Multiple Indices](https://opensearch.org/docs/latest/api-reference/search/)**: Using OpenSearch's search API to retrieve and combine data from different sources.

---

## **5. Central Sequence Service**

### **Purpose:**
The Central Sequence Service manages sequence numbers for elements within scripts or stories, ensuring a logical flow in narrative construction.

### **API Endpoints and OpenSearch Mappings:**

| **OpenAPI Endpoint**                             | **OpenSearch REST API Endpoint**                                                                                 | **Description**                                                                                                      |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **POST /sequences**                              | [POST /sequences/_doc/{id}](https://opensearch.org/docs/latest/api-reference/document-apis/index/), [POST /sequences/_search](https://opensearch.org/docs/latest/api-reference/search/) | Generates and stores a new sequence number.                                                                          |
| **PUT /sequences/reorder**                       | [POST /_bulk](https://opensearch.org/docs/latest/api-reference/document-apis/bulk/)                              | Reorders elements by updating sequence numbers using the bulk API.                                                   |
| **POST /sequences/version**                      | [POST /sequences/_doc](https://opensearch.org/docs/latest/api-reference/document-apis/index/)                    | Creates a new version of an existing sequence element.                                                               |

### **Key OpenSearch Concepts:**
- **[Bulk Operations](https://opensearch.org/docs/latest/api-reference/document-apis/bulk/)**: Performing multiple document operations in a single request.
- **[Versioning in OpenSearch](https://opensearch.org/docs/latest/api-reference/document-apis/index/)**: Managing different versions of documents.

---

## **Conclusion**

This documentation provides a comprehensive guide to how each service within FountainAI interacts with OpenSearch. By mapping the OpenAPI endpoints to specific OpenSearch REST API operations, this document ensures a clear understanding of the underlying data flow and how various components are managed within the system.

For detailed information about each OpenSearch API used, please refer to the links provided, which direct you to the official OpenSearch REST API documentation.

---

This version of the documentation reflects the transition from Elasticsearch to OpenSearch, ensuring that all API endpoints are correctly mapped to their OpenSearch equivalents. The provided links direct you to the latest OpenSearch documentation for further reference and details on the specific operations.