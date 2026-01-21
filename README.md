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

## Infos

nix build output:  
`[running/completed/expected built, running/completed/expected copied (MiB), MiB Downloaded]`
