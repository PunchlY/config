{
  inputs,
  den,
  lib,
  ...
}: {
  imports = [inputs.flake-file.flakeModules.auto-follow];

  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  flake-file.nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  den.schema.host.includes = [
    ({host}:
      den.batteries.forward {
        each = [host];
        fromClass = _: "nixpkgs";
        intoClass = {class, ...}: class;
        intoPath = _: ["nixpkgs"];
        adaptArgs = lib.id;
      })
  ];

  den.schema.flake-system.includes = [
    den.policies.system-to-flake-parts
  ];
  den.schema.flake-system.excludes = [
    den.policies.packages-to-flake
  ];
  den.schema.flake-parts.includes = [
    den.policies.packages-to-flake-parts
  ];

  den.default.nixpkgs = _: {
    config = {
      config.allowUnfree = true;
      overlays = [inputs.self.overlays.default];
    };
  };

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
}
