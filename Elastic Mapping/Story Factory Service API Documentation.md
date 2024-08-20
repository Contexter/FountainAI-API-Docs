# **Story Factory Service API Documentation**

## **Overview**

The Story Factory Service API is responsible for assembling and delivering complete stories within the FountainAI ecosystem. It integrates various components such as characters, actions, spoken words, and scripts by querying Elasticsearch, where these elements are stored. This service is built as an OpenAPI wrapper around Elasticsearch, providing a simplified interface for retrieving and assembling story components.

## **Base URLs**

- **Production**: `https://story.fountain.coach`
- **Development**: `http://localhost:8080`

## **API Endpoints Overview**

This section provides an overview of the API endpoints exposed by the Story Factory Service and their corresponding Elasticsearch REST API interactions.

| **Endpoint**                            | **Method** | **Elasticsearch API**                | **Description**                                              |
|-----------------------------------------|------------|--------------------------------------|--------------------------------------------------------------|
| `/stories/{scriptId}`                   | `GET`      | `GET /{index}/_search`               | Retrieves the full story by querying all relevant components for a script. |
| `/stories/sections/{sectionId}`         | `GET`      | `GET /{index}/_doc/{id}`             | Retrieves a specific section of a story.                     |
| `/stories/search`                       | `POST`     | `POST /{index}/_search`              | Searches for stories or story components based on specific criteria. |
| `/stories/orchestration/{scriptId}`     | `GET`      | `GET /{index}/_search`               | Retrieves orchestration data (e.g., music, sound cues) associated with a script. |

---

## **Detailed Endpoint Descriptions**

### **1. Retrieve the Full Story**

- **Endpoint**: `GET /stories/{scriptId}`
- **Elasticsearch Interaction**:
  - **Search**: Queries Elasticsearch to retrieve all components related to the specified script, including characters, actions, spoken words, and sections. The service then assembles these components into a complete story.

**Request Example**:
```json
GET /stories/123
```

**Elasticsearch Interaction**:
```json
POST /characters/_search
{
  "query": {
    "term": { "scriptId": "123" }
  }
}
```
```json
POST /actions/_search
{
  "query": {
    "term": { "scriptId": "123" }
  }
}
```
```json
POST /spokenWords/_search
{
  "query": {
    "term": { "scriptId": "123" }
  }
}
```
```json
POST /sections/_search
{
  "query": {
    "term": { "scriptId": "123" }
  }
}
```
- **Purpose**: Assembles and returns a complete story by retrieving and combining all relevant components (characters, actions, spoken words, sections) for the specified script.

---

### **2. Retrieve a Specific Section of a Story**

- **Endpoint**: `GET /stories/sections/{sectionId}`
- **Elasticsearch Interaction**:
  - **Retrieve Document**: Fetches the document corresponding to the specified `sectionId` from the `sections` index in Elasticsearch.

**Request Example**:
```json
GET /stories/sections/456
```

**Elasticsearch Interaction**:
```json
GET /sections/_doc/456
```
- **Purpose**: Retrieves the details of a specific section of a story by its ID, including content, sequence number, and associated metadata.

---

### **3. Search for Stories or Story Components**

- **Endpoint**: `POST /stories/search`
- **Elasticsearch Interaction**:
  - **Search**: Uses Elasticsearch’s search API to find stories or specific story components based on criteria such as character names, dialogue content, or section titles.

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
```json
POST /sections/_search
{
  "query": {
    "match": { "title": "Adventure" }
  }
}
```
- **Purpose**: Allows users to search for stories or specific components (e.g., scripts, sections) within stories that match the given criteria.

---

### **4. Retrieve Orchestration Data for a Script**

- **Endpoint**: `GET /stories/orchestration/{scriptId}`
- **Elasticsearch Interaction**:
  - **Search**: Retrieves orchestration data (e.g., music cues, sound effects) associated with the specified script from Elasticsearch.

**Request Example**:
```json
GET /stories/orchestration/123
```

**Elasticsearch Interaction**:
```json
POST /orchestration/_search
{
  "query": {
    "term": { "scriptId": "123" }
  }
}
```
- **Purpose**: Retrieves orchestration data related to a script, which may include music files, sound cues, or other audio elements that are part of the story’s production.

---

## **Conclusion**

The Story Factory Service API is a crucial component of the FountainAI system, responsible for assembling and delivering complete stories by interacting with various elements stored in Elasticsearch. By wrapping around Elasticsearch's REST API, this service simplifies the retrieval and assembly of story components, ensuring that complete narratives are generated efficiently and accurately. This documentation provides a clear and detailed guide for interacting with the Story Factory Service, ensuring consistency and ease of use within the broader FountainAI ecosystem.

