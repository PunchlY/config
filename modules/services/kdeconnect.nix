{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.kdeconnect;
  in {
    config = lib.mkIf cfg.enable {
      hm.services.kdeconnect = {
        enable = true;
        package = cfg.package;
      };
    };
  };

  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.services.kdeconnect.enable {
      services.kdeconnect.indicator = true;
    };
  };
}
