# **FountainAI Services Documentation: Elasticsearch Integration**

## **Overview**

FountainAI is a suite of services designed to manage and assemble various components of stories, including characters, actions, scripts, sessions, and more. Each service interacts with Elasticsearch to store, retrieve, and manipulate data. This document provides a comprehensive overview of how each service's OpenAPI endpoints map to Elasticsearch REST API operations, ensuring efficient data management and retrieval.

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

### **API Endpoints and Elasticsearch Mappings:**

| **OpenAPI Endpoint**                          | **Elasticsearch REST API Endpoint**                                                                                 | **Description**                                                                                      |
|-----------------------------------------------|---------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **POST /characters**                          | [POST /characters/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)       | Indexes a new character document.                                                                    |
| **GET /characters/{characterId}**             | [GET /characters/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)           | Retrieves a specific character document by ID.                                                       |
| **PUT /characters/{characterId}**             | [POST /characters/_update/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html)    | Updates a specific character document.                                                               |
| **DELETE /characters/{characterId}**          | [DELETE /characters/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html)     | Deletes a character document.                                                                        |
| **GET /characters**                           | [GET /characters/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)        | Retrieves all character documents.                                                                   |
| **GET /characters/{characterId}/paraphrases** | [GET /paraphrases/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)       | Retrieves all paraphrases linked to a character.                                                     |
| **POST /characters/{characterId}/paraphrases**| [POST /paraphrases/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)      | Indexes a new paraphrase linked to a character.                                                      |

### **Key Elasticsearch Concepts:**
- **[Indexing Documents](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)**: How data is stored in Elasticsearch as documents.
- **[Search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)**: Used to retrieve documents based on queries.
- **[Update API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html)**: Allows modification of existing documents.
- **[Get API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)**: Retrieves documents by their unique ID.

---

## **2. Core Script Management Service**

### **Purpose:**
The Core Script Management Service handles the creation, retrieval, updating, and deletion of scripts and their sections. This service ensures that scripts are structured correctly and that their components are managed effectively.

### **API Endpoints and Elasticsearch Mappings:**

| **OpenAPI Endpoint**                                 | **Elasticsearch REST API Endpoint**                                                                                 | **Description**                                                                                      |
|------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **POST /scripts**                                    | [POST /scripts/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)          | Indexes a new script document.                                                                       |
| **GET /scripts/{scriptId}**                          | [GET /scripts/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)              | Retrieves a specific script document by ID.                                                          |
| **PUT /scripts/{scriptId}**                          | [POST /scripts/_update/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html)       | Updates a specific script document.                                                                  |
| **DELETE /scripts/{scriptId}**                       | [DELETE /scripts/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html)        | Deletes a script document.                                                                           |
| **GET /scripts**                                     | [GET /scripts/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)           | Retrieves all script documents.                                                                      |
| **POST /scripts/{scriptId}/sections**                | [POST /sections/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)         | Indexes a new section for a script.                                                                  |
| **GET /scripts/{scriptId}/sections**                 | [GET /sections/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)          | Retrieves all sections linked to a specific script.                                                  |
| **GET /scripts/{scriptId}/sections/{sectionId}**     | [GET /sections/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)             | Retrieves a specific section by ID.                                                                  |
| **PUT /scripts/{scriptId}/sections/{sectionId}**     | [POST /sections/_update/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html)      | Updates a specific section document.                                                                 |
| **DELETE /scripts/{scriptId}/sections/{sectionId}**  | [DELETE /sections/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html)       | Deletes a section document.                                                                          |

### **Key Elasticsearch Concepts:**
- **[Managing Documents](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html)**: How to create, retrieve, update, and delete documents.
- **[Search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)**: Fundamental for retrieving documents based on specific criteria.

---

## **3. Session and Context Management Service**

### **Purpose:**
This service manages session data and contextual information, ensuring continuity in character and script interactions. It stores session-specific details and retrieves context data as needed.

### **API Endpoints and Elasticsearch Mappings:**

| **OpenAPI Endpoint**                        | **Elasticsearch REST API Endpoint**                                                                                 | **Description**                                                                                      |
|---------------------------------------------|---------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **POST /sessions**                          | [POST /sessions/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)         | Indexes a new session document.                                                                      |
| **GET /sessions/{sessionId}**               | [GET /sessions/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)             | Retrieves a specific session document by ID.                                                         |
| **DELETE /sessions/{sessionId}**            | [DELETE /sessions/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html)       | Deletes a session document.                                                                          |
| **POST /contexts**                          | [POST /contexts/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)         | Indexes new context data.                                                                            |
| **GET /contexts/{contextId}**               | [GET /contexts/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)             | Retrieves specific context data by ID.                                                               |
| **DELETE /contexts/{contextId}**            | [DELETE /contexts/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html)       | Deletes context data.                                                                                |

### **Key Elasticsearch Concepts:**
- **[Indexing and Retrieving Sessions](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html)**: Handling session data in Elasticsearch.
- **[Managing Context Data](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html)**: Storing and retrieving contextual information.

---

## **4. Story Factory Service**

### **Purpose:**
The Story Factory Service is responsible for assembling complete stories by querying and combining various data components such as characters, actions, spoken words, and scripts stored in Elasticsearch.

### **API Endpoints and Elasticsearch Mappings:**

| **OpenAPI Endpoint**                           | **Elasticsearch REST API Endpoint**                                                                                                                                                                                                 | **Description**                                                                                                      |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **GET /stories/{scriptId}**                    | [POST /characters/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html), [POST /actions/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html), [POST /spokenWords/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html), [POST /sections/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html) | Retrieves and assembles a complete story by fetching related components.                                             |
| **GET /stories/sections/{sectionId}**          | [GET /sections/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)                                                                                                                                                                  | Retrieves a specific section of a story by ID.                                                                       |
| **POST /stories/search**                       | [POST /scripts/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html), [POST /sections/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html), [POST /characters/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html), [POST /actions/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html) | Searches for stories or story components based on criteria.                                                          |
| **GET /stories/orchestration/{scriptId}**      | [POST /orchestration/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)                                                                                                                                                            | Retrieves orchestration data (e.g., music, sound cues) linked to a script.                                           |

### **Key Elasticsearch Concepts:**
- **[Assembling Data from Multiple Indices](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)**: Using Elasticsearch's search API to retrieve and combine data from different sources.

---

## **5. Central Sequence Service**

### **Purpose:**
The Central Sequence Service manages sequence numbers for elements within scripts or stories, ensuring a logical flow in narrative construction.

### **API Endpoints and Elasticsearch Mappings:**

| **OpenAPI Endpoint**                             | **Elasticsearch REST API Endpoint**                                                                                 | **Description**                                                                                                      |
|--------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| **POST /sequences**                              | [POST /sequences/_doc/{id}](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html), [POST /sequences/_search](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html) | Generates and stores a new sequence number.                                                                          |
| **PUT /sequences/reorder**                       | [POST /_bulk](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)                       | Reorders elements by updating sequence numbers using the bulk API.                                                   |
| **POST /sequences/version**                      | [POST /sequences/_doc](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)            | Creates a new version of an existing sequence element.                                                               |

### **Key Elasticsearch Concepts:**
- **[Bulk Operations](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)**: Performing multiple document operations in a single request.
- **[Versioning in Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html)**: Managing different versions of documents.

---

## **Conclusion**

This documentation provides a comprehensive guide to how each service within FountainAI interacts with Elasticsearch. By mapping the OpenAPI endpoints to specific Elasticsearch REST API operations, this document ensures a clear understanding of the underlying data flow and how various components are managed within the system.

For detailed information about each Elasticsearch API used, please refer to the links provided, which direct you to the official Elasticsearch REST API documentation.

---

This should now be complete and formatted correctly. Let me know if you need anything else.