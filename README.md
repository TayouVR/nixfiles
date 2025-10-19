# Tayous NixOS Configuration

This repository contains the NixOS configuration for my machines. 
The quality might be questionable as I'm still learning how to use nix.
I try to keep most configuration modular, but without introducing too much boilerplate complexity, to avoid making code hard to understand and follow.

## Structure

- **configs/**: Contains all configuration modules
  - **common/**: Common configuration modules shared across all machines
    - **required/**: Core modules that are required for all machines
      - **audio.nix**: PipeWire audio configuration
      - **boot.nix**: Boot configuration
      - **communication.nix**: Web browsers, email, and messaging applications
      - **desktop.nix**: Desktop environment configuration (KDE Plasma)
      - **development.nix**: Development tools and IDEs
      - **gaming.nix**: Gaming-related configuration and games
      - **git.nix**: Git configuration
      - **home.nix**: Home-manager configuration
      - **input.nix**: Keyboard and input method configuration
      - **locale.nix**: Localization settings
      - **networking.nix**: Network configuration
      - **nix.nix**: Nix package manager configuration
      - **shell.nix**: Shell configuration
      - **user.nix**: User account configuration
      - **utilities.nix**: System utilities and tools
    - **optional/**: Optional modules that can be enabled per-machine
      - **graphics/**: Graphics drivers
      - **vr/**: Virtual Reality configuration
  - **machine1/**: Configuration specific to the first machine (tayou-berlin)
  - **machine2/**: Configuration specific to the second machine (tayou-nixos)

- **homeModules/**: Home-manager modules
- **lib/**: Helper functions and utilities
- **pkgs/**: Custom packages
- **starship/**: Starship prompt configuration

## Usage

### Building and Applying Configuration

To build and apply the configuration for the current machine:

```bash
./apply-system.sh
```

To update the system:

```bash
./update-system.sh
```

## Customization

Each machine's configuration is defined in its own directory under `configs/`. The `default.nix` file in each machine directory imports the common modules and any machine-specific modules.

To add a new machine:

1. Create a new directory under `configs/` with the machine name
2. Create a `default.nix` file that imports the common modules and any machine-specific modules
3. Create a `hardware-configuration.nix` file with the hardware-specific configuration
4. Create a `configuration.nix` file with any machine-specific settings

## Modules

The configuration is organized into modules to reduce duplication and improve maintainability. Each module is responsible for a specific aspect of the system configuration.

### Common Required Modules

- **audio.nix**: Configures PipeWire audio
- **boot.nix**: Configures the boot loader
- **communication.nix**: Installs web browsers, email clients, and messaging applications
- **desktop.nix**: Configures the KDE Plasma desktop environment
- **development.nix**: Installs development tools and IDEs
- **gaming.nix**: Configures gaming-related settings and installs games
- **git.nix**: Configures Git
- **home.nix**: Configures home-manager
- **input.nix**: Configures keyboard layout and input methods
- **locale.nix**: Configures localization settings
- **networking.nix**: Configures networking
- **nix.nix**: Configures the Nix package manager
- **shell.nix**: Configures the shell
- **user.nix**: Configures user accounts
- **utilities.nix**: Installs system utilities and tools

### Common Optional Modules

- **graphics/**: Contains graphics driver configurations
  - **amd.nix**: AMD graphics configuration
  - **nvidia.nix**: NVIDIA graphics configuration
- **vr/**: Contains Virtual Reality configurations
  - **audio.nix**: VR-specific audio configuration
  - **monado.nix**: Monado OpenXR runtime configuration
  - **vr.nix**: Common VR settings
  - **vrchat.nix**: VRChat-specific configuration
  - **wlx-overlay-s.nix**: WlxOverlay configuration

nix build output:  
`[running/completed/expected built, running/completed/expected copied (MiB), MiB Downloaded]`
