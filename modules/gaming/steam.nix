{inputs, ...}: {
  flake-file.inputs = {
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixpkgs.config = {
    allowUnfreePackages = [
      "steam"
    ];
  };

  flake.modules.nixos.gaming = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.steam.enable {
      hm.programs.steam.config.enable = true;

      hm.xdg.dataFile = {
        "Steam/config/htmlcache/External Extensions/kdbmhfkmnlmbkgbabkdealhhbfhlmmon.json".text = builtins.toJSON {
          external_update_url = "https://clients2.google.com/service/update2/crx";
        };
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
