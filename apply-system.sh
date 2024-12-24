#!/bin/sh

## to swap bootloader, e.g. switch between systemd-boot and grub
#sudo nixos-rebuild --install-bootloader switch --flake ./#tayou-berlin

## regular rebuild
sudo nixos-rebuild switch --flake ./#tayou-berlin

## dry run
#sudo nixos-rebuild dry-activate --flake ./#tayou-berlin
