{
  flake.modules.nixosConfiguration.base = {pkgs, ...}: let
    helltaker-chinese = pkgs.fetchzip {
      url = "https://github.com/SeaEpoch/Helltaker-Chinese/releases/download/v1.2/Helltaker.zh_CN.v1.2.zip";
      hash = "sha256-e+yscW4bSjOxUN7L7qL36ZExVocHufUhIMIfqbegNTA=";
    };
  in {
    gaming.games.helltaker = {
      name = "1289310";
      steam-config.app = {
        files.game.place = {
          "local".source = "${helltaker-chinese}/local";
          "localHM".source = "${helltaker-chinese}/localHM";
        };
      };
    };
  };
}
