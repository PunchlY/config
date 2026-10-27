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
  in {
    options.theme = {
      wallpaper = lib.mkOption {
        type = lib.types.either lib.types.path lib.types.package;
        default = pkgs.nixos-artwork.wallpapers.nineish-catppuccin-mocha.src;
      };

      colors = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule ({config, ...}: {
          options = {
            rgb = lib.mkOption {internal = true;};
            hex = lib.mkOption {internal = true;};
            hexStripped = lib.mkOption {internal = true;};
          };
          config = {
            hexStripped = lib.substring 1 6 config.hex;
          };
        }));
      };

      generated = lib.mkOption {
        type = lib.types.either lib.types.path lib.types.package;
        default =
          pkgs.runCommandLocal "generated-theme" {
            wallpaper = cfg.wallpaper;
            nativeBuildInputs = [
              pkgs.imagemagick
              inputs'.oktheme.packages.default
            ];
          } ''
            read -r source < <(
              magick "$wallpaper" \
                -alpha off \
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
          '';
      };

      opacity = lib.mkOption {
        type = lib.types.float;
        default = 0.75;
      };
    };
    config = {
      theme.colors = lib.importJSON cfg.generated;
    };
  });
}
