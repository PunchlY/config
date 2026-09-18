{
  flake.modules.homeManager.gaming = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.games.helltaker;
    helltaker-chinese = pkgs.fetchzip {
      url = "https://github.com/SeaEpoch/Helltaker-Chinese/releases/download/v1.2/Helltaker.zh_CN.v1.2.zip";
      hash = "sha256-e+yscW4bSjOxUN7L7qL36ZExVocHufUhIMIfqbegNTA=";
    };
  in {
    options.games.helltaker = {
      enable = lib.mkEnableOption "helltaker";
    };

    config = lib.mkIf cfg.enable {
      programs.steam.config.apps.Helltaker = {
        id = 1289310;
        files.game.place = {
          "local".source = "${helltaker-chinese}/local";
          "localHM".source = "${helltaker-chinese}/localHM";
        };
      };
    };
  };
}
