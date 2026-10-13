{
  flake.modules.homeManager.gaming = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.games.browndust2;
  in {
    options.games.browndust2 = {
      enable = lib.mkEnableOption "Brown Dust 2";
      package = lib.mkPackageOption pkgs "browndust2" {};
    };

    config = lib.mkIf cfg.enable {
      programs.steam.config.nonSteamApps."Brown Dust 2" = {
        compatTool = pkgs.dwproton-bin;
        target = "${cfg.package}/BD2StarterSetup.exe";

        artwork = {
          cover = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/3938980/e30a2f1d74cca33ed95170799b1328c4273a7ed2/library_capsule_schinese_2x.jpg";
            hash = "sha256-KH306zfG1YEnOvZNVDKH+rMcSv/2gj3JwB1Sv4MLyXk=";
          };
          header = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/3938980/67f58b63e349212f74cce1be6c84ea6889fb24ae/library_header_schinese_2x.jpg";
            hash = "sha256-2dY8uPyq0A4U5Mvedfu5mMfhMJ8C5mtwQIGyCG61r2g=";
          };
          hero = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/3938980/b4bc88b73ec406c6d07aab8611af916a172d62c3/library_hero_2x.jpg";
            hash = "sha256-pxJZU0g2PhiqR25wY0SsaHw0ZY5S23uy6qIzeaQfM68=";
          };
          icon = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/community_assets/images/apps/3938980/a1f517a764339570b77e4a22dabc179fd7549db3.jpg";
            hash = "sha256-pr2/0AglIrJaDXlTE4nvsVKdjw/+u9mllqIjmreOaRE=";
          };
          logo = pkgs.fetchurl {
            url = "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/3938980/8651a1ea029d1c6e8220476aac904e6d457b90ba/logo_schinese_2x.png";
            hash = "sha256-YY3NiXGUOLymLWjbALr04Gv8+3nkaEF7Pu2+kcP2GgI=";
          };
        };
      };
    };
  };
}
