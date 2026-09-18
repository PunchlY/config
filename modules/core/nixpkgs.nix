{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    ../../packages
  ];

  options.nixpkgs = {
    config = {
      allowUnfreePackages = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
      permittedInsecurePackages = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
    };
    overlays = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      default = [];
    };
  };

  config = {
    flake-file.inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      nur = {
        url = "github:nix-community/NUR";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    flake-file.nixConfig = {
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    nixpkgs.overlays = [
      inputs.nur.overlays.default
      inputs.self.overlays.default
    ];

    flake.modules.nixos.base = {
      nixpkgs = config.nixpkgs;
    };

    flake.modules.nixvim.base = {
      nixpkgs = config.nixpkgs;
    };

    perSystem = {
      system,
      pkgs,
      ...
    }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        inherit (config.nixpkgs) config;
      };
      _module.args.final = pkgs.appendOverlays config.nixpkgs.overlays;
    };
  };
}
