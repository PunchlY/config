{inputs, ...}: {
  flake-file.inputs = {
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixpkgs.config = {
    allowUnfreePackages = [
      "steam"
      "steamdeck-hw-theme"
      "steam-jupiter-unwrapped"
    ];
  };

  flake.modules.nixos.gaming = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.jovian.nixosModules.default];

    config = lib.mkIf config.jovian.steam.enable {
      jovian.steam = {
        user = config.user.name;
        environment.PROTON_USE_RAW_INPUT = "1";
      };

      hm.imports = [
        inputs.self.modules.homeManager.gaming
      ];

      hm.programs.steam.config.enable = true;

      hm.xdg.desktopEntries.switch-to-game-mode = {
        name = "Game Mode";
        genericName = "Game Mode";
        exec = "steamosctl switch-to-game-mode";
      };
    };
  };

  flake.modules.homeManager.gaming = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.steam-config-nix.homeModules.default];

    config = lib.mkIf config.programs.steam.config.enable {
      programs.steam.config = {
        onSteamRunning = "close";
      };
    };
  };
}
