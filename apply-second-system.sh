#!/bin/sh

## to swap bootloader, e.g. switch between systemd-boot and grub
#sudo nixos-rebuild --install-bootloader switch --flake ./#nixosTayouSecondary

## regular rebuild
sudo nixos-rebuild switch --flake ./#nixosTayouSecondary

## dry run
#sudo nixos-rebuild dry-activate --flake ./#nixosTayouSecondary
