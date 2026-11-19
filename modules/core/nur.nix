{
  inputs,
  den,
  lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    ../../packages
  ];

  flake-file.inputs = {
    nur.url = "github:nix-community/NUR";

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.autoFollow = false;
    };

    ccicnce113424-nix-packages = {
      url = "github:ccicnce113424/nix-packages";
      inputs.nixpkgs.autoFollow = false;
    };
  };

  flake-file.nixConfig = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://nyx-cache.chaotic.cx/"
      "https://ccicnce113424.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
      "ccicnce113424.cachix.org-1:OWV4fSkx7o7TinVCSD98zPG8udShCIjhyaAdOIRNetw="
    ];
  };

  den.default.nixpkgs = _: {
    overlays = [
      inputs.nur.overlays.default
      (den.lib.mkOverlay inputs.ccicnce113424-nix-packages)
    ];
  };

  den.default.nixos = _: {
    imports = [
      inputs.chaotic.nixosModules.default
      inputs.ccicnce113424-nix-packages.nixosModules.modules
    ];
  };

  den.lib.mkOverlay = flake:
    den.lib.mkOverlay' (
      if lib.isType "flake" flake
      then {inherit flake;}
      else flake
    );
  den.lib.mkOverlay' = {
    flake ? null,
    overlay ? flake.overlays.default,
    nixpkgs ? flake.inputs.nixpkgs,
    overlays ? [],
  }: _final: prev: let
    inherit (prev) stdenv;
    inherit (stdenv.hostPlatform) system;
    isCross = stdenv.buildPlatform != stdenv.hostPlatform;
    pkgs = import nixpkgs {
      inherit (prev) config;
      inherit overlays;
      localSystem =
        if isCross
        then stdenv.buildPlatform
        else nixpkgs.legacyPackages."${system}".stdenv.hostPlatform;
      crossSystem =
        if isCross
        then stdenv.hostPlatform
        else null;
    };
    overlayFinal = pkgs.appendOverlay overlay;
    packages = overlay overlayFinal pkgs;
  in
    packages;
}
