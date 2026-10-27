{
  inputs,
  config,
  ...
}: {
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

  flake.modules.nixos.base = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = config.nixpkgs.overlays;
  };

  flake.modules.nixvim.base = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = config.nixpkgs.overlays;
  };

  perSystem = {
    system,
    pkgs,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    _module.args.final = pkgs.appendOverlays config.nixpkgs.overlays;
  };
}
