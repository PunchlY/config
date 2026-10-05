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
    pkgs,
    lib,
    ...
  }: let
    inherit (config.theme) colors;
    cfg = config.programs.gomi;
  in {
    config = lib.mkIf cfg.enable {
      programs.gomi.settings = {
        ui.style = with colors; {
          list_view = {
            cursor = magenta.hex;
            selected = green.hex;
            filter_match = orange.hex;
            filter_prompt = blue.hex;
          };
          detail_view = {
            border = outline.hex;
            info_pane = {
              deleted_from.fg = on_surface.hex;
              deleted_from.bg = surface.hex;
              deleted_at.fg = on_surface.hex;
              deleted_at.bg = surface.hex;
            };
            preview_pane = {
              border = outline_variant.hex;
              size.fg = on_surface.hex;
              size.bg = outline_variant.hex;
              scroll.fg = on_surface.hex;
              scroll.bg = outline_variant.hex;
            };
          };
          deletion_dialog = red.hex;
        };
      };
    };
  };
}
