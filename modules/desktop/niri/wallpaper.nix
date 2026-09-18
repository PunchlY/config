{
  flake.modules.homeManager.theme = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.niri.enable {
      programs.niri.settings = {
        spawn-at-startup = [
          {
            argv = [(lib.getExe pkgs.wbg) "--stretch" (toString config.theme.wallpaper)];
          }
        ];
        layer-rules = [
          {
            matches = [{namespace = "^wallpaper$";}];
            place-within-backdrop = true;
          }
        ];
      };
    };
  };
}
