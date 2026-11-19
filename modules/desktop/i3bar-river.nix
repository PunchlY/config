{
  den.aspects.desktop.i3bar-river.homeManager = {config, ...}: {
    programs.i3status-rust.enable = true;
    programs.i3bar-river = {
      enable = true;
      settings = {
        height = config.stylix.fonts.sizes.desktop * 2;
        command = ''i3status-rs "config-''${XDG_CURRENT_DESKTOP:-default}"'';
      };
    };
  };
}
