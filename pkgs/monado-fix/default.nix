{ pkgs, ... }:

pkgs.monado.overrideAttrs (prevAttrs: {
  # Check if patches exists before filtering
  patches = if (prevAttrs ? patches) then 
    prevAttrs.patches ++ [
      ./0001-Revert-a-bindings-Don-t-add-dpad-paths-to-all-paths.patch
    ]
  else 
    [ ./0001-Revert-a-bindings-Don-t-add-dpad-paths-to-all-paths.patch ];
})