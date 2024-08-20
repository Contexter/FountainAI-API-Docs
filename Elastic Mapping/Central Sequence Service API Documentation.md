
# **Central Sequence Service API Documentation**


## **Overview**

The Central Sequence Service is an essential component of the FountainAI architecture, responsible for managing sequence numbers for various elements, such as actions, scenes, and dialogues, within scripts or stories. This service functions as an OpenAPI wrapper around Elasticsearch, providing a simplified interface for sequence management while abstracting the complexities of direct interactions with Elasticsearch.

## **Base URLs**

- **Production**: `https://sequence.fountain.coach`
- **Development**: `http://localhost:8080`

## **API Endpoints Overview**

This section provides an overview of the key API endpoints exposed by the Central Sequence Service and how they correspond to Elasticsearch REST API operations.

| **Endpoint**                 | **Method** | **Elasticsearch API**                | **Description**                                               |
|------------------------------|------------|--------------------------------------|---------------------------------------------------------------|
| `/sequences`                 | `POST`     | `POST /{index}/_search` <br> `POST /{index}/_doc/{id}` | Generates a new sequence number and stores it in Elasticsearch. |
| `/sequences/reorder`         | `PUT`      | `POST /_bulk`                        | Reorders sequence numbers by updating multiple documents.      |
| `/sequences/{elementId}`     | `GET`      | `GET /{index}/_doc/{id}`             | Retrieves a specific sequence by its element ID.               |
| `/sequences/version`         | `POST`     | `POST /{index}/_doc`                 | Creates a new version of a sequence element in Elasticsearch.  |
| `/sequences/{elementId}`     | `PUT`      | `POST /{index}/_update/{id}`         | Updates an existing sequence number or element properties.     |
| `/sequences/search`          | `GET`      | `POST /{index}/_search`              | Searches for sequences based on specified criteria.            |

---

## **Detailed Endpoint Descriptions**

### **1. Generate a New Sequence Number**

- **Endpoint**: `POST /sequences`
- **Elasticsearch Interaction**:
  - **Step 1**: Query Elasticsearch to find the current highest sequence number for the specified element type.
  - **Step 2**: Calculate the next sequence number.
  - **Step 3**: Store the new sequence number as a document in Elasticsearch.
  
**Request Example**:
```json
{
  "elementType": "action",
  "elementId": 123
}
```

**Elasticsearch Interactions**:

1. **Search for Current Max Sequence**:
   ```json
   POST /sequences/_search
   {
     "query": { "term": { "elementType": "action" } },
     "sort": { "sequenceNumber": "desc" },
     "size": 1
   }
   ```
   - **Purpose**: Finds the highest sequence number for the specified `elementType` to determine the next sequence number.

2. **Index New Sequence Number**:
   ```json
   POST /sequences/_doc
   {
     "elementType": "action",
     "elementId": 123,
     "sequenceNumber": 42
   }
   ```
   - **Purpose**: Stores the new sequence number along with the element details in Elasticsearch.

---

### **2. Reorder Sequence Numbers**

- **Endpoint**: `PUT /sequences/reorder`
- **Elasticsearch Interaction**:
  - **Step 1**: Fetch existing sequence numbers for the specified elements.
  - **Step 2**: Use Elasticsearch’s bulk update API to reorder sequence numbers.

**Request Example**:
```json
{
  "elementType": "scene",
  "elements": [
    { "elementId": 123, "newSequence": 1 },
    { "elementId": 124, "newSequence": 2 }
  ]
}
```

**Elasticsearch Interaction**:
```json
POST /_bulk
{ "update": { "_id": "123", "_index": "sequences" } }
{ "doc": { "sequenceNumber": 1 } }
{ "update": { "_id": "124", "_index": "sequences" } }
{ "doc": { "sequenceNumber": 2 } }
```
- **Purpose**: Updates the sequence numbers for multiple elements in one operation, ensuring they are in the correct order.

---

### **3. Retrieve a Sequence**

- **Endpoint**: `GET /sequences/{elementId}`
- **Elasticsearch Interaction**:
  - **Fetch Document**: Retrieves the document corresponding to the specified `elementId` from Elasticsearch.

**Request Example**:
```json
GET /sequences/123
```

**Elasticsearch Interaction**:
```json
GET /sequences/_doc/123
```
- **Purpose**: Retrieves the details of a specific sequence by its element ID, including the sequence number and related metadata.

---

### **4. Create a New Version of a Sequence Element**

- **Endpoint**: `POST /sequences/version`
- **Elasticsearch Interaction**:
  - **Index New Version**: Stores the new version of the sequence element as a new document in Elasticsearch, maintaining version control.

**Request Example**:
```json
{
  "elementType": "action",
  "elementId": 123
}
```

**Elasticsearch Interaction**:
```json
POST /sequences/_doc
{
  "elementType": "action",
  "elementId": 123,
  "versionNumber": 2,
  "sequenceNumber": 42
}
```
- **Purpose**: Creates and stores a new version of an existing sequence element, allowing for versioning and historical tracking.

---

### **5. Update a Sequence**

- **Endpoint**: `PUT /sequences/{elementId}`
- **Elasticsearch Interaction**:
  - **Update Document**: Modifies the sequence number or other properties of the specified sequence element.

**Request Example**:
```json
{
  "sequenceNumber": 43
}
```

**Elasticsearch Interaction**:
```json
POST /sequences/_update/123
{
  "doc": { "sequenceNumber": 43 }
}
```
- **Purpose**: Updates the sequence number or related data for a specific element, ensuring the correct sequence is maintained.

---

### **6. Search Sequences**

- **Endpoint**: `GET /sequences/search`
- **Elasticsearch Interaction**:
  - **Execute Search**: Uses Elasticsearch’s search API to find sequence elements that match the specified criteria.

**Request Example**:
```json
{
  "query": {
    "match": { "elementType": "scene" }
  }
}
```

**Elasticsearch Interaction**:
```json
POST /sequences/_search
{
  "query": { "match": { "elementType": "scene" } }
}
```
- **Purpose**: Retrieves sequences based on specific search criteria, such as element type or sequence number range.

---

## **Conclusion**

The Central Sequence Service provides a specialized, user-friendly API for managing sequence numbers within the FountainAI architecture. By wrapping key Elasticsearch REST API endpoints, this service simplifies the interaction with Elasticsearch, ensuring efficient, consistent, and scalable sequence management.

This documentation format not only explains each API endpoint and its corresponding Elasticsearch operation but also provides clear examples of how the service interacts with Elasticsearch. This approach ensures that the Central Sequence Service is well-documented, maintainable, and easy to integrate with other components of the FountainAI system.

