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
          default = pkgs.maple-mono.Normal-NF-CN;
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

      fonts.fontconfig.defaultFonts =
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

  flake.modules.nixos.theme = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.theme;
  in {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        cfg.font.package

        noto-fonts-cjk-sans
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji

        material-icons
        lmmath
      ];
    };
  };

  flake.modules.homeManager.theme = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.theme;
  in {
    home.packages = with pkgs; [
      cfg.font.package

      noto-fonts-cjk-sans
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji

      material-icons
      lmmath
    ];
  };
}
