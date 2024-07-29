### Session and Context Management API Documentation

#### Overview

The Session and Context Management API is responsible for handling session management, context management, and natural language understanding (NLU) functionalities. This API ensures that each character's context is maintained and updated accurately, providing necessary contextual data for the story. With the integration of the Central Sequence Service, it also ensures that all elements follow a consistent sequence, enhancing the logical flow of the story.

#### Key Features

- **Character Context Management**: Retrieve and update the context for characters, including their state and interactions.
- **Session Management**: Create, renew, and end sessions for characters.
- **Context-Aware NLU**: Process user input with context-aware natural language understanding.
- **Central Sequence Service Integration**: Ensures that all context updates and interactions are sequenced properly.

#### How It Works

1. **Data Flow and Integration**:
   - The Session and Context Management API interacts with the Central Sequence Service to obtain sequence numbers for new context updates and interactions.
   - Each context update or interaction is assigned a sequence number, ensuring it appears in the correct order relative to other elements in the story.

2. **Session Management**:
   - Sessions are created, renewed, and ended, with each operation involving the Central Sequence Service to maintain sequence integrity.
   - This ensures that the sequence of sessions and their related contexts are managed in a coherent and logical manner.

3. **Context-Aware NLU**:
   - The API processes user inputs considering the current context of the character.
   - The results of NLU processing, including identified intents and extracted entities, are sequenced using the Central Sequence Service.

#### Example of Context Update

Here’s an example to illustrate how context updates are ordered within a sequence using the Central Sequence Service:

1. **Sequence 1**:
   - **Character**: Juliet
   - **Context Update**: Juliet's mood is updated to "longing" while she is on the balcony.

2. **Sequence 2**:
   - **Character**: Romeo
   - **Context Update**: Romeo's location is updated to "below Juliet's balcony".

3. **Sequence 3**:
   - **Character**: Juliet
   - **Context Update**: Juliet's mood changes to "curious" as she reaches out towards Romeo.

#### API Specification

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "FountainAI Session and Context Management API",
    "description": "This API handles session management, context management, and NLU functionalities. Now integrated with the Central Sequence Service to ensure logical sequence of context updates and interactions.",
    "version": "2.0.0"
  },
  "servers": [
    {
      "url": "https://session.fountain.coach",
      "description": "Production server for Session and Context Management API"
    },
    {
      "url": "http://localhost:8080",
      "description": "Development server (Docker environment)"
    }
  ],
  "paths": {
    "/characters/{characterId}/context": {
      "get": {
        "summary": "Retrieve Character Context",
        "operationId": "getCharacterContext",
        "description": "Retrieves the current context for a specified character.",
        "parameters": [
          {
            "name": "characterId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Character context data.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "additionalProperties": {
                    "type": "string"
                  }
                }
              }
            }
          }
        }
      },
      "put": {
        "summary": "Update Character Context",
        "operationId": "updateCharacterContext",
        "description": "Updates the current context for a specified character.",
        "parameters": [
          {
            "name": "characterId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "additionalProperties": {
                  "type": "string"
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Character context updated."
          }
        }
      }
    },
    "/sessions": {
      "post": {
        "summary": "Create New Session",
        "operationId": "createSession",
        "description": "Creates a new session for the character, storing initial context data.",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "characterId": {
                    "type": "integer",
                    "description": "Unique identifier of the character."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Session created.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "sessionId": {
                      "type": "string",
                      "description": "Unique identifier for the created session."
                    },
                    "expiration": {
                      "type": "string",
                      "format": "date-time",
                      "description": "Expiration time of the session."
                    }
                  }
                }
              }
            }
          }
        }
      },
      "delete": {
        "summary": "End Session",
        "operationId": "endSession",
        "description": "Ends the session for the character, optionally clearing session-specific context data.",
        "parameters": [
          {
            "name": "sessionId",
            "in": "query",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "204": {
            "description": "Session ended."
          }
        }
      }
    },
    "/sessions/{sessionId}/renew": {
      "post": {
        "summary": "Renew Session",
        "operationId": "renewSession",
        "description": "Renews an existing session, extending its expiration.",
        "parameters": [
          {
            "name": "sessionId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Session renewed.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "sessionId": {
                      "type": "string",
                      "description": "Unique identifier for the renewed session."
                    },
                    "expiration": {
                      "type": "string",
                      "format": "date-time",
                      "description": "New expiration time of the session."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/nlu/contextual": {
      "post": {
        "summary": "Context-Aware NLU Processing",
        "operationId": "processContextualNLU",
        "description": "Processes user input with context-aware NLU, considering the character's current context.",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "characterId": {
                    "type": "integer",
                    "description": "Unique identifier of the character."
                  },
                  "userInput": {
                    "type": "string",
                    "description": "The user's input text to be processed."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "NLU processing result.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "intent": {
                      "type": "string",
                      "description": "Identified intent of the user input."
                    },
                    "entities": {
                      "type": "object",
                      "description": "Extracted entities from the user input.",
                      "additionalProperties": {
                        "type": "string"
                      }
                    },
                    "contextUpdates": {
                      "type": "object",
                      "description": "Suggested updates to the character's context based on the user input.",
                      "additionalProperties": {
                        "type": "string"
                      }
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
      "Character": {
        "type": "object",
        "description": "Represents a character entity within the screenplay application, containing details such as name, description, and associated script IDs. Caching via Redis optimizes retrieval performance.",
        "properties": {
          "characterId": {
            "type": "integer",
            "description": "Unique identifier for the character.",
            "example": 1
          },
          "name": {
            "type": "string",
            "description": "Name of the character.",
            "example": "Juliet"
          },
          "description": {
            "type": "string",
            "description": "

A brief description of the character and their role within the screenplay.",
            "example": "The heroine of Romeo and Juliet."
          },
          "scriptIds": {
            "type": "array",
            "description": "Array of script IDs where the character appears, can be empty if the character is not currently part of any script.",
            "items": {
              "type": "integer"
            },
            "example": [
              2,
              5,
              7
            ]
          },
          "paraphrases": {
            "type": "array",
            "description": "Array of paraphrases linked to this character, each with its own text and commentary.",
            "items": {
              "$ref": "#/components/schemas/Paraphrase"
            }
          },
          "preferences": {
            "type": "object",
            "description": "User-specific preferences and settings.",
            "additionalProperties": {
              "type": "string"
            }
          },
          "history": {
            "type": "array",
            "description": "List of recent interactions or accessed scripts.",
            "items": {
              "type": "string"
            }
          },
          "currentContext": {
            "type": "object",
            "description": "Current context of the character, including session-specific data.",
            "additionalProperties": {
              "type": "string"
            }
          }
        },
        "required": [
          "name"
        ]
      },
      "CharacterCreateRequest": {
        "type": "object",
        "description": "Schema defining the structure required to create a new character, including name and optionally a description.",
        "properties": {
          "name": {
            "type": "string",
            "description": "Name of the new character.",
            "example": "Juliet"
          },
          "description": {
            "type": "string",
            "description": "Description of the new character, outlining their role and significance.",
            "example": "The heroine of Romeo and Juliet."
          }
        },
        "required": [
          "name"
        ]
      },
      "Paraphrase": {
        "type": "object",
        "description": "Represents a paraphrased version of a script element (e.g., action), including textual paraphrase and commentary on the connection to the original. Redis caching improves retrieval times.",
        "required": [
          "originalId",
          "text",
          "commentary"
        ],
        "properties": {
          "paraphraseId": {
            "type": "integer",
            "format": "int64",
            "description": "The unique identifier for the Paraphrase, automatically generated upon creation."
          },
          "originalId": {
            "type": "integer",
            "description": "The ID of the original action to which this paraphrase is linked."
          },
          "text": {
            "type": "string",
            "description": "The paraphrased text of the original action."
          },
          "commentary": {
            "type": "string",
            "description": "An explanatory note on why the paraphrase is linked to the original action."
          }
        }
      },
      "Error": {
        "type": "object",
        "description": "Common error structure for the API.",
        "properties": {
          "message": {
            "type": "string",
            "description": "Description of the error encountered.",
            "example": "Required field missing: 'title'"
          }
        }
      }
    },
    "securitySchemes": {
      "BearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      }
    }
  },
  "security": [
    {
      "BearerAuth": []
    }
  ]
}
```

#### Importance of Sequence Numbers

- **Ensures Order**: Sequence numbers ensure that context updates and interactions occur in the correct order.
- **Logical Flow**: By following sequence numbers, the story progresses logically, making it easy to understand and follow.
- **Cohesiveness**: Helps in maintaining the coherence of the story, ensuring that each event or dialogue leads naturally to the next.

#### How the Central Sequence Service Supports the API

1. **Requesting Sequence Numbers**:
   - Each time a new context update or interaction is created, the API sends a request to the Central Sequence Service.
   - The service responds with the next available sequence number, ensuring that all elements are uniquely and consistently numbered.

2. **Maintaining Consistency**:
   - The Central Sequence Service maintains a global sequence number counter, ensuring that sequence numbers are unique and follow a continuous order.
   - This consistency is crucial for integrating elements from different parts of the story, whether they are context updates, sessions, or NLU results.

3. **Updating Elements**:
   - When updating existing elements, the API ensures that their sequence numbers remain unchanged unless explicitly modified.
   - This stability prevents disruption in the story's flow, maintaining the logical progression of events.

By leveraging the Central Sequence Service, the Session and Context Management API can efficiently manage the sequencing of context updates and interactions, ensuring a coherent and engaging narrative structure.