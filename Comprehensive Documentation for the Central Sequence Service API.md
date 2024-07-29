### Comprehensive Documentation for the Central Sequence Service API

### Overview
The Central Sequence Service API is designed to provide unique and sequential numbers to ensure the correct order of elements in a story. This service is essential for maintaining a logical reading flow by assigning sequence numbers to elements such as scripts, sections, actions, dialogues, and contexts.

### Key Features
- **Get Next Sequence Number**: Provides the next available sequence number for a given context.
- **Reset Sequence Number**: Resets the sequence number for a specific context (optional).

### Central Sequence Service API Specification

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "Central Sequence Service API",
    "description": "This API provides unique and sequential numbers to ensure the correct order of elements in a story.",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://centralsequence.fountain.coach",
      "description": "Production server for Central Sequence Service API"
    },
    {
      "url": "http://localhost:8080",
      "description": "Development server"
    }
  ],
  "paths": {
    "/sequences/next": {
      "get": {
        "summary": "Get Next Sequence Number",
        "operationId": "getNextSequenceNumber",
        "description": "Provides the next available sequence number.",
        "parameters": [
          {
            "name": "context",
            "in": "query",
            "required": true,
            "description": "Context for which the sequence number is requested (e.g., script, action, dialogue).",
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Next sequence number retrieved successfully.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "nextSequenceNumber": {
                      "type": "integer",
                      "description": "The next available sequence number."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/sequences/reset": {
      "post": {
        "summary": "Reset Sequence Number",
        "operationId": "resetSequenceNumber",
        "description": "Resets the sequence number for a specific context (optional).",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "context": {
                    "type": "string",
                    "description": "Context for which the sequence number is to be reset."
                  },
                  "startingValue": {
                    "type": "integer",
                    "description": "The starting value for the sequence number after reset."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Sequence number reset successfully.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "message": {
                      "type": "string",
                      "description": "Confirmation message."
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Error": {
        "type": "object",
        "properties": {
          "message": {
            "type": "string",
            "description": "Description of the error encountered."
          }
        }
      }
    }
  }
}
```

### Explanation for Dummies

**Overview**

The Central Sequence Service API ensures that every part of a story (such as scripts, sections, actions, and dialogues) follows a correct and logical order by providing unique and sequential numbers. This service is used by various other APIs to maintain the order and flow of the story.

**How It Works**

- **Get Next Sequence Number**: When an element (like an action or dialogue) needs a sequence number, it requests the next available number from this service. This ensures no two elements share the same sequence number, maintaining order.
- **Reset Sequence Number**: If needed, the sequence numbers for a specific context can be reset, starting again from a defined number.

**Example Usage**

1. **Get Next Sequence Number**:
   - When adding a new action to a script, the system requests the next sequence number for the "action" context from the Central Sequence Service.
   - The service responds with the next number, ensuring the action is placed in the correct order within the story.

2. **Reset Sequence Number**:
   - If sequence numbers need to be reset (e.g., restarting a script), this endpoint allows resetting the starting number.

### Integration with Other APIs

#### Core Script Management API
- **Manages the structure of the script including sections and transitions.**
  - Calls the Central Sequence Service to get sequence numbers when adding or updating scripts, section headings, and transitions.

#### Session and Context Management API
- **Manages the context for each character, including their state and interactions.**
  - Calls the Central Sequence Service to get sequence numbers when managing character contexts.

#### Character Management API
- **Manages details of characters, their actions, and spoken words.**
  - Calls the Central Sequence Service to get sequence numbers when adding or updating characters, actions, spoken words, and paraphrases.

#### Story Factory API
- **Assembles data from various sources to create a coherent story.**
  - Uses the Central Sequence Service to ensure every element of the story (character appearances, actions, dialogues) follows a logical sequence, thus maintaining a cohesive narrative.

By integrating sequence numbers and assembling all elements from the existing APIs, the Story Factory API provides a seamless and logical reading experience for the story.

### Ensuring Sequence Consistency

The Central Sequence Service API is critical for maintaining the correct order of elements in the story. It acts as a central authority, providing unique sequence numbers for different contexts. This prevents overlap and ensures a smooth, logical progression in the story. The sequence numbers are requested whenever a new element is added, guaranteeing that the story unfolds in a natural and intended manner.