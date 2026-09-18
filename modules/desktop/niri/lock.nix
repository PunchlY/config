{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.niri.enable {
      security = {
        polkit.enable = true;
        pam.services.swaylock = {};
      };

      services.systemd-lock-handler.enable = true;

      systemd.user.services.niri-lock = {
        requisite = ["graphical-session.target"];
        after = ["wayland-wm@niri.service"];
        onSuccess = ["unlock.target"];
        partOf = ["lock.target"];
        before = ["lock.target"];
        wantedBy = ["lock.target"];
        serviceConfig = {
          Type = "forking";
          ExecStart = "swaylock";
          Restart = "on-failure";
          RestartSec = 0;
        };
      };
    };
  };

  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.niri.enable {
      programs.swaylock.enable = true;
      programs.niri.settings = {
        binds."Mod+Alt+L" = {
          hotkey-overlay.title = "Lock the Screen";
          allow-inhibiting = false;
          action.spawn-sh = "loginctl lock-session";
        };
      };
    };
  };
}
