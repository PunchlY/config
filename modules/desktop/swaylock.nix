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
      programs.swaylock.settings = with colors; {
        image = "${wallpaper}";
        color = background.hexStripped;
        inside-color = surface_container.hexStripped;
        inside-clear-color = secondary_container.hexStripped;
        inside-ver-color = primary_container.hexStripped;
        inside-wrong-color = error_container.hexStripped;
        inside-caps-lock-color = orange.hexStripped;
        ring-color = primary.hexStripped;
        ring-clear-color = secondary.hexStripped;
        ring-ver-color = primary.hexStripped;
        ring-wrong-color = error.hexStripped;
        ring-caps-lock-color = orange.hexStripped;
        text-color = on_background.hexStripped;
        text-clear-color = on_secondary_container.hexStripped;
        text-ver-color = on_primary_container.hexStripped;
        text-wrong-color = on_error_container.hexStripped;
        text-caps-lock-color = on_orange.hexStripped;
        key-hl-color = cyan.hexStripped;
        layout-bg-color = surface_container_low.hexStripped;
        layout-border-color = outline_variant.hexStripped;
        layout-text-color = on_surface_variant.hexStripped;
        separator-color = "00000000";
        line-uses-inside = true;
      };
    };
  };
}
