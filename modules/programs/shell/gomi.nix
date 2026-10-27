{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.gomi;

    yamlFormat = pkgs.formats.yaml {};
  in {
    options.programs.gomi = {
      enable = lib.mkEnableOption "gomi";
      package = lib.mkPackageOption pkgs "gomi" {nullable = true;};
      settings = lib.mkOption {
        type = yamlFormat.type;
        default = {};
      };
    };
    config = lib.mkIf cfg.enable {
      home.packages = lib.mkIf (cfg.package != null) [cfg.package];
      home.shellAliases.rm = "gomi";

      programs.gomi.settings = {
        core.trash = {
          strategy = "xdg";
        };
      };

      xdg.configFile."gomi/config.yaml" = lib.mkIf (cfg.settings != {}) {
        source = yamlFormat.generate "gomi-config" cfg.settings;
      };
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors;
    cfg = config.programs.gomi;
  in {
    config = lib.mkIf cfg.enable {
      programs.gomi.settings = {
        ui.style = {
          list_view = {
            cursor = colors.magenta.hex;
            selected = colors.green.hex;
            filter_match = colors.orange.hex;
            filter_prompt = colors.blue.hex;
          };
          detail_view = {
            border = colors.outline.hex;
            info_pane = {
              deleted_from.fg = colors.on_surface.hex;
              deleted_from.bg = colors.surface.hex;
              deleted_at.fg = colors.on_surface.hex;
              deleted_at.bg = colors.surface.hex;
            };
            preview_pane = {
              border = colors.outline_variant.hex;
              size.fg = colors.on_surface.hex;
              size.bg = colors.outline_variant.hex;
              scroll.fg = colors.on_surface.hex;
              scroll.bg = colors.outline_variant.hex;
            };
          };
          deletion_dialog = colors.red.hex;
        };
      };
    };
  };
}
