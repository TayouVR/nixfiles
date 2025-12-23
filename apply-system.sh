#!/bin/sh

## to swap bootloader, e.g. switch between systemd-boot and grub
#sudo nixos-rebuild --install-bootloader switch --flake ./#tayou-berlin

## regular rebuild
sudo nixos-rebuild switch --flake ./#tayou-berlin # --fallback
#sudo nixos-rebuild switch --log-format internal-json -v --flake ./#tayou-berlin |& nom --json

## dry run
#sudo nixos-rebuild dry-activate --flake ./#tayou-berlin
