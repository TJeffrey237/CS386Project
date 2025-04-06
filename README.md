# Upkeep #
Upkeep is a 2D-pixel art puzzle experience where players take on the role of a house renovator, selecting tasks and solving puzzles to restore a home for various owners. As an added aspect, players can also engage in small storylines related to each house that is slowly uncovered throughout the renovation process. This game is primarily designed for simplicity in all aspects of gameplay such as puzzle completion, menu navigation, and the art style.

# Getting Started #
**Prerequisites** 
1. Install Godot Game Engine: [download link](https://godotengine.org/download/windows/)
2. Install Git: [download link](https://git-scm.com/downloads)

**Installing**
1. Clone repository using the link: [https://github.com/TJeffrey237/CS386Project.git](https://github.com/TJeffrey237/CS386Project.git)
2. Open Project in Godot
    1. Launch the Godot game engine
    2. Click "Import" -> "Browse"
    3. Click "Open" and wait for the project to load
3. Running the Game
    1. Press **F5** or click "Play" in the editor

# Running the Tests #
1. Install GUT:
    1. Download the GUT plugin from GUT's GitHub page. You can also install it through the Asset Library in the Godot Editor.
2. Enable the GUT Plugin:
    1. In your Godot project, go to Project -> Project Settings -> Plugins.
    2. Find GUT in the list and set it to "Active."
3. Create Test Scripts:
    1. Unit tests are typically written in GDScript.
    2. Create a script (e.g., test_my_script.gd) inside the tests folder in your project.
    3. Each test method should start with func test_ for GUT to recognize it.
4. Run the Tests:
    1. Open the Test Runner by clicking on Project -> GUT Test Runner.
    2. From the Test Runner window, you can run all tests or select specific ones to run.
5. Results:
    1. After running the tests, the results will show up in the GUT Test Runner or the terminal. Each test will be marked as "pass" or "fail."

# Deployment #
This software is download only. 

# Built With #
[Godot-4.4](https://godotengine.org/) - Godot is a very lightweight and simple game engine that utilizes an easy-to-pick-up Node and Scene system. The engine also has support for GDScript, C#, and C++ languages as well as extensive documentation for the creation of 2D-oriented game development.

[GUT](https://github.com/bitwes/Gut) - Plugin for the Godot game engine that provides tools to write and run unit tests for your game scripts. It enables developers to verify the correctness of their code by writing automated tests in GDScript. Integrates directly into the Godot editor, offering a test runner interface where you can easily execute tests, view results, and debug issues.

[Pixelorama](https://orama-interactive.itch.io/pixelorama) - Pixel art multitool that allows us to create sprites, tiles, and animations. Has a very simple UI design has lots of support for autosaving, layers, and export formats, and is fully free to utilize.

# Contributing #
For information about contributing to this project see [CONTRIBUTING.md](https://github.com/TJeffrey237/CS386Project/blob/main/CONTRIBUTING.md).

# Versioning #
We use [SemVer](https://semver.org/) for versioning. To see available versions, look at the tags on this repository.

# Authors #
- Tyler Jeffrey
- Jackson Belzer
- Richelle Rouleau

# License #
This software is licensed under the MIT license - see [LICENSE](https://github.com/TJeffrey237/CS386Project/blob/main/LICENSE) for details.
