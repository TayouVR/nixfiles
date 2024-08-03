#!/bin/sh

## to swap bootloader, e.g. switch between systemd-boot and grub
#sudo nixos-rebuild --install-bootloader switch --flake ./#nixosTayou

## regular rebuild
sudo nixos-rebuild --impure switch --flake ./#nixosTayou
