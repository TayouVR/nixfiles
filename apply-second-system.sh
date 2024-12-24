#!/bin/sh

## to swap bootloader, e.g. switch between systemd-boot and grub
#sudo nixos-rebuild --install-bootloader switch --flake ./#tayou-gw

## regular rebuild
sudo nixos-rebuild switch --flake ./#tayou-gw

## dry run
#sudo nixos-rebuild dry-activate --flake ./#tayou-gw
