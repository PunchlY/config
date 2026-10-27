{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.ghostty.enable {
      programs.ghostty = {
        systemd.enable = true;
      };
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors font opacity;
  in {
    config = lib.mkIf config.programs.ghostty.enable {
      programs.ghostty = {
        settings = {
          font-family = "monospace";
          font-size = font.size;
          theme = "md3";
        };
        themes.md3 = with colors; {
          palette = lib.genList (i: "${toString i}=${colors."color${toString i}".hex}") 256;
          palette-generate = true;
          selection-background = primary.hexStripped;
          selection-foreground = on_primary.hexStripped;
          background = surface.hexStripped;
          foreground = on_surface.hexStripped;
          background-opacity = opacity.hexStripped;
          cursor-color = on_surface.hexStripped;
          cursor-text = surface.hexStripped;
          cursor-style = "block";
          minimum-contrast = 1.1;
        };
      };
    };
  };
}
