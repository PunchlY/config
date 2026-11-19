{
  den.aspects.gaming.katawa-shoujo-re-engineered.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.katawa-shoujo-re-engineered];
  };

  den.aspects.gaming.katawa-shoujo-re-engineered.steamConfig = {pkgs, ...}: {
    nonSteamApps."Katawa Shoujo: Re-Engineered" = {
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
}
