#!/bin/sh

## to swap bootloader, e.g. switch between systemd-boot and grub
#sudo nixos-rebuild --install-bootloader switch --flake ./#nixosTayou

## regular rebuild
sudo nixos-rebuild switch --flake ./#nixosTayou

## dry run
#sudo nixos-rebuild dry-activate --flake ./#nixosTayou
