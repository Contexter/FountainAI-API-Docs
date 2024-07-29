
### Character Management API Documentation

#### Overview
The Character Management API handles character management, including actions, spoken words, and their paraphrases. It now integrates with the Central Sequence Service to assign sequence numbers, ensuring a logical and cohesive story flow.

#### Key Features
- Retrieve All Characters: Lists all characters stored within the application.
- Create a New Character: Allows for the creation of a new character.
- Retrieve and Manage Actions: Lists, creates, and manages actions associated with characters.
- Retrieve and Manage Spoken Words: Lists, creates, and manages dialogues associated with characters.
- Retrieve and Manage Paraphrases: Lists, creates, and manages paraphrases for actions and spoken words.

#### Updated Data Flow and Integration
The Character Management API now uses the Central Sequence Service to assign sequence numbers to actions and spoken words. This ensures a logical flow of the story elements.

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "FountainAI Character Management API",
    "description": "This API handles character management, including actions, spoken words, and their paraphrases. Now integrates with the Central Sequence Service to ensure logical sequence numbering.",
    "version": "2.0.0"
  },
  "servers": [
    {
      "url": "https://character.fountain.coach",
      "description": "Production server for Character Management API"
    },
    {
      "url": "http://localhost:8080",
      "description": "Development server (Docker environment)"
    }
  ],
  "paths": {
    "/characters": {
      "get": {
        "summary": "Retrieve All Characters",
        "operationId": "listCharacters",
        "description": "Lists all characters stored within the application, offering an overview of the characters available for screenplay development. This endpoint leverages Redis caching to improve query performance.",
        "responses": {
          "200": {
            "description": "A JSON array of character entities.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Character"
                  }
                },
                "examples": {
                  "characterListExample": {
                    "summary": "Example of character listing",
                    "value": [
                      {
                        "characterId": 1,
                        "name": "Juliet",
                        "description": "The heroine of Romeo and Juliet.",
                        "scriptIds": [
                          2,
                          5,
                          7
                        ]
                      },
                      {
                        "characterId": 2,
                        "name": "Romeo",
                        "description": "The hero of Romeo and Juliet.",
                        "scriptIds": [
                          2,
                          5,
                          7
                        ]
                      }
                    ]
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal server error indicating a failure to process the request.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to retrieve characters."
                    }
                  }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create a New Character",
        "operationId": "createCharacter",
        "description": "Allows for the creation of a new character, adding to the pool of characters available for inclusion in screenplays. RedisAI is integrated to provide recommendations and validation for character creation.",
        "requestBody": {
          "required": true,
          "description": "A JSON object detailing the new character to be created.",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/CharacterCreateRequest"
              },
              "examples": {
                "createCharacterExample": {
                  "summary": "Example of creating a new character",
                  "value": {
                    "name": "Mercutio",
                    "description": "A close friend of Romeo with a wild, energetic personality."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Character successfully created, returning the new character entity.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Character"
                },
                "examples": {
                  "createCharacterResponseExample": {
                    "summary": "Successful character creation example",
                    "value": {
                      "characterId": 3,
                      "name": "Mercutio",
                      "description": "A close friend of Romeo with a wild, energetic personality.",
                      "scriptIds": []
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
                  "badRequestExample": {
                    "summary": "Bad request example",
                    "value": {
                      "code": 400,
                      "message": "Bad Request - Missing name field in request body."
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal server error indicating a failure in creating the character.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to create character."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/characters/{characterId}/paraphrases": {
      "get": {
        "summary": "Retrieve All Paraphrases for a Character",
        "operationId": "listCharacterParaphrases",
        "description": "Retrieves all paraphrases linked to a specific character, including a commentary on why each paraphrase is connected to the original character. Redis caching improves retrieval performance.",
        "parameters": [
          {
            "name": "characterId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "Unique identifier of the character whose paraphrases are to be retrieved."
          }
        ],
        "responses": {
          "200": {
            "description": "A JSON array of paraphrases for the specified character.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Paraphrase"
                  }
                },
                "examples": {
                  "paraphraseListExample": {
                    "summary": "Example list of paraphrases",
                    "value": [
                      {
                        "paraphraseId": 1,
                        "originalId": 1,
                        "text": "Juliet, a young woman of Verona.",
                        "commentary": "Simplified description for younger audiences."
                      },
                      {
                        "paraphraseId": 2,
                        "originalId": 1,
                        "text": "Juliet, the love interest of Romeo in the classic tale.",
                        "commentary": "Adapted description for modern retellings."
                      }
                    ]
                  }
                }
              }
            }
          },
          "404": {
            "description": "The specified character was not found.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "notFoundExample": {
                    "summary": "Not found example",
                    "value": {
                      "code": 404,
                      "message": "Not Found - The character specified does not exist."
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal server error indicating a failure to retrieve the paraphrases.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to retrieve paraphrases."
                    }
                  }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create a New Paraphrase for a Character",
        "operationId": "createCharacterParaphrase",
        "description": "Allows for the creation of a new paraphrase linked to a character. Clients must provide the paraphrased text and a commentary explaining the link to the original character. RedisAI integration provides additional validation.",
        "parameters": [
          {
            "name": "characterId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "The unique identifier of the character to which the paraphrase will be linked."
          }
        ],
        "requestBody": {
          "required": true,
          "description": "A JSON object containing the new paraphrase's details and its link commentary.",
         

 "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Paraphrase"
              },
              "examples": {
                "createParaphraseExample": {
                  "summary": "Example of creating a new paraphrase",
                  "value": {
                    "originalId": 1,
                    "text": "Juliet, the star-crossed lover from Shakespeare's famous play.",
                    "commentary": "Contextualized description for educational purposes."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "The paraphrase has been successfully created.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Paraphrase"
                },
                "examples": {
                  "createParaphraseResponseExample": {
                    "summary": "Successful paraphrase creation example",
                    "value": {
                      "paraphraseId": 3,
                      "originalId": 1,
                      "text": "Juliet, the star-crossed lover from Shakespeare's famous play.",
                      "commentary": "Contextualized description for educational purposes."
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
                  "badRequestExample": {
                    "summary": "Bad request example",
                    "value": {
                      "code": 400,
                      "message": "Bad Request - Missing or incorrect fields in request body."
                    }
                  }
                }
              }
            }
          },
          "404": {
            "description": "The specified character was not found.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "notFoundExample": {
                    "summary": "Not found example",
                    "value": {
                      "code": 404,
                      "message": "Not Found - The character specified does not exist."
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal server error indicating a failure in creating the paraphrase.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to create the paraphrase."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/actions": {
      "get": {
        "summary": "Retrieve All Actions",
        "operationId": "listActions",
        "description": "Lists all actions currently stored within the system. This endpoint leverages Redis caching for optimized query performance.",
        "responses": {
          "200": {
            "description": "A JSON array of action entities.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Action"
                  }
                },
                "examples": {
                  "actionsExample": {
                    "summary": "Example of an actions list",
                    "value": [
                      {
                        "actionId": 1,
                        "description": "Character enters the room.",
                        "sequence": 1
                      },
                      {
                        "actionId": 2,
                        "description": "Character picks up a book.",
                        "sequence": 2
                      }
                    ]
                  }
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized - Invalid or missing authentication token.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "unauthorizedExample": {
                    "summary": "Unauthorized request example",
                    "value": {
                      "code": 401,
                      "message": "Unauthorized - Authentication token is missing or invalid."
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal Server Error - Error fetching data from the server.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to retrieve actions."
                    }
                  }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create a New Action",
        "operationId": "createAction",
        "description": "Allows for the creation of a new action entity. Clients must provide an action description and its sequence within a script. This endpoint integrates with the Central Sequence Service to assign sequence numbers.",
        "requestBody": {
          "required": true,
          "description": "A JSON object containing the new action's details.",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ActionCreateRequest"
              },
              "examples": {
                "createActionExample": {
                  "summary": "Example of creating an action",
                  "value": {
                    "description": "Character shouts for help.",
                    "sequence": 3
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "The action has been successfully created.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Action"
                },
                "examples": {
                  "createActionResponseExample": {
                    "summary": "Successful action creation example",
                    "value": {
                      "actionId": 3,
                      "description": "Character shouts for help.",
                      "sequence": 3
                    }
                  }
                }
              }
            }
          },
          "400": {
            "description": "Bad Request - Missing or invalid data in the request body.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "badRequestExample": {
                    "summary": "Bad request example",
                    "value": {
                      "code": 400,
                      "message": "Bad Request - Data format is incorrect or missing fields."
                    }
                  }
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized - Invalid or missing authentication token.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "unauthorizedExample": {
                    "summary": "Unauthorized request example",
                    "value": {
                      "code": 401,
                      "message": "Unauthorized - Authentication token is missing or invalid."
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal Server Error - Error creating the action.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to create the action."
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/actions/{actionId}/paraphrases": {
      "get": {
        "summary": "Retrieve All Paraphrases for an Action",
        "operationId": "listActionParaphrases",
        "description": "Retrieves all paraphrases linked to a specific action. This includes commentary on why each paraphrase is connected to the original action. Leverages Redis caching for improved query performance.",
        "parameters": [
          {
            "name": "actionId",
            "in": "path",
            "required": true,
            "description": "The unique identifier of the action whose paraphrases are to be retrieved.",
            "schema": {
              "type": "integer"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "A JSON array of paraphrases for the specified action.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Paraphrase"
                  }
                },
                "examples": {
                  "paraphrasesExample": {
                    "summary": "Example list of paraphrases",
                    "value": [
                      {
                        "paraphraseId": 1,
                        "originalId": 1,
                        "text": "Character enters the stage.",
                        "commentary": "Rephrased to fit a theatrical context."
                      },
                      {
                        "paraphraseId": 2,
                        "originalId": 1,
                        "text": "Character steps into the scene.",
                        "commentary": "Adjusted for a screenplay format."
                      }
                    ]
                  }
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized - Invalid or missing authentication token.",
            "content": {
             

 "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "unauthorizedExample": {
                    "summary": "Unauthorized request example",
                    "value": {
                      "code": 401,
                      "message": "Unauthorized - Authentication token is missing or invalid."
                    }
                  }
                }
              }
            }
          },
          "404": {
            "description": "Not Found - The specified action does not exist.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "notFoundExample": {
                    "summary": "Not found example",
                    "value": {
                      "code": 404,
                      "message": "Not Found - The action specified does not exist."
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal Server Error - Error fetching paraphrases from the server.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to retrieve paraphrases."
                    }
                  }
                }
              }
            }
          }
        ]
      },
      "post": {
        "summary": "Create a New Paraphrase for an Action",
        "operationId": "createActionParaphrase",
        "description": "Allows for the creation of a new paraphrase linked to an action. Clients must provide the paraphrased text and a commentary explaining the link to the original action. RedisAI integration provides additional validation.",
        "parameters": [
          {
            "name": "actionId",
            "in": "path",
            "required": true,
            "description": "The unique identifier of the action to which the paraphrase will be linked.",
            "schema": {
              "type": "integer"
            }
          }
        ],
        "requestBody": {
          "required": true,
          "description": "A JSON object containing the new paraphrase's details and its link commentary.",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Paraphrase"
              },
              "examples": {
                "createParaphraseExample": {
                  "summary": "Example of creating a paraphrase",
                  "value": {
                    "originalId": 1,
                    "text": "Character makes an entrance.",
                    "commentary": "Simplified for better understanding in educational scripts."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "The paraphrase has been successfully created.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Paraphrase"
                },
                "examples": {
                  "createParaphraseResponseExample": {
                    "summary": "Successful paraphrase creation example",
                    "value": {
                      "paraphraseId": 3,
                      "originalId": 1,
                      "text": "Character makes an entrance.",
                      "commentary": "Simplified for better understanding in educational scripts."
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
                  "badRequestExample": {
                    "summary": "Bad request example",
                    "value": {
                      "code": 400,
                      "message": "Bad Request - Data format is incorrect or missing fields."
                    }
                  }
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized - Invalid or missing authentication token.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "unauthorizedExample": {
                    "summary": "Unauthorized request example",
                    "value": {
                      "code": 401,
                      "message": "Unauthorized - Authentication token is missing or invalid."
                    }
                  }
                }
              }
            }
          },
          "404": {
            "description": "Not Found - The specified action does not exist.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "notFoundExample": {
                    "summary": "Not found example",
                    "value": {
                      "code": 404,
                      "message": "Not Found - The action specified does not exist."
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal Server Error - Error creating the paraphrase.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                },
                "examples": {
                  "internalServerErrorExample": {
                    "summary": "Internal server error example",
                    "value": {
                      "code": 500,
                      "message": "Internal Server Error - Unable to create the paraphrase."
                    }
                  }
                }
              }
            }
          }
        ]
      }
    },
    "/spokenWords": {
      "get": {
        "summary": "Retrieve All SpokenWords",
        "operationId": "getSpokenWords",
        "description": "Fetches a list of all SpokenWords entities in the system, providing an overview of spoken dialogues. This endpoint leverages Redis caching to improve query performance.",
        "responses": {
          "200": {
            "description": "Successfully retrieved a list of SpokenWords.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/SpokenWord"
                  }
                },
                "examples": {
                  "spokenWordsExample": {
                    "summary": "Example of retrieving all spoken words",
                    "value": [
                      {
                        "dialogueId": 1,
                        "text": "Hello there, how are you?",
                        "sequence": 1
                      },
                      {
                        "dialogueId": 2,
                        "text": "I'm fine, thank you!",
                        "sequence": 2
                      }
                    ]
                  }
                }
              }
            }
          }
        ]
      },
      "post": {
        "summary": "Create SpokenWord",
        "operationId": "createSpokenWord",
        "description": "Creates a new SpokenWord entity with provided dialogue text and sequence within the script. This endpoint integrates with the Central Sequence Service to assign sequence numbers.",
        "requestBody": {
          "required": true,
          "description": "Details for the new SpokenWord entity to be created.",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/SpokenWordCreateRequest"
              },
              "examples": {
                "createSpokenWordExample": {
                  "value": {
                    "text": "Suddenly, he was gone.",
                    "sequence": 3
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Successfully created a new SpokenWord entity.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/SpokenWord"
                },
                "examples": {
                  "createdSpokenWord": {
                    "summary": "Example of a created spoken word",
                    "value": {
                      "dialogueId": 3,
                      "text": "Suddenly, he was gone.",
                      "sequence": 3
                    }
                  }
                }
              }
            }
          }
        ]
      }
    },
    "/spokenWords/{id}/paraphrases": {
      "get": {
        "summary": "Retrieve All Paraphrases for a SpokenWord",
        "operationId": "listSpokenWordParaphrases",
        "description": "Retrieves all paraphrases linked to a specific SpokenWord, including a commentary on why each paraphrase is connected to the original dialogue. This endpoint leverages Redis caching for improved query performance.",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "Unique identifier of the SpokenWord whose paraphrases are to be retrieved."
          }
        ],
        "responses": {
          "200": {
            "description": "A JSON array of paraphrases for the specified SpokenWord.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Paraphrase"
                  }
                },
                "examples": {
                  "paraphrasesExample": {
                    "summary": "Example of paraphrases linked to a SpokenWord",
                    "value": [
                      {
                        "paraphraseId": 1,
                        "originalId": 1,
                        "text": "Hi there, how's it going?",
                        "commentary": "A more casual rephrasing."
                      },
                      {
                        "paraphraseId": 2,
                        "originalId": 2,
                       

 "text": "I'm well, thanks for asking!",
                        "commentary": "A polite response."
                      }
                    ]
                  }
                }
              }
            }
          }
        ]
      },
      "post": {
        "summary": "Create a New Paraphrase for a SpokenWord",
        "operationId": "createSpokenWordParaphrase",
        "description": "Allows for the creation of a new paraphrase linked to a SpokenWord. Clients must provide the paraphrased text and a commentary explaining the link to the original dialogue. RedisAI provides validation and analysis for paraphrase creation.",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer"
            },
            "description": "The unique identifier of the SpokenWord to which the paraphrase will be linked."
          }
        ],
        "requestBody": {
          "required": true,
          "description": "A JSON object containing the new paraphrase's details and its link commentary.",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Paraphrase"
              },
              "examples": {
                "createParaphraseExample": {
                  "summary": "Example of creating a paraphrase",
                  "value": {
                    "originalId": 1,
                    "text": "Greetings, how do you do?",
                    "commentary": "Formal version for a different context."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "The paraphrase has been successfully created.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Paraphrase"
                },
                "examples": {
                  "createdParaphrase": {
                    "summary": "Example of a created paraphrase",
                    "value": {
                      "paraphraseId": 3,
                      "originalId": 1,
                      "text": "Greetings, how do you do?",
                      "commentary": "Formal version for a different context."
                    }
                  }
                }
              }
            }
          }
        ]
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
            "description": "A brief description of the character and their role within the screenplay.",
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
      "Action": {
        "type": "object",
        "description": "Represents a single action within a script, detailing what happens at this step and its order relative to other actions. Caching via Redis optimizes retrieval.",
        "required": [
          "description"
        ],
        "properties": {
          "actionId": {
            "type": "integer",
            "format": "int64",
            "description": "The unique identifier for the Action, automatically generated upon creation."
          },
          "description": {
            "type": "string",
            "description": "A textual description outlining what happens in this action."
          },
          "sequence": {
            "type": "integer",
            "format": "int32",
            "description": "The numerical order of the action within its script, used to organize actions sequentially."
          },
          "paraphrases": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/Paraphrase"
            }
          }
        }
      },
      "ActionCreateRequest": {
        "type": "object",
        "description": "Schema defining the structure required to create a new action, including description and its sequence.",
        "properties": {
          "description": {
            "type": "string",
            "description": "A textual description outlining what happens in this action."
          }
        }
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
      "SpokenWord": {
        "type": "object",
        "description": "Represents a dialogue or spoken word within the script, identified by a unique ID, text, and sequence order. Caching via Redis improves query performance.",
        "required": [
          "dialogueId",
          "text",
          "sequence"
        ],
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
      "SpokenWordCreateRequest": {
        "type": "object",
        "description": "Schema defining the structure required to create a new SpokenWord, including text and its sequence.",
        "properties": {
          "text": {
            "type": "string",
            "description": "The dialogue text of the SpokenWord entity."
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

### Further Explanations

#### Overview

The Character Management API  integrates with the Central Sequence Service to ensure that all actions, spoken words, and paraphrases are assigned proper sequence numbers. This integration guarantees a logical reading flow for the story, maintaining consistency and coherence across all story elements.

#### How It Works

1. **Central Sequence Service Integration**: 
   - The Character Management API interacts with the Central Sequence Service to obtain sequence numbers for new actions, spoken words, and paraphrases. This centralization ensures that all elements follow a consistent order across different scripts and sections.

2. **Data Flow**:
   - When creating new actions, spoken words, or paraphrases, the API requests a sequence number from the Central Sequence Service.
   - The service provides a unique sequence number, which is then assigned to the new element.
   - This sequence number dictates the position of the element within the story, ensuring it appears in the correct order relative to other elements.

3. **Logical Flow**:
   - By assigning sequence numbers centrally, the API ensures that all elements (characters, actions, spoken words) are presented in a coherent and logical order.
   - This ordering is critical for maintaining the narrative flow of the story, making it easy to read and understand.

#### Example of Dialogue Exchange

Here’s an example to illustrate how dialogue exchanges between characters are ordered within a sequence using the Central Sequence Service:

1. **Sequence 1**:
   - **Character**: Juliet
   - **Action**: Juliet stands on the balcony, looking out into the night.
   - **Spoken Word**: "O Romeo, Romeo! wherefore art thou Romeo?"
   - **Context**: Juliet is feeling longing and is on the Capulet’s mansion balcony.

2. **Sequence 2**:
   - **Character**: Romeo
   - **Action**: Romeo steps out from the shadows below the balcony.
   - **Spoken Word**: "By a name I know not how to tell thee who I am: My name, dear saint, is hateful to myself, Because it is an enemy to thee."
   - **Context**: Romeo is feeling desperate and is below Juliet’s balcony.

3. **Sequence 3**:
   - **Character**: Juliet
   - **Action**: Juliet leans over the balcony, reaching out towards Romeo.
   - **Spoken Word**: "What’s in a name? That which we call a rose By any other name would smell as sweet."
   - **Context**: Juliet is feeling curious and is on the Capulet’s mansion balcony.

#### Importance of Sequence Numbers

- **Ensures Order**: Sequence numbers ensure that actions, dialogues, and context occur in the correct order.
- **Logical Flow**: By following sequence numbers, the story progresses logically, making it easy to understand and follow.
- **Cohesiveness**: Helps in maintaining the coherence of the story, ensuring that each event or dialogue leads naturally to the next.

#### How the Central Sequence Service Supports the API

1. **Requesting Sequence Numbers**:
   - Each time a new action, spoken word, or paraphrase is created, the API sends a request to the Central Sequence Service.
   - The service responds with the next available sequence number, ensuring that all elements are uniquely and consistently numbered.

2. **Maintaining Consistency**:
   - The Central Sequence Service maintains a global sequence number counter, ensuring that sequence numbers are unique and follow a continuous order.
   - This consistency is crucial for integrating elements from different parts of the story, whether they are actions, dialogues, or paraphrases.

3. **Updating Elements**:
   - When updating existing elements, the API ensures that their sequence numbers remain unchanged unless explicitly modified.
   - This stability prevents disruption in the story's flow, maintaining the logical progression of events.

By leveraging the Central Sequence Service, the Character Management API can efficiently manage the sequencing of story elements, ensuring a coherent and engaging narrative structure.