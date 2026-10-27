{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.fuzzel.enable {
      programs.fuzzel.settings = {
        main = {
          keyboard-focus = "on-demand";
        };
      };
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.fuzzel;
    inherit (config.theme) font colors opacity;
  in {
    config = lib.mkIf cfg.enable {
      programs.fuzzel.settings = {
        main = {
          font = "monospace:size=${toString font.size}";
          horizontal-pad = 16;
          vertical-pad = 8;
          inner-pad = 2;
          image-size-ratio = 1;
        };
        border = {
          width = 2;
          radius = 0;
          selection-radius = 0;
        };
        colors = {
          background = "${colors.surface.hexStripped}${lib.fixedWidthString 2 "0" (lib.toHexString (lib.ceil (opacity * 255)))}";
          text = "${colors.on_surface.hexStripped}ff";
          message = "${colors.orange.hexStripped}ff";
          prompt = "${colors.secondary.hexStripped}ff";
          placeholder = "${colors.tertiary.hexStripped}ff";
          input = "${colors.primary.hexStripped}ff";
          match = "${colors.primary.hexStripped}ff";
          selection = "${colors.primary.hexStripped}ff";
          selection-text = "${colors.on_primary.hexStripped}ff";
          selection-match = "${colors.on_primary.hexStripped}ff";
          counter = "${colors.secondary.hexStripped}ff";
          border = "${colors.primary.hexStripped}ff";
        };
      };
    };
  };
}
