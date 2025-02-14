# 1. Positioning #
## Problem Statement ##
The problem of repetitive puzzle games affects casual players; the impact of which is the loss of interest in the game and wasted development time. 

## Product Position Statement ##
For casual players who enjoy puzzles, Upkeep is a game that combines the technical mechanics of puzzles with house restoration along with horror story elements. Unlike House Flipper, our product provides a more engaging experience that is less complicated or invested in the precise details of house restoration.

## Value Propisition & Customer Segement ##
We help casual and mid-core gamers enjoy a structured, engaging, and creatively fulfilling house restoration experience by combining unique puzzle mechanics with interactive storytelling and guided renovation tasks and offering light customization options, clear objectives, and non-repetitive challenges.

# 2. Stakeholders #
- Developers: people working to implement and maintain the game
- Users: players that primarily enjoy casual puzzle genres and actively play the game.
- Competitors: similar games such as House Flipper, Merge Mansion, The Repair House, and Unpacking
- Detractors: players who purely enjoy competetive, high-adrenaline experiences.

# 3. Functional Requirements #
- Puzzle Requirements
- Art Requirements
- Story Requirements
- Menu Requirements

# 4. Non-Functional Requirements #
- Performance
- Accessibility Settings
- Saving systems

# 5. Minimum Viable Product #
- A tutorial room that shows how the puzzles work.
- Playtest and find people to also playtest.
- Use the GD script built-in code tester to test for bugs.

# 6. Use Cases #
![Use-Cases](https://github.com/user-attachments/assets/78eacc6a-f4d7-4d37-8dff-a1046a1e6bd9)
-
## Use Case 1: ##
### Actor: ###
### Trigger: ###
### Pre-Conditions: ###
### Post-Conditions: ###
### Success Scenario: ###
### Alternate Scenario: ###
![Screenshot (27)](https://github.com/user-attachments/assets/553b039c-cb54-4bd0-96b9-4e053e2f6d16)

## Use Case 2: ##
### Actor: Player ###
### Trigger: Player completes a puzzle. ###
### Pre-Conditions: Puzzle has not been completed before. ###
### Post-Conditions: The environment has changed to reflect the progress made. ###
### Success Scenario: ###
- Player is within a valid puzzle.
- Player finishes the puzzle with a valid solution.
- Player is transitioned back to main game scene.
- Player's progress is reflected in the environmental change.
- Player is no longer able to do that object's puzzle
### Alternate Scenario: ###
- Player decides to exit the puzzle early.
- Player is transitioned back to the main scene.
- Player's environmental is not changed due to incomplete puzzle.
- Player is still able to interact with object again to re-attempt puzzle.

<img src="https://github.com/user-attachments/assets/af5555a4-6627-499a-a8e3-3f9f4bd088ee" width="545" height="395">

<img src="https://github.com/user-attachments/assets/77ca31a9-fd9f-4e73-815d-16e3a5b8b133" width="545" height="395">


## Use Case 3: Starting the Game ##
### Actor: Player ###
### Trigger: Player wants to open the game ###
### Pre-Conditions: Game is installed, player has proper device ###
### Post-Conditions: Game is running and player is at main menu ###
### Success Scenario: ###
1. Player clicks game icon to start it from a launcher
2. System verifies game and associated files
3. Executable begins running
4. Game initializes assets and required resources
5. Player reaches main menu
### Alternate Scenario: ###
#### Case 1: #### 
2. Player is missing game files 
3. System informs user of file error 
4. System provides user option to reinstall
#### Case 2: ####
2. Update is required for the game 
3. System prompts user to update game 
4. Player updates game 
5. Executable is begins running

![Title-Screen](https://github.com/user-attachments/assets/2b4559d9-0dab-4261-b462-b45615462eef)


# 7. User Stories #
## User Story 1: As a developer, I want to design creative assets so that I can make the game visually appealing. ##
- Priority: 3
- Estimate: 4 hours
## User Story 2: As a developer, I want to write a story script so that I can make a compelling narrative for the game. ##
- Priority: 2
- Estimate: 5 hours
## User Story 3: As a developer I want to be able to click and drag objects so that I can implement puzzles in the future that utilize this system. ##
- Priority: 5
- Estimate: 6 hours
## User Story 4: As a developer, I would like to come up with a physics system for later game development. ##
- Priority: 2
- Estimate: 4 hours
## User Story 5: As a developer I want to implement a system for moving a character with WASD or arrow keys so that I can use it in future puzzles. ##
- Priority: 4
- Estimate: 6 hours
## User Story 6: As a developer, I want an entity that reacts to movement for future development. ##
- Priority: 2
- Estimate: 8 hours

# 8. Issue Tracker #

[Issue Tracker](https://github.com/TJeffrey237/CS386Project/issues)

![image](https://github.com/user-attachments/assets/73412306-22f0-4733-b92c-8501232738e2)

