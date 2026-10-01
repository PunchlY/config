{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.impala;
  in {
    config = lib.mkIf cfg.enable {
      xdg.desktopEntries.impala = {
        name = "Impala";
        genericName = "Wifi Manager";
        exec = "impala";
        terminal = true;
      };
    };
  };
}
