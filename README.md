# Real Controller

A third-person character controller for Godot 4.6 with smooth locomotion, camera controls, and animation blending.

## Features

- **Locomotion System**: Walk, run, and sprint with 8-directional movement blending
- **Jump Mechanics**: Ground-based jumping with gravity handling
- **Camera Controls**: Third-person camera with configurable tilt limits and mouse sensitivity
- **Animation System**: Smooth animation blending using AnimationTree
- **Smooth Rotation**: Character mesh rotates smoothly to face movement direction

## Requirements

- Godot 4.6 or later

## Installation

1. Copy the `addons/real-controller` folder into your project's `addons` directory
2. Enable the addon in Project Settings > Plugins
3. Add the character scene (`addons/real-controller/character.tscn`) to your scene or use the example scene

## Setup

### Input Map Configuration

The controller requires the following input actions to be configured in your project:

1. Go to **Project > Project Settings > Input Map**
2. Add the following actions with their corresponding recommended inputs:

| Action | Keyboard 
|--------|----------	
| `forward` | W 	
| `backward` | S 	
| `left` | A 	
| `right` | D 	
| `jump` | Space 	
| `sprint` | Left Shift 	

> **Note**: These input mappings are required for the controller to function properly. Make sure all actions are configured before running the scene.


## Configuration

The controller exposes several export variables for customization:

- **Movement**: Speed, sprint speed, jump velocity
- **Camera**: Mouse sensitivity, tilt limit, rotation speed


## Credits

Animations and the Mesh are from the [Basic Motions Free](https://kevdev.itch.io/basic-motions-free).


## Todo

- [ ] Adding new animations from mixamo guide
- [ ] Change mesh guide
- [ ] Walk
- [ ] Crouch

## License

MIT License - See [LICENCE](LICENCE) file for details.
