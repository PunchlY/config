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
          else stdenv.hostPlatform;
        crossSystem =
          if isCross
          then stdenv.hostPlatform
          else null;
      };
      overlayFinal =
        pkgs
        // packages
        // {
          callPackage = pkgs.newScope overlayFinal;
        };
      packages = overlay overlayFinal pkgs;
    in
      packages;
  };
}
