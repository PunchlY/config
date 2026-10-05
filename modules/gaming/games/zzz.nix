{
  flake.modules.homeManager.gaming = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.games.zzz;
  in {
    options.games.zzz = {
      enable = lib.mkEnableOption "Zenless Zone Zero";
      package = lib.mkPackageOption pkgs "sleepy-launcher" {};
    };

    config = lib.mkIf cfg.enable {
      programs.steam.config.nonSteamApps."Zenless Zone Zero" = {
        desktopEntry.enable = false;

        target = cfg.package;

        artwork = {
          cover = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/4162040/8cb11f8041f830d14b7d8288cc166608802dc939/library_capsule_schinese_2x.jpg";
            hash = "sha256-/ZVBwddCtb7sjzsWc1bVm3oR2bHKcTd/PpvCIx1FY+4=";
          };
          header = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/4162040/1330f0dd3138c6b7aec979ec6dbe9b6e8e13a528/library_header_schinese_2x.jpg";
            hash = "sha256-5ipdQRQxEsi54HTBVFycLIvz0mLjGKK+FVDNiP7Lh3c=";
          };
          hero = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/4162040/c1b97d591e5c5ccc4e6dccba52bd2119db0d21ac/library_hero_2x.jpg";
            hash = "sha256-PkkClbm7y7xLPys9zagtRNGi4/qIptMJikm4ADUSxF0=";
          };
          icon = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/community_assets/images/apps/4162040/ff5f5a2eb168b2f1fa7c657f07af0871ba2fbf82.ico";
            hash = "sha256-Q56I4dDL97d2pYltoKQY5CQaS3dwI7CyS+TfgYZr1QY=";
          };
          logo = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/4162040/1e0c83485a1048d8bfcad1daa4bc7eb1ce402d41/logo_schinese.png";
            hash = "sha256-lHKYOO5FwHPXyJS3BXAe4goXB4D0lMAU1GZGcbOVyIs=";
          };
        };
      };
    };
  };
}
