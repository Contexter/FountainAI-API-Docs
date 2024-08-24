# **Core Script Management Service API Documentation**

## **Overview**

The Core Script Management Service API is responsible for managing scripts, sections, and their sequences within the FountainAI ecosystem. It provides functionality to create, retrieve, update, and delete scripts and sections. This service wraps around Elasticsearch, abstracting the complexity of direct interactions and providing a simplified interface tailored to managing script-related data.

## **Base URLs**

- **Production**: `https://script.fountain.coach`
- **Development**: `http://localhost:8080`

## **API Endpoints Overview**

This section provides an overview of the API endpoints exposed by the Core Script Management Service and their corresponding Elasticsearch REST API interactions.

| **Endpoint**                            | **Method** | **Elasticsearch API**                | **Description**                                              |
|-----------------------------------------|------------|--------------------------------------|--------------------------------------------------------------|
| `/scripts`                              | `GET`      | `GET /{index}/_search`               | Retrieves all scripts stored in Elasticsearch.               |
| `/scripts`                              | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new script and stores it in Elasticsearch.         |
| `/scripts/{scriptId}`                   | `GET`      | `GET /{index}/_doc/{id}`             | Retrieves a specific script by its ID from Elasticsearch.    |
| `/scripts/{scriptId}`                   | `PUT`      | `POST /{index}/_update/{id}`         | Updates a script's details in Elasticsearch.                 |
| `/scripts/{scriptId}`                   | `DELETE`   | `DELETE /{index}/_doc/{id}`          | Deletes a script from Elasticsearch.                         |
| `/scripts/{scriptId}/sections`          | `GET`      | `GET /{index}/_search`               | Retrieves all sections of a specific script.                 |
| `/scripts/{scriptId}/sections`          | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new section for a script and stores it in Elasticsearch. |
| `/scripts/{scriptId}/sections/{sectionId}`| `GET`      | `GET /{index}/_doc/{id}`             | Retrieves a specific section by its ID from Elasticsearch.   |
| `/scripts/{scriptId}/sections/{sectionId}`| `PUT`      | `POST /{index}/_update/{id}`         | Updates a section's details in Elasticsearch.                |
| `/scripts/{scriptId}/sections/{sectionId}`| `DELETE`   | `DELETE /{index}/_doc/{id}`          | Deletes a section from a script in Elasticsearch.            |
| `/scripts/search`                       | `GET`      | `POST /{index}/_search`              | Searches for scripts based on specific criteria.             |
| `/sections/reorder`                     | `PUT`      | `POST /_bulk`                        | Reorders sections within a script in Elasticsearch.          |

---

## **Detailed Endpoint Descriptions**

### **1. Retrieve All Scripts**

- **Endpoint**: `GET /scripts`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all script documents from the `scripts` index in Elasticsearch.

**Request Example**:
```json
GET /scripts
```

**Elasticsearch Interaction**:
```json
GET /scripts/_search
{
  "query": {
    "match_all": {}
  }
}
```
- **Purpose**: Fetches all scripts stored in Elasticsearch, returning a list of script documents.

---

### **2. Create a New Script**

- **Endpoint**: `POST /scripts`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores the new script as a document in the `scripts` index in Elasticsearch.

**Request Example**:
```json
{
  "title": "New Script",
  "author": "Jane Doe",
  "description": "A thrilling new adventure."
}
```

**Elasticsearch Interaction**:
```json
POST /scripts/_doc
{
  "title": "New Script",
  "author": "Jane Doe",
  "description": "A thrilling new adventure."
}
```
- **Purpose**: Creates a new script in the system and persists it in Elasticsearch.

---

### **3. Retrieve a Specific Script**

- **Endpoint**: `GET /scripts/{scriptId}`
- **Elasticsearch Interaction**:
  - **Retrieve Document**: Fetches the document corresponding to the specified `scriptId` from Elasticsearch.

**Request Example**:
```json
GET /scripts/123
```

**Elasticsearch Interaction**:
```json
GET /scripts/_doc/123
```
- **Purpose**: Retrieves the details of a specific script by its ID, including title, author, description, and any associated sections.

---

### **4. Update a Script**

- **Endpoint**: `PUT /scripts/{scriptId}`
- **Elasticsearch Interaction**:
  - **Update Document**: Modifies the script’s details in Elasticsearch using the update API.

**Request Example**:
```json
{
  "description": "An updated description for the script."
}
```

**Elasticsearch Interaction**:
```json
POST /scripts/_update/123
{
  "doc": {
    "description": "An updated description for the script."
  }
}
```
- **Purpose**: Updates the specified script’s information in Elasticsearch.

---

### **5. Delete a Script**

- **Endpoint**: `DELETE /scripts/{scriptId}`
- **Elasticsearch Interaction**:
  - **Delete Document**: Removes the script document from the `scripts` index in Elasticsearch.

**Request Example**:
```json
DELETE /scripts/123
```

**Elasticsearch Interaction**:
```json
DELETE /scripts/_doc/123
```
- **Purpose**: Deletes the specified script from Elasticsearch, effectively removing it from the system.

---

### **6. Retrieve All Sections of a Script**

- **Endpoint**: `GET /scripts/{scriptId}/sections`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all section documents associated with the specified script from the `sections` index in Elasticsearch.

**Request Example**:
```json
GET /scripts/123/sections
```

**Elasticsearch Interaction**:
```json
GET /sections/_search
{
  "query": {
    "term": { "scriptId": "123" }
  }
}
```
- **Purpose**: Retrieves all sections associated with the specified script from Elasticsearch.

---

### **7. Create a New Section for a Script**

- **Endpoint**: `POST /scripts/{scriptId}/sections`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores the new section as a document in the `sections` index in Elasticsearch.

**Request Example**:
```json
{
  "title": "Introduction",
  "sequenceNumber": 1,
  "content": "This is the introduction section."
}
```

**Elasticsearch Interaction**:
```json
POST /sections/_doc
{
  "scriptId": 123,
  "title": "Introduction",
  "sequenceNumber": 1,
  "content": "This is the introduction section."
}
```
- **Purpose**: Creates a new section within the specified script and persists it in Elasticsearch.

---

### **8. Retrieve a Specific Section of a Script**

- **Endpoint**: `GET /scripts/{scriptId}/sections/{sectionId}`
- **Elasticsearch Interaction**:
  - **Retrieve Document**: Fetches the document corresponding to the specified `sectionId` from Elasticsearch.

**Request Example**:
```json
GET /scripts/123/sections/456
```

**Elasticsearch Interaction**:
```json
GET /sections/_doc/456
```
- **Purpose**: Retrieves the details of a specific section by its ID, including title, sequence number, and content.

---

### **9. Update a Section of a Script**

- **Endpoint**: `PUT /scripts/{scriptId}/sections/{sectionId}`
- **Elasticsearch Interaction**:
  - **Update Document**: Modifies the section’s details in Elasticsearch.

**Request Example**:
```json
{
  "content": "Updated content for the section."
}
```

**Elasticsearch Interaction**:
```json
POST /sections/_update/456
{
  "doc": {
    "content": "Updated content for the section."
  }
}
```
- **Purpose**: Updates the specified section’s information in Elasticsearch.

---

### **10. Delete a Section of a Script**

- **Endpoint**: `DELETE /scripts/{scriptId}/sections/{sectionId}`
- **Elasticsearch Interaction**:
  - **Delete Document**: Removes the section document from the `sections` index in Elasticsearch.

**Request Example**:
```json
DELETE /scripts/123/sections/456
```

**Elasticsearch Interaction**:
```json
DELETE /sections/_doc/456
```
- **Purpose**: Deletes the specified section from Elasticsearch, effectively removing it from the script.

---

### **11. Search for Scripts**

- **Endpoint**: `GET /scripts/search`
- **Elasticsearch Interaction**:
  - **Search**: Uses Elasticsearch’s search API to find scripts based on specified criteria such as title, author, or content.

**Request Example**:
```json


{
  "query": {
    "match": { "title": "Adventure" }
  }
}
```

**Elasticsearch Interaction**:
```json
POST /scripts/_search
{
  "query": {
    "match": { "title": "Adventure" }
  }
}
```
- **Purpose**: Searches for scripts in Elasticsearch that match the given criteria.

---

### **12. Reorder Sections within a Script**

- **Endpoint**: `PUT /sections/reorder`
- **Elasticsearch Interaction**:
  - **Bulk Update**: Uses Elasticsearch’s bulk update API to reorder sections within a script.

**Request Example**:
```json
{
  "scriptId": 123,
  "sections": [
    { "sectionId": 456, "newSequence": 1 },
    { "sectionId": 789, "newSequence": 2 }
  ]
}
```

**Elasticsearch Interaction**:
```json
POST /_bulk
{ "update": { "_id": "456", "_index": "sections" } }
{ "doc": { "sequenceNumber": 1 } }
{ "update": { "_id": "789", "_index": "sections" } }
{ "doc": { "sequenceNumber": 2 } }
```
- **Purpose**: Reorders the sections within the specified script, ensuring that they follow the correct sequence.

---

## **Conclusion**

The Core Script Management Service API is designed to provide a robust and scalable solution for managing scripts and their sections within the FountainAI ecosystem. By wrapping around Elasticsearch's REST API, this service simplifies complex operations and offers a user-friendly interface for script management. This documentation ensures that all interactions with Elasticsearch are clearly defined and easy to implement.

This structure should help in maintaining consistency and clarity across all OpenAPI descriptions for the FountainAI system.

---

This completes the documentation for the Core Script Management Service. Would you like to proceed with another service, or do you have any further requests?