I apologize for the oversight. Let's dive deeper into the full scope of the **Character Management Service** API and provide a more comprehensive documentation that covers all aspects of the service as per the OpenAPI specification you provided earlier. This will include all endpoints, data models, and their corresponding Elasticsearch interactions.

### **Character Management Service API Documentation**

---

## **Overview**

The Character Management Service API is responsible for creating, retrieving, updating, and managing characters within the FountainAI ecosystem. It also handles actions, spoken words, and paraphrases linked to characters. The API serves as an OpenAPI wrapper around Elasticsearch, providing a simplified and focused interface for interacting with character-related data stored in Elasticsearch.

## **Base URLs**

- **Production**: `https://character.fountain.coach`
- **Development**: `http://localhost:8080`

## **API Endpoints Overview**

This section provides an overview of the API endpoints exposed by the Character Management Service and their corresponding Elasticsearch REST API interactions.

| **Endpoint**                                 | **Method** | **Elasticsearch API**                | **Description**                                                        |
|----------------------------------------------|------------|--------------------------------------|------------------------------------------------------------------------|
| `/characters`                                | `GET`      | `GET /{index}/_search`               | Retrieves all characters stored in Elasticsearch.                      |
| `/characters`                                | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new character and stores it in Elasticsearch.                |
| `/characters/{characterId}`                  | `GET`      | `GET /{index}/_doc/{id}`             | Retrieves a specific character by its ID from Elasticsearch.           |
| `/characters/{characterId}`                  | `PUT`      | `POST /{index}/_update/{id}`         | Updates a character's details in Elasticsearch.                        |
| `/characters/{characterId}`                  | `DELETE`   | `DELETE /{index}/_doc/{id}`          | Deletes a character from Elasticsearch.                                |
| `/characters/{characterId}/paraphrases`      | `GET`      | `GET /{index}/_search`               | Retrieves all paraphrases linked to a specific character.              |
| `/characters/{characterId}/paraphrases`      | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new paraphrase for a character and stores it in Elasticsearch.|
| `/actions`                                   | `GET`      | `GET /{index}/_search`               | Retrieves all actions currently stored within the system.              |
| `/actions`                                   | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new action entity and stores it in Elasticsearch.            |
| `/actions/{actionId}/paraphrases`            | `GET`      | `GET /{index}/_search`               | Retrieves all paraphrases linked to a specific action.                 |
| `/actions/{actionId}/paraphrases`            | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new paraphrase linked to an action and stores it in Elasticsearch.|
| `/spokenWords`                               | `GET`      | `GET /{index}/_search`               | Retrieves all spoken words currently stored within the system.         |
| `/spokenWords`                               | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new spoken word entity and stores it in Elasticsearch.       |
| `/spokenWords/{spokenWordId}/paraphrases`    | `GET`      | `GET /{index}/_search`               | Retrieves all paraphrases linked to a specific spoken word.            |
| `/spokenWords/{spokenWordId}/paraphrases`    | `POST`     | `POST /{index}/_doc/{id}`            | Creates a new paraphrase linked to a spoken word and stores it in Elasticsearch.|

---

## **Detailed Endpoint Descriptions**

### **1. Retrieve All Characters**

- **Endpoint**: `GET /characters`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all character documents in the `characters` index.

**Request Example**:
```json
GET /characters
```

**Elasticsearch Interaction**:
```json
GET /characters/_search
{
  "query": {
    "match_all": {}
  }
}
```
- **Purpose**: Fetches all characters stored in Elasticsearch, returning a list of character documents.

---

### **2. Create a New Character**

- **Endpoint**: `POST /characters`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores the new character as a document in the `characters` index.

**Request Example**:
```json
{
  "name": "John Doe",
  "description": "A mysterious stranger with a troubled past."
}
```

**Elasticsearch Interaction**:
```json
POST /characters/_doc
{
  "name": "John Doe",
  "description": "A mysterious stranger with a troubled past."
}
```
- **Purpose**: Creates a new character in the system and persists it in Elasticsearch.

---

### **3. Retrieve a Specific Character**

- **Endpoint**: `GET /characters/{characterId}`
- **Elasticsearch Interaction**:
  - **Retrieve Document**: Fetches the document corresponding to the specified `characterId`.

**Request Example**:
```json
GET /characters/123
```

**Elasticsearch Interaction**:
```json
GET /characters/_doc/123
```
- **Purpose**: Retrieves the details of a specific character by its ID, including name, description, and associated data.

---

### **4. Update a Character**

- **Endpoint**: `PUT /characters/{characterId}`
- **Elasticsearch Interaction**:
  - **Update Document**: Modifies the character’s details in Elasticsearch.

**Request Example**:
```json
{
  "description": "An enigmatic figure with a secretive history."
}
```

**Elasticsearch Interaction**:
```json
POST /characters/_update/123
{
  "doc": {
    "description": "An enigmatic figure with a secretive history."
  }
}
```
- **Purpose**: Updates the specified character’s information in Elasticsearch.

---

### **5. Delete a Character**

- **Endpoint**: `DELETE /characters/{characterId}`
- **Elasticsearch Interaction**:
  - **Delete Document**: Removes the character document from Elasticsearch.

**Request Example**:
```json
DELETE /characters/123
```

**Elasticsearch Interaction**:
```json
DELETE /characters/_doc/123
```
- **Purpose**: Deletes the specified character from Elasticsearch, effectively removing it from the system.

---

### **6. Retrieve All Paraphrases for a Character**

- **Endpoint**: `GET /characters/{characterId}/paraphrases`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all paraphrase documents linked to the specified character.

**Request Example**:
```json
GET /characters/123/paraphrases
```

**Elasticsearch Interaction**:
```json
GET /paraphrases/_search
{
  "query": {
    "term": { "characterId": "123" }
  }
}
```
- **Purpose**: Retrieves all paraphrases associated with the specified character from Elasticsearch.

---

### **7. Create a New Paraphrase for a Character**

- **Endpoint**: `POST /characters/{characterId}/paraphrases`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores a new paraphrase linked to a character in Elasticsearch.

**Request Example**:
```json
{
  "text": "This is a paraphrase.",
  "commentary": "Linked to the original character."
}
```

**Elasticsearch Interaction**:
```json
POST /paraphrases/_doc
{
  "characterId": 123,
  "text": "This is a paraphrase.",
  "commentary": "Linked to the original character."
}
```
- **Purpose**: Creates and stores a new paraphrase associated with the specified character.

---

### **8. Retrieve All Actions**

- **Endpoint**: `GET /actions`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all action documents in the `actions` index.

**Request Example**:
```json
GET /actions
```

**Elasticsearch Interaction**:
```json
GET /actions/_search
{
  "query": {
    "match_all": {}
  }
}
```
- **Purpose**: Fetches all actions stored in Elasticsearch, returning a list of action documents.

---

### **9. Create a New Action**

- **Endpoint**: `POST /actions`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores the new action as a document in the `actions` index.

**Request Example**:
```json
{
  "description": "John enters the room."
}
```

**Elasticsearch Interaction**:
```json
POST /actions/_doc
{
  "description": "John enters the room."
}
```
- **Purpose**: Creates a new action in the system and persists it in Elasticsearch.

---

### **10. Retrieve All Paraphrases for an Action**

- **Endpoint**: `GET /actions/{actionId}/paraphrases`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all paraphrase documents linked to the specified action.

**Request Example**:
```json
GET /actions/123/paraphrases
```

**Elasticsearch Interaction**:
```json
GET /paraphrases/_search
{
  "query": {
    "term": { "actionId": "123" }
  }
}
```
-

 **Purpose**: Retrieves all paraphrases associated with the specified action from Elasticsearch.

---

### **11. Create a New Paraphrase for an Action**

- **Endpoint**: `POST /actions/{actionId}/paraphrases`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores a new paraphrase linked to an action in Elasticsearch.

**Request Example**:
```json
{
  "text": "John's entrance is described differently.",
  "commentary": "Linked to the original action."
}
```

**Elasticsearch Interaction**:
```json
POST /paraphrases/_doc
{
  "actionId": 123,
  "text": "John's entrance is described differently.",
  "commentary": "Linked to the original action."
}
```
- **Purpose**: Creates and stores a new paraphrase associated with the specified action.

---

### **12. Retrieve All Spoken Words**

- **Endpoint**: `GET /spokenWords`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all spoken word documents in the `spokenWords` index.

**Request Example**:
```json
GET /spokenWords
```

**Elasticsearch Interaction**:
```json
GET /spokenWords/_search
{
  "query": {
    "match_all": {}
  }
}
```
- **Purpose**: Fetches all spoken words stored in Elasticsearch, returning a list of spoken word documents.

---

### **13. Create a New Spoken Word**

- **Endpoint**: `POST /spokenWords`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores the new spoken word as a document in the `spokenWords` index.

**Request Example**:
```json
{
  "text": "Hello, world!"
}
```

**Elasticsearch Interaction**:
```json
POST /spokenWords/_doc
{
  "text": "Hello, world!"
}
```
- **Purpose**: Creates a new spoken word in the system and persists it in Elasticsearch.

---

### **14. Retrieve All Paraphrases for a Spoken Word**

- **Endpoint**: `GET /spokenWords/{spokenWordId}/paraphrases`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves all paraphrase documents linked to the specified spoken word.

**Request Example**:
```json
GET /spokenWords/123/paraphrases
```

**Elasticsearch Interaction**:
```json
GET /paraphrases/_search
{
  "query": {
    "term": { "spokenWordId": "123" }
  }
}
```
- **Purpose**: Retrieves all paraphrases associated with the specified spoken word from Elasticsearch.

---

### **15. Create a New Paraphrase for a Spoken Word**

- **Endpoint**: `POST /spokenWords/{spokenWordId}/paraphrases`
- **Elasticsearch Interaction**:
  - **Index Document**: Stores a new paraphrase linked to a spoken word in Elasticsearch.

**Request Example**:
```json
{
  "text": "Hi, world!",
  "commentary": "Linked to the original spoken word."
}
```

**Elasticsearch Interaction**:
```json
POST /paraphrases/_doc
{
  "spokenWordId": 123,
  "text": "Hi, world!",
  "commentary": "Linked to the original spoken word."
}
```
- **Purpose**: Creates and stores a new paraphrase associated with the specified spoken word.

---

## **Conclusion**

The Character Management Service API is a comprehensive tool for managing characters, actions, spoken words, and paraphrases within FountainAI. By wrapping around the Elasticsearch REST API, it simplifies complex operations and provides a consistent interface for interacting with character-related data. This ensures efficient, scalable, and maintainable character management, leveraging Elasticsearch's robust search and indexing capabilities.

This documentation format is designed to be thorough and clear, covering all the necessary details to understand how the Character Management Service interacts with Elasticsearch.
