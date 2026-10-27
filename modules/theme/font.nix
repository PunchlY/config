{
  flake.modules.generic.theme = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.theme.font;
  in {
    options.theme.font = {
      size = lib.mkOption {
        type = with lib.types; either ints.unsigned float;
        default = 14;
      };
      fonts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule ({config, ...}: {
          options = {
            package = lib.mkOption {
              type = lib.types.package;
            };
            name = lib.mkOption {
              type = lib.types.str;
            };
            path = lib.mkOption {
              internal = true;
              readOnly = true;
            };
          };
          config.path =
            pkgs.runCommandLocal "${config.name}.ttf"
            {
              nativeBuildInputs = [
                pkgs.fontconfig
                pkgs.fontforge
              ];
              FONTCONFIG_FILE = pkgs.makeFontsConf {
                fontDirectories = [config.package];
              };
              FAMILY_NAME = config.name;
            }
            ''
              font="$(fc-match "$FAMILY_NAME" --format '%{file}')"
              case "$font" in
              *.ttf)
                ln -s "$font" "$out"
                ;;
              *)
                fontforge -lang=ff -c 'Open($1); Generate($2)' "$font" "$out"
                ;;
              esac
            '';
        }));
      };
    };
    config = {
      theme.font.fonts.monospace = {
        package = pkgs.maple-mono.Normal-NF-CN.overrideAttrs {
          src = pkgs.fetchurl {
            url = "https://github.com/PunchlY/maple-font/releases/download/v1792265751/MapleMonoNormal-NF-CN.zip";
            hash = "sha256-6ikrgazSDSAssj+uBdmI8caC9tGwZL5yfZx3iC2XAOw=";
          };
        };
        name = "Maple Mono Normal NF CN";
      };
      theme.font.fonts.serif = {
        package = cfg.fonts.monospace.package;
        name = cfg.fonts.monospace.name;
      };
      theme.font.fonts.sansSerif = {
        package = cfg.fonts.monospace.package;
        name = cfg.fonts.monospace.name;
      };
      theme.font.fonts.emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twitter Color Emoji";
      };

      fonts.fontconfig = lib.mkIf config.fonts.fontconfig.enable {
        defaultFonts = {
          monospace = [
            cfg.fonts.monospace.name
            cfg.fonts.emoji.name
          ];
          serif = [
            cfg.fonts.serif.name
            cfg.fonts.emoji.name
          ];
          sansSerif = [
            cfg.fonts.sansSerif.name
            cfg.fonts.emoji.name
          ];
          emoji = [
            cfg.fonts.emoji.name
          ];
        };
      };
    };
  };

  flake.modules.nixos.theme = {
    config,
    lib,
    ...
  }: {
    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;
      packages = lib.mapAttrsToList (_: cfg: cfg.package) config.theme.font.fonts;
    };

    hm.xdg.dataFile."fonts".source = config.hm.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/X11/fonts";
  };
}
