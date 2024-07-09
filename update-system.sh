#!/bin/sh

## update nix channel
sudo nix-channel --update

## update current nixos configuration
#sudo nixos-rebuild switch --update

## update system flake
sudo nix flake update