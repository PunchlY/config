{inputs, ...}: {
  flake-file.inputs = {
    # use chaotic.vendored.jovian
    # jovian = {
    #   url = "github:Jovian-Experiments/Jovian-NixOS";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  flake.modules.nixos.gaming = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.chaotic.vendored.jovian.nixosModules.default];

    config = lib.mkIf config.jovian.steam.enable {
      jovian.steam = {
        user = config.user.name;
        environment.PROTON_USE_RAW_INPUT = "1";
      };

      hm.xdg.desktopEntries.switch-to-game-mode = {
        name = "Game Mode";
        genericName = "Game Mode";
        exec = "steamosctl switch-to-game-mode";
      };
    };
  };
}
