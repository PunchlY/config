{inputs, ...}: {
  flake-file.inputs = {
    nix-index-database.url = "github:nix-community/nix-index-database";
  };

  den.aspects.develop.nixos = _: {
    imports = [inputs.nix-index-database.nixosModules.default];

    programs.nix-index-database.comma.enable = true;

    programs.nix-index = {
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
  };
}
