{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.services.mako.enable {
      services.mako.settings = {
        default-timeout = 5000;
        "urgency=high" = {
          default-timeout = 0;
        };
      };
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors font opacity;
    alpha = lib.toHexString (lib.ceil (opacity * 255));
  in {
    config = lib.mkIf config.services.mako.enable {
      services.mako.settings = {
        outer-margin = 0;
        margin = 8;
        padding = "8,16";
        # border-radius = 8;
        border-size = 2;
        font = "monospace ${toString font.size}";
        background-color = "${colors.primary_container.hex}${alpha}";
        text-color = colors.on_primary_container.hex;
        border-color = colors.primary.hex;
        "urgency=low" = {
          background-color = "${colors.secondary_container.hex}${alpha}";
          text-color = colors.on_secondary_container.hex;
          border-color = colors.secondary.hex;
        };
        "urgency=normal" = {
          background-color = "${colors.primary_container.hex}${alpha}";
          text-color = colors.on_primary_container.hex;
          border-color = colors.primary.hex;
        };
        "urgency=high" = {
          background-color = "${colors.error_container.hex}${alpha}";
          text-color = colors.on_error_container.hex;
          border-color = colors.error.hex;
        };
      };
    };
  };
}
