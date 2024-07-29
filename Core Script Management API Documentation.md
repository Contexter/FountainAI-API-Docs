### Core Script Management API Documentation

#### Overview
The Core Script Management API handles script management, including section headings, transitions, and orchestration-related functionalities. It integrates with the Central Sequence Service to ensure proper sequence numbering.

#### Key Features
- **Retrieve All Scripts**: Lists all screenplay scripts stored within the system.
- **Create New Script**: Creates a new screenplay script record in the system.
- **Retrieve Script by ID**: Retrieves the details of a specific screenplay script by its unique identifier.
- **Update Script by ID**: Updates an existing screenplay script with new details.
- **Delete Script by ID**: Deletes a specific screenplay script from the system.
- **Retrieve Section Headings**: Fetches a list of all Section Headings across scripts.
- **Create Section Heading**: Creates a new Section Heading within a script.
- **Generate and Execute Orchestration Files**: Generates and executes Csound, LilyPond, and MIDI files.

#### Data Flow and Integration
The Core Script Management API now integrates with the Central Sequence Service to manage sequence numbers. The sequence numbers ensure a logical reading flow by ordering sections, actions, and dialogues correctly.

### OpenAPI Specification

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "FountainAI Core Script Management API",
    "description": "This API handles script management, including section headings, transitions, and orchestration-related functionalities. It integrates with the Central Sequence Service for proper sequence numbering.",
    "version": "2.1.0"
  },
  "servers": [
    {
      "url": "https://core.fountain.coach",
      "description": "Production server for Core Script Management API"
    },
    {
      "url": "http://localhost:8080",
      "description": "Development server (Docker environment)"
    }
  ],
  "paths": {
    "/scripts": {
      "get": {
        "summary": "Retrieve All Scripts",
        "operationId": "listScripts",
        "description": "Lists all screenplay scripts stored within the system. This endpoint leverages Redis caching for improved query performance.",
        "responses": {
          "200": {
            "description": "An array of scripts.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Script"
                  }
                },
                "examples": {
                  "allScripts": {
                    "summary": "Example of retrieving all scripts",
                    "value": [
                      {
                        "scriptId": 1,
                        "title": "Sunset Boulevard",
                        "description": "A screenplay about Hollywood and faded glory.",
                        "author": "Billy Wilder",
                        "sequence": 1
                      }
                    ]
                  }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create a New Script",
        "operationId": "createScript",
        "description": "Creates a new screenplay script record in the system. Integrates with the Central Sequence Service to assign a sequence number.",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ScriptCreateRequest"
              },
              "examples": {
                "createScriptExample": {
                  "summary": "Example of script creation",
                  "value": {
                    "title": "New Dawn",
                    "description": "A story about renewal and second chances.",
                    "author": "Jane Doe"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Script successfully created.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Script"
                },
                "examples": {
                  "scriptCreated": {
                    "summary": "Example of a created script",
                    "value": {
                      "scriptId": 2,
                      "title": "New Dawn",
                      "description": "A story about renewal and second chances.",
                      "author": "Jane Doe",
                      "sequence": 1
                    }
                  }
                }
              }
            }
          },
          "400": {
            "description": "Bad request due to missing required fields.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "badRequestExample": {
                    "value": {
                      "message": "Missing required fields: 'title' or 'author'."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/scripts/{scriptId}": {
      "get": {
        "summary": "Retrieve a Script by ID",
        "operationId": "getScriptById",
        "description": "Retrieves the details of a specific screenplay script by its unique identifier (scriptId). Redis caching improves retrieval performance.",
        "parameters": [
          {
            "name": "scriptId",
            "in": "path",
            "required": true,
            "description": "Unique identifier of the screenplay script to retrieve.",
            "schema": {
              "type": "integer"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Detailed information about the requested script.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Script"
                },
                "examples": {
                  "retrievedScript": {
                    "summary": "Example of a retrieved script",
                    "value": {
                      "scriptId": 1,
                      "title": "Sunset Boulevard",
                      "description": "A screenplay about Hollywood and faded glory.",
                      "author": "Billy Wilder",
                      "sequence": 1
                    }
                  }
                }
              }
            }
          },
          "404": {
            "description": "The script with the specified ID was not found.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "notFoundExample": {
                    "value": {
                      "message": "Script not found with ID: 3"
                    }
                  }
                }
              }
            }
          }
        }
      },
      "put": {
        "summary": "Update a Script by ID",
        "operationId": "updateScript",
        "description": "Updates an existing screenplay script with new details. Integrates with the Central Sequence Service to assign a sequence number.",
        "parameters": [
          {
            "name": "scriptId",
            "in": "path",
            "required": true,
            "description": "Unique identifier of the screenplay script to update.",
            "schema": {
              "type": "integer"
            }
          }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ScriptUpdateRequest"
              },
              "examples": {
                "updateScriptExample": {
                  "summary": "Example of updating a script",
                  "value": {
                    "title": "Sunset Boulevard Revised",
                    "description": "Updated description with more focus on character development.",
                    "author": "Billy Wilder"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Script successfully updated.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Script"
                },
                "examples": {
                  "scriptUpdated": {
                    "summary": "Example of an updated script",
                    "value": {
                      "scriptId": 1,
                      "title": "Sunset Boulevard Revised",
                      "description": "Updated description with more focus on character development.",
                      "author": "Billy Wilder",
                      "sequence": 2
                    }
                  }
                }
              }
            }
          },
          "400": {
            "description": "Bad request due to invalid input data.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "badRequestUpdateExample": {
                    "value": {
                      "message": "Invalid input data: 'sequence' must be a positive number."
                    }
                  }
                }
              }
            }
          },
          "404": {
            "description": "The script with the specified ID was not found.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "notFoundUpdateExample": {
                    "value": {
                      "message": "Script not found with ID: 4"
                    }
                  }
                }
              }
            }
          }
        }
      },
      "delete": {
        "summary": "Delete a Script by ID",
        "operationId": "deleteScript",
        "description": "Deletes a specific screenplay script from the system, identified by its scriptId.",
        "parameters": [
          {
            "name": "scriptId",
            "in": "path",
            "required": true,
            "description": "Unique identifier of the screenplay script to delete.",
            "schema": {
              "type": "integer"
            }
          }
        ],
        "responses": {
          "204": {
            "description": "Script successfully deleted."
          },
          "404": {
            "description": "The

 script with the specified ID was not found.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "notFoundDeleteExample": {
                    "value": {
                      "message": "Script not found with ID: 5"
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/sectionHeadings": {
      "get": {
        "summary": "Retrieve Section Headings",
        "operationId": "listSectionHeadings",
        "description": "Fetches a list of all Section Headings across scripts, providing an overview of script structures. This endpoint leverages Redis caching to improve query performance.",
        "responses": {
          "200": {
            "description": "Successfully retrieved a JSON array of Section Headings.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/SectionHeading"
                  }
                },
                "examples": {
                  "sectionHeadingsExample": {
                    "value": [
                      {
                        "headingId": 1,
                        "scriptId": 101,
                        "title": "Introduction",
                        "sequence": 1
                      },
                      {
                        "headingId": 2,
                        "scriptId": 101,
                        "title": "Rising Action",
                        "sequence": 2
                      }
                    ]
                  }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create Section Heading",
        "operationId": "createSectionHeading",
        "description": "Creates a new Section Heading within a script, specifying its sequence, title, and associated script ID. Integrates with the Central Sequence Service to assign a sequence number.",
        "requestBody": {
          "required": true,
          "description": "Data required to create a new Section Heading.",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/SectionHeading"
              },
              "examples": {
                "createSectionHeadingExample": {
                  "value": {
                    "scriptId": 101,
                    "title": "Climax"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Successfully created a new Section Heading.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/SectionHeading"
                },
                "examples": {
                  "createdSectionHeading": {
                    "value": {
                      "headingId": 3,
                      "scriptId": 101,
                      "title": "Climax",
                      "sequence": 3
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/generate_csound_file": {
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
    "/generate_lilypond_file": {
      "post": {
        "summary": "Generate LilyPond File",
        "operationId": "generateLilyPondFile",
        "description": "Generates a `.ly` file based on preset orchestration settings.",
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
    "/generate_midi_file": {
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
    "/execute_csound": {
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
    "/execute_lilypond": {
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
      "Script": {
        "type": "object",
        "properties": {
          "scriptId": {
            "type": "integer",
            "description": "Unique identifier for the screenplay script."
          },
          "title": {
            "type": "string",
            "description": "Title of the screenplay script."
          },
          "description": {
            "type": "string",
            "description": "Brief description or summary of the screenplay script."
          },
          "author": {
            "type": "string",
            "description": "Author of the screenplay script."
          },
          "sequence": {
            "type": "integer",
            "description": "Sequence number assigned by the Central Sequence Service."
          }
        },
        "required": [
          "title",
          "author"
        ]
      },
      "ScriptCreateRequest": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string"
          },
          "description": {
            "type": "string"
          },
          "author": {
            "type": "string"
          }
        },
        "required": [
          "title",
          "author"
        ]
      },
      "ScriptUpdateRequest": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string"
          },
          "description": {
            "type": "string"
          },
          "author": {
            "type": "string"
          }
        }
      },
      "SectionHeading": {
        "type": "object",
        "description": "Represents a structural element within a script, marking the beginning of a new section. Integrates with the Central Sequence Service for sequence numbering.",
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
            "description": "Order sequence of the Section Heading within the script

, assigned by the Central Sequence Service."
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

#### How It Works

1. **Central Sequence Service**: This service ensures that every script, section, action, and dialogue is given a unique sequence number. This helps maintain the logical order of the story elements.

2. **Data Gathering**: The Core Script Management API collects data from various sources. It retrieves scripts, sections, and other elements and then assigns them sequence numbers using the Central Sequence Service.

3. **Logical Flow**: The sequence numbers ensure that the elements appear in the correct order when the story is read. This prevents any confusion and makes the story easy to follow.

#### Example of How It Works

1. **Creating a New Script**: When a new script is created, it gets a sequence number from the Central Sequence Service. This sequence number helps place the script in the correct order within the list of all scripts.

2. **Adding a Section Heading**: When a new section heading is added to a script, it also gets a sequence number from the Central Sequence Service. This ensures that the sections are read in the correct order within the script.

#### Why Sequence Numbers Are Important

- **Ensures Order**: Sequence numbers ensure that actions, dialogues, and context occur in the correct order.
- **Logical Flow**: By following sequence numbers, the story progresses logically, making it easy to understand and follow.
- **Cohesiveness**: Helps in maintaining the coherence of the story, ensuring that each event or dialogue leads naturally to the next.

By integrating the Central Sequence Service, the Core Script Management API ensures that all story elements are presented in a logical and coherent order.