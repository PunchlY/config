{
  flake.modules.nixosConfiguration.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    host = lib.mkIf config.gaming.games.katawa-shoujo-re-engineered.enable {
      hm.home.packages = [pkgs.katawa-shoujo-re-engineered];
    };

    gaming.games.katawa-shoujo-re-engineered = {
      name = "Katawa Shoujo: Re-Engineered";
      steam-config.nonSteamApp = {
        desktopEntry.enable = false;

        target = pkgs.katawa-shoujo-re-engineered;

        artwork = {
          cover = "${pkgs.katawa-shoujo-re-engineered}/share/kataswa-shoujo-re-engineered/game/presplash_background.png";
          header = "${pkgs.katawa-shoujo-re-engineered}/share/kataswa-shoujo-re-engineered/game/presplash_background.png";
          hero = "${pkgs.katawa-shoujo-re-engineered}/share/kataswa-shoujo-re-engineered/game/event/other_iwanako.png";
          icon = "${pkgs.katawa-shoujo-re-engineered}/share/icons/hicolor/512x512/apps/katawa-shoujo-re-engineered.png";
          logo = "${pkgs.katawa-shoujo-re-engineered}/share/kataswa-shoujo-re-engineered/game/gui/logo/credo.png";
        };
      };
    };
  };
}
