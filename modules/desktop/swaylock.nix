{
  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.swaylock;
    inherit (config.theme) colors wallpaper;
  in {
    config = lib.mkIf cfg.enable {
      programs.swaylock.settings = {
        image = "${wallpaper}";
        color = colors.background.hexStripped;
        inside-color = colors.surface_container.hexStripped;
        inside-clear-color = colors.secondary_container.hexStripped;
        inside-ver-color = colors.primary_container.hexStripped;
        inside-wrong-color = colors.error_container.hexStripped;
        inside-caps-lock-color = colors.orange.hexStripped;
        ring-color = colors.primary.hexStripped;
        ring-clear-color = colors.secondary.hexStripped;
        ring-ver-color = colors.primary.hexStripped;
        ring-wrong-color = colors.error.hexStripped;
        ring-caps-lock-color = colors.orange.hexStripped;
        text-color = colors.on_background.hexStripped;
        text-clear-color = colors.on_secondary_container.hexStripped;
        text-ver-color = colors.on_primary_container.hexStripped;
        text-wrong-color = colors.on_error_container.hexStripped;
        text-caps-lock-color = colors.on_orange.hexStripped;
        key-hl-color = colors.cyan.hexStripped;
        layout-bg-color = colors.surface_container_low.hexStripped;
        layout-border-color = colors.outline_variant.hexStripped;
        layout-text-color = colors.on_surface_variant.hexStripped;
        separator-color = "00000000";
        line-uses-inside = true;
      };
    };
  };
}
