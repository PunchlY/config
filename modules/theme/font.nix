{
  flake.modules.generic.theme = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.theme;
  in {
    options.theme = {
      font = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.maple-mono.Normal-NF-CN.overrideAttrs {
            src = pkgs.fetchurl {
              url = "https://github.com/PunchlY/maple-font/releases/download/v1792265751/MapleMonoNormal-NF-CN.zip";
              hash = "sha256-6ikrgazSDSAssj+uBdmI8caC9tGwZL5yfZx3iC2XAOw=";
            };
          };
        };
        name = lib.mkOption {
          type = lib.types.str;
          default = "Maple Mono Normal NF CN";
        };
        size = lib.mkOption {
          default = 14;
          type = with lib.types; either ints.unsigned float;
        };
        path = lib.mkOption {
          internal = true;
          readOnly = true;
        };
      };
    };
    config = {
      theme.font.path =
        pkgs.runCommandLocal "font"
        {
          nativeBuildInputs = [pkgs.fontconfig];
          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [cfg.font.package];
          };
          FAMILY_NAME = cfg.font.name;
        }
        ''
          ln -s "$(fc-match "$FAMILY_NAME" --format %{file})" "$out"
        '';

      fonts.fontconfig = lib.mkIf config.fonts.fontconfig.enable {
        defaultFonts =
          lib.genAttrs
          [
            "monospace"
            "serif"
            "sansSerif"
          ]
          (_family: [
            cfg.font.name
            "Noto Sans Mono CJK SC"
            "Noto Sans Mono"
            "Noto Color Emoji"
            "Noto Emoji"
          ])
          // {
            emoji = [
              "Noto Color Emoji"
              "Noto Emoji"
            ];
          };
      };
    };
  };

  flake.modules.nixos.theme = {config, ...}: {
    fonts.packages = [config.theme.font.package];
  };

  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji

        material-icons
        lmmath
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = lib.mkDefault [
            "Noto Sans Mono CJK SC"
            "Noto Sans Mono"
            "Noto Color Emoji"
            "Noto Emoji"
          ];
          serif = lib.mkDefault [
            "Noto Serif CJK SC"
            "Noto Serif"
            "Noto Color Emoji"
            "Noto Emoji"
          ];
          sansSerif = lib.mkDefault [
            "Noto Sans CJK SC"
            "Noto Sans"
            "Noto Color Emoji"
            "Noto Emoji"
          ];
          emoji = lib.mkDefault [
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
      };
    };

    hm.fonts.fontconfig.enable = false;

    hm.xdg.dataFile."fonts".source = config.hm.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/X11/fonts";
  };
}
