# Description #
Upkeep is a 2D pixel art puzzle game that places players in the role of a house renovator. The core gameplay involves selecting renovation tasks and solving environment-based puzzles to restore homes for a variety of homeowners. With each house comes a unique set of puzzles and light storylines that are gradually revealed as the player progresses through the renovation process. Upkeep also emphasizes simplicity across all design aspects, including puzzle mechanics, user interface, and visual presentation. This approach allows for a greater range of accessibility between users while also engaging them in a simple and relaxing gameplay experience.

# Architecture #
The architecture for upkeep is designed to have organization between the scrips, scenes, and assets. Here we have separated the three categories into their own directories and sub-directories to help define the relationship and function of each folder or package. We wanted to adopt a client-server architecture for this project as well such that clients are able to send requests through scenes to the different types of server-side scripts that will update the game state.

![Package drawio](https://github.com/user-attachments/assets/68508820-9940-46f9-bfab-d060c366e879)

# Class Diagrams #
Present a refined class diagram of your system, including implementation details such as visibilities, attributes to represent associations, attribute types, return types, parameters, etc. The class diagram should match the code you have produced so far, but not be limited to it (e.g., it can contain classes not implemented yet). 

The difference between this class diagram and the one that you presented in D.3 is that the last focuses on the conceptual model of the domain while the former reflects the implementation. Therefore, the implementation details are relevant in this case. 

# Sequence Diagrams #
Use Case: User drags and places a puzzle object <br>
Actor: User <br>
Trigger: User decides to pick up an object. <br>
Pre-conditions: Given object is moveable. <br>
Post-condition: Object has been moved, and puzzle was checked for completion <br>
Success Scenario: <br>
1. User requests to move the object.
2. User is allowed to pick up and drag the object.
3. User drops object in any location.
4. The move from the user is finalized.
5. The puzzle is checked for completion.

Alternate Scenario: <br>
1. User requests to move the object.
2. Request to move object is denied, due to being locked in place or immoveable.
3. Object remains in same position.

![Deliverable5_Sequence_Diagram](https://github.com/user-attachments/assets/0f7caf0f-94d6-4a96-8ca4-d07f96bf5545)

# Design Patterns #
## Section 1 ##
Command design pattern from the Behavioral category. Different classes send requests to the server with just the request it and the data using the handle_request(action, data) method, providing the type of black box scope that is expected in this pattern.
 - Server: [Link to server class](https://github.com/TJeffrey237/CS386Project/blob/main/upkeep/scripts/server.gd)
 - Object: [Link to object class](https://github.com/TJeffrey237/CS386Project/blob/main/upkeep/scripts/object.gd)
 - Puzzle_controller: [Link to puzzle controller class](https://github.com/TJeffrey237/CS386Project/blob/main/upkeep/scripts/jigsaw_controller.gd)

![Deliverable_5_Design_Pattern_1](https://github.com/user-attachments/assets/ca701797-5470-4d5b-8721-304408e815ff)

## Section 2 ##
Singleton design pattern from the Creational category.
- Server: [Link to server class](https://github.com/TJeffrey237/CS386Project/blob/main/upkeep/scripts/server.gd)

![Singleton](https://github.com/user-attachments/assets/aec90c8e-3546-47b9-ba41-2a86826816cb)

# Design Principles #
**Single Responsibility Principle:** In our [placeable_object.gd](https://github.com/TJeffrey237/CS386Project/blob/main/upkeep/scripts/placeable_object.gd) script, we are following the single responsibility principle by limiting it's logic to only be for placeable objects all other behaviors are being inherited from it's parent class. However, the approach to the SRP can also be improved by splitting the code into even fewer roles by moving scene intialization and coordinating puzzle completion into the controller script. 

**Dependency Inversion Principle:** Looking at our [draggable_object.gd](https://github.com/TJeffrey237/CS386Project/blob/main/upkeep/scripts/draggable_object.gd) script, there are some issues with it depending directly on the concrete server as it makes requests. While there are good points such as the server acting as a centralized handler for game logic and unspread server logic, interaction between draggable_object.gd and server.gd for something such as requesting movement could be handled through an abstraction layer like signals so that DIP will be followed properly.

**Liskov Substitution Principle:** The [object.gd](https://github.com/TJeffrey237/CS386Project/blob/main/upkeep/scripts/object.gd) script follows the Liskov substitution principle such that scripts that inherit it's behavior correctly call super() and does not change what the function is expecting with the variables object_id and moveable. Further improvements could be made to include more explicit expectations within the script either by using @export and using documentation of the assumptions within the code to avoid violations of LSP.
