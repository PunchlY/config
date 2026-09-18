{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.niri.enable {
      programs.uwsm.desktopEnv.niri = {
        MOZ_ENABLE_WAYLAND = "1";
        GTK_USE_PORTAL = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        SDL_VIDEODRIVER = "wayland";
        STEAM_USE_WAYLAND = "1";
        GDK_BACKEND = "wayland";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        GTK_CSD = "0";
      };
      programs.niri.settings.spawn-at-startup = [
        {
          sh = ''[ "$(systemctl --user show wayland-wm@niri.service -p MainPID --value)" -eq "$(${lib.getExe pkgs.lsof} -t "$NIRI_SOCKET" 2>&1)" ] && uwsm finalize'';
        }
      ];
    };
  };
}
