{lib, ...}: {
  options.nixpkgs = {
    overlays = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      default = [];
    };
  };
}
