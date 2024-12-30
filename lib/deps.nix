{
  nLib,
  inputs,
  withSystem,
  ...
}:

{
  _module.args.deps.mkSystem =
    {
      hostname,
      modules,
      username,
      platform ? "x86_64-linux",
    }:

    {
      "${hostname}" = withSystem platform (
        {
          config,
          inputs',
          ...
        }:

        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              inputs'
              username
              nLib
              ;

            inherit (config) packages;
          };

          modules = [
            {
              networking.hostName = hostname;
              nixpkgs.hostPlatform.system = platform;
            }
          ] ++ modules;
        }
      );
    };
}
