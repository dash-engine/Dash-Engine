# Contributing to Dash-Engine

Thank you for considering contributing to Dash Engine! Your support helps improve this game engine for everyone.

## Table of Contents

- [How to Contribute](#how-to-contribute)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Project Structure](#project-structure)
  - [Setting Up the Development Environment](#setting-up-the-development-environment)
- [Making Changes](#making-changes)
  - [Creating a Branch](#creating-a-branch)
  - [Implementing Changes](#implementing-changes)
  - [Committing Changes](#committing-changes)
  - [Pushing Changes](#pushing-changes)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Reporting Issues](#reporting-issues)
- [Code Style Guidelines](#code-style-guidelines)
- [Code of Conduct](#code-of-conduct)
- [Need Help?](#need-help)

## How to Contribute

You can contribute in several ways:

- Reporting bugs or issues.
- Suggesting new features or enhancements.
- Submitting pull requests with bug fixes or new features.
- Improving documentation.
- Assisting with code reviews or discussions.

## Getting Started

### Prerequisites

Ensure you have the following installed:

- [Godot Engine 4.3](https://godotengine.org/).
- [SPWN](https://github.com/Spu7Nix/SPWN) (required for compiling the project to geometry dash).

### Project Structure

Understanding the project hierarchy will help you navigate and contribute effectively:

- `assets/`: Contains game assets like images, sounds, etc.
- `examples/`: Includes example projects or scenes demonstrating engine capabilities.
- `scenes/`: Houses the main scenes used in the engine.
- `scripts/`: Contains GDScript files for various functionalities.
- `spwn/`: Includes SPWN scripts utilized by the engine.
- `compiler.tscn`, `main.tscn`, `object.tscn`: Key scene files for the engine.
- `global.gd`: Global script with essential functions and variables.
- `project.godot`: Godot project configuration file.

### Setting Up the Development Environment

1. **Clone the Repository**:
   ```
   git clone https://github.com/dash-engine/Dash-Engine.git
   ```

2. **Navigate to the Project Directory**:
   ```
   cd Dash-Engine
   ```

3. **Open the Project in Godot**:
   - Launch Godot Engine.
   - Click on "Import" and select the `project.godot` file from the cloned directory.

## Making Changes

### Creating a Branch

Before making changes, create a new branch to keep the `main` branch clean:

```
git checkout -b feature/your-feature-name
```

### Implementing Changes

- Follow existing code styles and conventions.
- Ensure your code is well-documented and easy to understand.
- If adding a new feature, include necessary documentation and examples.

### Committing Changes

Commit your changes with clear and descriptive messages:

```
git add .
git commit -m "Add: Description of the feature or fix"
```

### Pushing Changes

Push your branch to your forked repository:

```
git push origin feature/your-feature-name
```

## Submitting a Pull Request

1. Navigate to the original Dash-Engine repository.
2. Click on the "Pull Requests" tab.
3. Click "New Pull Request" and select your branch.
4. Provide a clear description of your changes and any related issues.

We will review your pull request and may request changes or provide feedback.

## Reporting Issues

If you encounter any issues or have suggestions:

1. Check if the issue already exists in the [Issues](https://github.com/dash-engine/Dash-Engine/issues) section.
2. If not, create a new issue with:
   - A clear and descriptive title.
   - Detailed description of the problem or suggestion.
   - Steps to reproduce the issue (if applicable).
   - Any relevant screenshots or logs.

## Need Help?

If you have questions or need assistance, feel free to open a discussion in the [Discussions](https://github.com/dash-engine/Dash-Engine/discussions) tab or comment on an existing issue.

Thank you for contributing to Dash-Engine! 
