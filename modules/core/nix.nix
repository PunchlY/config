{
  config,
  inputs,
  ...
}: let
  inherit (config.flake-file) nixConfig;
in {
  flake-file.nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

  den.default.nixos = {
    config,
    lib,
    ...
  }: {
    nix.settings = {
      experimental-features = nixConfig.experimental-features or [];
      accept-flake-config = true;
      substituters = nixConfig.substituters or [];
      trusted-public-keys = nixConfig.trusted-public-keys or [];
      trusted-users = ["root" "@wheel"];
    };

    nix.channel.enable = false;

    nix.registry =
      inputs
      |> lib.filterAttrs (_: lib.isType "flake")
      |> lib.mapAttrs (_: flake: {inherit flake;});

    sops.secrets."nix-access-tokens.conf" = {
      group = "wheel";
      mode = "0440";
    };

    nix.extraOptions = ''
      !include ${config.sops.secrets."nix-access-tokens.conf".path}
    '';
  };
}
