{
  flake.lib = {
    mkOverlay = {
      flake ? null,
      nixpkgs ? flake.inputs.nixpkgs,
      overlay ? flake.overlays.default,
      config ? {},
      overlays ? [],
    }: _final: prev: let
      inherit (prev) stdenv;
      isCross = stdenv.buildPlatform != stdenv.hostPlatform;
      pkgs = import nixpkgs {
        inherit config overlays;
        localSystem =
          if isCross
          then stdenv.buildPlatform
          else nixpkgs.legacyPackages.${stdenv.hostPlatform.system}.stdenv.hostPlatform;
        crossSystem =
          if isCross
          then stdenv.hostPlatform
          else null;
      };
    in
      overlay (pkgs.appendOverlay overlay) pkgs;
  };
}
