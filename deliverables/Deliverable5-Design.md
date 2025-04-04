# Description #
Provide 1-2 paragraphs to describe your system. This will help understand the context of your design decisions. You can reuse and update text from the previous deliverables.

# Architecture #
Present a diagram of the high-level architectureLinks to an external site. of your system. Use a UML package diagram to describe the main modules and how they interrelate.

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
Split this section into 2 subsections. For each subsection, present a UML class diagram showing the application of a design patternLinks to an external site. to your system (a different pattern for each section). Each class diagram should contain only the classes involved in the specific pattern (you don’t need to represent the whole system). Choose patterns from two different categories: Behavioral, Structural, and Creational. You are not limited to design patterns studied in class. 

Your system may not be appropriate for any design pattern. In this case, for didactic purposes, be creative and extend a little bit the scope of your system to make the design patterns appropriate. 

Implement each design pattern in your system and provide GitHub links to the corresponding classes.

## Section 2 ##
...

# Design Principles #
How does your design observe the SOLID principles? Provide a short description of followed principles giving concrete examples from your classes. 
