{
  flake.modules.nixos.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors font;
  in {
    config = lib.mkIf config.services.kmscon.enable {
      services.kmscon.config =
        {
          libseat = false;
          term = "xterm-256color";
          font-name = "monospace";
          font-size = lib.mkDefault font.size;
          palette = "custom";
        }
        // lib.mapAttrs' (name: color:
          lib.map lib.toString [color.rgb.r color.rgb.g color.rgb.b]
          |> lib.concatStringsSep ","
          |> lib.nameValuePair "palette-${name}") {
          black = colors.color0;
          red = colors.color1;
          green = colors.color2;
          yellow = colors.color3;
          blue = colors.color4;
          magenta = colors.color5;
          cyan = colors.color6;
          light-grey = colors.color7;

          dark-grey = colors.color8;
          light-red = colors.color9;
          light-green = colors.color10;
          light-yellow = colors.color11;
          light-blue = colors.color12;
          light-magenta = colors.color13;
          light-cyan = colors.color14;
          white = colors.color15;

          foreground = colors.on_surface;
          background = colors.surface;
        };
    };
  };
}
