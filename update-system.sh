#!/bin/sh

## update nix channel
sudo nix-channel --update

## update current nixos configuration
sudo nixos-rebuild switch --update

## update system flake
pushd system/
sudo nix flake update
popd