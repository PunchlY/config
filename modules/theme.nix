{
  inputs,
  den,
  lib,
  ...
}: {
  flake-file.inputs = {
    stylix.url = "github:nix-community/stylix";
  };

  den.schema.host.includes = [
    {
      nixos = _: {
        imports = [inputs.stylix.nixosModules.stylix];

        stylix.enable = true;
        fonts = {
          enableDefaultPackages = false;
          fontDir.enable = true;
        };
      };

      homeManager = {config, ...}: {
        home.pointerCursor.enable = true;

        xdg.dataFile."fonts".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/X11/fonts";
      };
    }
    ({host}:
      den.batteries.forward {
        each = [host];
        fromClass = _: "stylix";
        intoClass = {class, ...}: class;
        intoPath = _: ["stylix"];
        adaptArgs = lib.id;
      })
  ];

  den.default.stylix = {
    config,
    pkgs,
    ...
  }: {
    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = config.lib.stylix.pixel "base00";

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 32;
    };

    fonts.emoji = {
      package = pkgs.twemoji-color-font;
      name = "Twitter Color Emoji";
    };
    fonts.monospace = {
      package = pkgs.maple-mono.Normal-NF-CN.overrideAttrs {
        src = pkgs.fetchurl {
          url = "https://github.com/PunchlY/maple-font/releases/download/v1792265751/MapleMonoNormal-NF-CN.zip";
          hash = "sha256-6ikrgazSDSAssj+uBdmI8caC9tGwZL5yfZx3iC2XAOw=";
        };
      };
      name = "Maple Mono Normal NF CN";
    };
    fonts.serif = config.stylix.fonts.monospace;
    fonts.sansSerif = config.stylix.fonts.monospace;

    fonts.sizes = {
      applications = 14;
      desktop = 14;
      popups = 14;
      terminal = 14;
    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 1.0;
      terminal = 1.0;
    };
  };

  den.default.lib = {
    config,
    pkgs,
    ...
  }: {
    stylix.font' = package: name: ext:
      pkgs.runCommandLocal "${name}.${ext}" {
        nativeBuildInputs = [
          pkgs.fontconfig
          pkgs.fontforge
        ];
        FONTCONFIG_FILE = pkgs.makeFontsConf {
          fontDirectories = [package];
        };
        FAMILY_NAME = name;
      } ''
        font="$(fc-match "$FAMILY_NAME" --format '%{file}')"
        shopt -s nocasematch
        case "$font" in
          *.${ext}) ln -s "$font" "$out" ;;
          *) fontforge -lang=ff -c 'Open($1); Generate($2)' "$font" "$out" ;;
        esac
      '';
    stylix.font = family: ext: let
      inherit (config.stylix.fonts.${family}) package name;
    in
      config.lib.stylix.font' package name ext;
  };
}
