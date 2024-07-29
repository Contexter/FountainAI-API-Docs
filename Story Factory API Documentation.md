### Story Factory API Documentation

#### Overview
The Story Factory API is designed to gather and assemble information from multiple sources, providing a cohesive and logical reading flow for a story. It integrates data from the Core Script Management API, Session and Context Management API, and Character Management API, and utilizes the Central Sequence Service to ensure elements are ordered correctly.

#### Key Features
- **Retrieve Full Story**: Fetches a complete story, including sections, characters, actions, spoken words, context, and transitions.
- **Retrieve Story Sequences**: Retrieves specific sequences from a story, ensuring a logical flow.
- **Orchestration**: Supports orchestration functionalities, including generating and executing Csound, LilyPond, and MIDI files.

#### Data Flow and Integration
The Story Factory API relies on sequence numbers provided by the Central Sequence Service to enforce a logical reading flow. Each element within the story (characters, actions, spoken words, etc.) is assigned a sequence number, ensuring that the story can be read in the intended order.

##### Core Script Management API
- **Scripts**: The Story Factory retrieves the list of scripts and individual script details using this API.
- **Section Headings**: Section headings are included to mark the structure of the script.
- **Transitions**: Transitions between scenes are also managed by this API.

##### Session and Context Management API
- **Character Context**: The current context for each character can be retrieved and updated, providing necessary contextual data for the story.

##### Character Management API
- **Characters**: The list of characters and their details are retrieved from this API.
- **Actions**: Actions performed by characters are also managed here.
- **Spoken Words**: The dialogues or spoken words by characters are provided through this API.
- **Paraphrases**: Paraphrases for actions and spoken words are managed through this API.

### Example of Dialogue Exchange
The following example shows a dialogue exchange between two characters within an established sequence. Each element is assigned a sequence number to ensure a natural and logical reading flow.

```json
{
  "scriptId": 1,
  "title": "Romeo and Juliet",
  "author": "William Shakespeare",
  "description": "A tale of two star-crossed lovers.",
  "sections": [
    {
      "headingId": 1,
      "scriptId": 1,
      "title": "Act 1, Scene 1",
      "sequence": 1
    }
  ],
  "story": [
    {
      "sequence": 1,
      "character": {
        "characterId": 1,
        "name": "Juliet",
        "description": "The heroine of Romeo and Juliet."
      },
      "action": {
        "actionId": 1,
        "description": "Juliet stands on the balcony, looking out into the night."
      },
      "spokenWord": {
        "dialogueId": 1,
        "text": "O Romeo, Romeo! wherefore art thou Romeo?"
      },
      "context": {
        "contextId": 1,
        "characterId": 1,
        "data": {
          "mood": "longing",
          "location": "Capulet's mansion balcony"
        }
      }
    },
    {
      "sequence": 2,
      "character": {
        "characterId": 2,
        "name": "Romeo",
        "description": "The hero of Romeo and Juliet."
      },
      "action": {
        "actionId": 2,
        "description": "Romeo steps out from the shadows below the balcony."
      },
      "spokenWord": {
        "dialogueId": 2,
        "text": "By a name I know not how to tell thee who I am: My name, dear saint, is hateful to myself, Because it is an enemy to thee."
      },
      "context": {
        "contextId": 2,
        "characterId": 2,
        "data": {
          "mood": "desperate",
          "location": "Below Juliet's balcony"
        }
      }
    },
    {
      "sequence": 3,
      "character": {
        "characterId": 1,
        "name": "Juliet",
        "description": "The heroine of Romeo and Juliet."
      },
      "action": {
        "actionId": 3,
        "description": "Juliet leans over the balcony, reaching out towards Romeo."
      },
      "spokenWord": {
        "dialogueId": 3,
        "text": "What’s in a name? That which we call a rose By any other name would smell as sweet."
      },
      "context": {
        "contextId": 3,
        "characterId": 1,
        "data": {
          "mood": "curious",
          "location": "Capulet's mansion balcony"
        }
      }
    }
  ],
  "orchestration": {
    "csoundFilePath": "/files/sound.csd",
    "lilyPondFilePath": "/files/sheet.ly",
    "midiFilePath": "/files/music.mid"
  }
}
```

### Story Factory API Specification
Below is the full OpenAPI specification for the Story Factory API, ensuring that all necessary information from the three existing APIs is integrated and sequence numbers are managed by the Central Sequence Service.

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "FountainAI Story Factory API",
    "description": "This API assembles and manages the logical flow of stories by integrating data from the Core Script Management API, Session and Context Management API, and Character Management API, and utilizes the Central Sequence Service.",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://storyfactory.fountain.coach",
      "description": "Production server for Story Factory API"
    },
    {
      "url": "http://localhost:8080",
      "description": "Development server"
    }
  ],
  "paths": {
    "/stories": {
      "get": {
        "summary": "Retrieve Full Story",
        "operationId": "getFullStory",
        "description": "Fetches a complete story, including sections, characters, actions, spoken words, context, and transitions.",
        "parameters": [
          {
            "name": "scriptId",
            "in": "query",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "Unique identifier of the script to retrieve the story for."
          }
        ],
        "responses": {
          "200": {
            "description": "Full story retrieved successfully.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/FullStory"
                }
              }
            }
          },
          "404": {
            "description": "Script not found.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                }
              }
            }
          }
        }
      }
    },
    "/stories/sequences": {
      "get": {
        "summary": "Retrieve Story Sequences",
        "operationId": "getStorySequences",
        "description": "Retrieves specific sequences from a story, ensuring a logical flow.",
        "parameters": [
          {
            "name": "scriptId",
            "in": "query",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "Unique identifier of the script to retrieve sequences for."
          },
          {
            "name": "startSequence",
            "in": "query",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "The starting sequence number."
          },
          {
            "name": "endSequence",
            "in": "query",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "The ending sequence number."
          }
        ],
        "responses": {
          "200": {
            "description": "Story sequences retrieved successfully.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/StorySequence"
                }
              }
            }
          },
          "404": {
            "description": "Script or sequences not found.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                }
              }
            }
          }
        }
      }
    },
    "/orchestration/csound": {
      "post": {
        "summary": "Generate Csound File",
        "operationId": "generateCsoundFile",
        "description": "Generates a `.csd` file based on preset orchestration settings.",
        "responses": {
          "201": {
            "description": "Csound file successfully generated.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "csoundFilePath": {
                      "type": "string",
                      "description": "Path to the generated Csound file."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/orchestration/lilypond": {
      "post": {
        "summary": "Generate LilyPond File",
        "operationId": "generateLilyPondFile",
        "description": "

Generates a `.ly` file based on preset orchestration settings.",
        "responses": {
          "201": {
            "description": "LilyPond file successfully generated.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "lilyPondFilePath": {
                      "type": "string",
                      "description": "Path to the generated LilyPond file."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/orchestration/midi": {
      "post": {
        "summary": "Generate MIDI File",
        "operationId": "generateMIDIFile",
        "description": "Generates a `.mid` file based on preset orchestration settings.",
        "responses": {
          "201": {
            "description": "MIDI file successfully generated.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "midiFilePath": {
                      "type": "string",
                      "description": "Path to the generated MIDI file."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/orchestration/execute_csound": {
      "post": {
        "summary": "Execute Csound",
        "operationId": "executeCsound",
        "description": "Processes an existing `.csd` file using Csound.",
        "requestBody": {
          "required": true,
          "description": "JSON object specifying the path to the `.csd` file to process.",
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "csoundFilePath": {
                    "type": "string",
                    "description": "Path to the existing `.csd` file for processing."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Csound processing completed successfully.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "message": {
                      "type": "string",
                      "description": "Message indicating the success of Csound processing."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/orchestration/execute_lilypond": {
      "post": {
        "summary": "Execute LilyPond",
        "operationId": "executeLilyPond",
        "description": "Processes an existing `.ly` file using LilyPond.",
        "requestBody": {
          "required": true,
          "description": "JSON object specifying the path to the `.ly` file for processing.",
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "lilyPondFilePath": {
                    "type": "string",
                    "description": "Path to the existing `.ly` file for processing."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "LilyPond processing completed successfully.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "message": {
                      "type": "string",
                      "description": "Message indicating the success of LilyPond processing."
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
      "FullStory": {
        "type": "object",
        "properties": {
          "scriptId": {
            "type": "integer",
            "description": "Unique identifier of the script."
          },
          "title": {
            "type": "string",
            "description": "Title of the script."
          },
          "author": {
            "type": "string",
            "description": "Author of the script."
          },
          "description": {
            "type": "string",
            "description": "Brief description or summary of the script."
          },
          "sections": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/SectionHeading"
            }
          },
          "story": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/StoryElement"
            }
          },
          "orchestration": {
            "type": "object",
            "properties": {
              "csoundFilePath": {
                "type": "string",
                "description": "Path to the generated Csound file."
              },
              "lilyPondFilePath": {
                "type": "string",
                "description": "Path to the generated LilyPond file."
              },
              "midiFilePath": {
                "type": "string",
                "description": "Path to the generated MIDI file."
              }
            }
          }
        }
      },
      "SectionHeading": {
        "type": "object",
        "properties": {
          "headingId": {
            "type": "integer",
            "description": "Unique identifier for the Section Heading."
          },
          "scriptId": {
            "type": "integer",
            "description": "Identifier of the script this Section Heading belongs to."
          },
          "title": {
            "type": "string",
            "description": "Title of the Section Heading."
          },
          "sequence": {
            "type": "integer",
            "description": "Order sequence of the Section Heading within the script."
          }
        }
      },
      "StoryElement": {
        "type": "object",
        "properties": {
          "sequence": {
            "type": "integer",
            "description": "The sequence number of the story element, ensuring the correct order."
          },
          "character": {
            "$ref": "#/components/schemas/Character"
          },
          "action": {
            "$ref": "#/components/schemas/Action"
          },
          "spokenWord": {
            "$ref": "#/components/schemas/SpokenWord"
          },
          "context": {
            "$ref": "#/components/schemas/Context"
          }
        }
      },
      "Character": {
        "type": "object",
        "properties": {
          "characterId": {
            "type": "integer",
            "description": "Unique identifier for the character."
          },
          "name": {
            "type": "string",
            "description": "Name of the character."
          },
          "description": {
            "type": "string",
            "description": "A brief description of the character and their role within the screenplay."
          }
        }
      },
      "Action": {
        "type": "object",
        "properties": {
          "actionId": {
            "type": "integer",
            "description": "Unique identifier for the action."
          },
          "description": {
            "type": "string",
            "description": "A textual description outlining what happens in this action."
          }
        }
      },
      "SpokenWord": {
        "type": "object",
        "properties": {
          "dialogueId": {
            "type": "integer",
            "description": "Unique identifier for the SpokenWord entity."
          },
          "text": {
            "type": "string",
            "description": "The dialogue text of the SpokenWord entity."
          },
          "sequence": {
            "type": "integer",
            "description": "Order sequence of the SpokenWord within the script."
          }
        }
      },
      "Context": {
        "type": "object",
        "properties": {
          "contextId": {
            "type": "integer",
            "description": "Unique identifier for the context."
          },
          "characterId": {
            "type": "integer",
            "description": "Identifier of the character this context belongs to."
          },
          "data": {
            "type": "object",
            "description": "Context data for the character.",
            "additionalProperties": {
              "type": "string"
            }
          }
        }
      },
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

### Further Explanations
**Overview**

The Story Factory API gathers and assembles data from multiple sources to provide a cohesive and logical reading flow for a story. It integrates information from three existing APIs: Core Script Management API, Session and Context Management API, and Character Management API. The sequence numbers assigned to each element ensure that the story can be read in the intended order.

**How It Works**

- **Data Gathering**: The Story Factory API collects data from three existing APIs. These APIs provide information about scripts, sections, characters, actions, spoken words, and context.
- **Sequence Numbers**: Every element (script, section, action, spoken word, context) has a sequence number. This number is obtained from the Central Sequence Service and determines the order in which elements appear in the story.
- **Logical Flow**: By arranging elements according to their sequence numbers, the Story Factory API ensures that the story is presented in a coherent and logical order.

**Example of Dialogue Exchange**

Here’s a simple example to illustrate how dialogue exchanges between characters are ordered within a sequence:

- **Sequence 1**:
  - **Character**: Juliet
  - **Action**: Juliet

 stands on the balcony, looking out into the night.
  - **Spoken Word**: “O Romeo, Romeo! wherefore art thou Romeo?”
  - **Context**: Juliet is feeling longing and is on the Capulet’s mansion balcony.

- **Sequence 2**:
  - **Character**: Romeo
  - **Action**: Romeo steps out from the shadows below the balcony.
  - **Spoken Word**: “By a name I know not how to tell thee who I am: My name, dear saint, is hateful to myself, Because it is an enemy to thee.”
  - **Context**: Romeo is feeling desperate and is below Juliet’s balcony.

- **Sequence 3**:
  - **Character**: Juliet
  - **Action**: Juliet leans over the balcony, reaching out towards Romeo.
  - **Spoken Word**: “What’s in a name? That which we call a rose By any other name would smell as sweet.”
  - **Context**: Juliet is feeling curious and is on the Capulet’s mansion balcony.

**Why Sequence Numbers Are Important**

- **Ensures Order**: Sequence numbers ensure that actions, dialogues, and context occur in the correct order.
- **Logical Flow**: By following sequence numbers, the story progresses logically, making it easy to understand and follow.
- **Cohesiveness**: Helps in maintaining the coherence of the story, ensuring that each event or dialogue leads naturally to the next.

**How the Other APIs Support the Story Factory API**

- **Core Script Management API**:
  - Manages the structure of the script including sections and transitions.
  - Each section and transition is assigned a sequence number to ensure proper order by the Central Sequence Service.
  
- **Session and Context Management API**:
  - Manages the context for each character, including their state and interactions.
  - Provides necessary context data which is also sequenced to fit within the story flow by the Central Sequence Service.

- **Character Management API**:
  - Manages details of characters, their actions, and spoken words.
  - Actions and spoken words are ordered using sequence numbers from the Central Sequence Service to maintain the logical progression of the story.

By integrating sequence numbers from the Central Sequence Service and assembling all elements from the existing APIs, the Story Factory API provides a seamless and logical reading experience for the story.