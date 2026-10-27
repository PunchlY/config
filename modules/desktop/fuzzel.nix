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
        colors = with colors; {
          background = "${surface.hexStripped}${lib.fixedWidthString 2 "0" (lib.toHexString (lib.ceil (opacity * 255)))}";
          text = "${on_surface.hexStripped}ff";
          message = "${orange.hexStripped}ff";
          prompt = "${secondary.hexStripped}ff";
          placeholder = "${tertiary.hexStripped}ff";
          input = "${primary.hexStripped}ff";
          match = "${primary.hexStripped}ff";
          selection = "${primary.hexStripped}ff";
          selection-text = "${on_primary.hexStripped}ff";
          selection-match = "${on_primary.hexStripped}ff";
          counter = "${secondary.hexStripped}ff";
          border = "${primary.hexStripped}ff";
        };
      };
    };
  };
}
