{
  nixpkgs.config = {
    allowUnfreePackages = [
      "PlantsVsZombiesRH.zip"
    ];
  };

  flake.modules.homeManager.gaming = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.games.pvz-rh;
  in {
    options.games.pvz-rh = {
      enable = lib.mkEnableOption "Plants vs. Zombies: RH";
      package = lib.mkPackageOption pkgs "pvz-rh" {};
    };

    config = lib.mkIf cfg.enable {
      programs.steam.config.nonSteamApps."Plants vs. Zombies: RH" = {
        target = "${pkgs.pvz-rh}/PlantsVsZombiesRH.exe";
        compatTool = "proton_experimental";
      };
    };
  };
}
