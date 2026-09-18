{
  config,
  inputs,
  ...
}: {
  flake-file.nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

  flake.modules.nixos.base = {lib, ...}: let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    nix = {
      settings = {
        experimental-features = config.flake-file.nixConfig.experimental-features or [];
        accept-flake-config = true;
        substituters = config.flake-file.nixConfig.substituters or [];
        trusted-public-keys = config.flake-file.nixConfig.trusted-public-keys or [];
        trusted-users = ["root" "@wheel"];
      };

      channel.enable = false;

      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };
  };
}
