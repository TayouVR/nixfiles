#!/bin/sh

## to swap bootloader, e.g. switch between systemd-boot and grub
#sudo nixos-rebuild --install-bootloader switch --flake ./system/#nixosTayou

## regular rebuild
sudo nixos-rebuild switch --flake ./system/#nixosTayou
