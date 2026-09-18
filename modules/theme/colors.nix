{moduleWithSystem, ...}: {
  flake-file.inputs = {
    oktheme.url = "github:PunchlY/oktheme";
  };

  flake.modules.generic.theme = moduleWithSystem ({inputs'}: {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.theme;
    mkColors = wallpaper:
      pkgs.runCommandLocal "generated-theme" {
        inherit wallpaper;
        nativeBuildInputs = [
          pkgs.imagemagick
          inputs'.oktheme.packages.default
        ];
      } ''
        read -r source < <(
          magick "$wallpaper" \
            -seed 0 \
            -resize '256>' \
            -colorspace oklch \
            -kmeans 8 \
            -colorspace oklch \
            -format '%c' \
            histogram:info: |
            sort -nr
        )
        if [[ $source =~ oklch\(([0-9.-]+),([0-9.-]+),([0-9.-]+)\) ]]; then
          l="''${BASH_REMATCH[1]}"
          c="''${BASH_REMATCH[2]}"
          h="''${BASH_REMATCH[3]}"
        else
          exit 1
        fi
        oktheme "oklch($l $c $h)" >$out
      ''
      |> lib.importJSON
      |> lib.mapAttrs (_: value:
        value
        // {
          hex_stripped = lib.substring 1 6 value.hex;
        });
  in {
    options.theme = {
      wallpaper = lib.mkOption {
        type = lib.types.either lib.types.path lib.types.package;
        default = pkgs.nixos-artwork.wallpapers.nineish-catppuccin-mocha.src;
      };

      colors = lib.mkOption {internal = true;};

      opacity = lib.mkOption {
        type = lib.types.float;
        default = 0.75;
      };
    };
    config = {
      theme.colors = mkColors cfg.wallpaper;
    };
  });
}
