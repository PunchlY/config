{
  den.aspects.desktop.swayimg.homeManager = {
    config,
    lib,
    ...
  }: let
    opacity_hex = lib.fixedWidthString 2 "0" (lib.toHexString (lib.ceil (config.stylix.opacity.applications * 255)));
  in {
    xdg.mimeApps.defaultApplicationPackages = [
      config.programs.swayimg.package
    ];

    programs.swayimg = {
      enable = true;
      initLua = ''
        -- Viewer mode
        swayimg.viewer.on_key("q", function()
          swayimg.exit()
        end)

        swayimg.viewer.on_key("l", function()
          swayimg.viewer.switch_image("next")
        end)

        swayimg.viewer.on_key("h", function()
          swayimg.viewer.switch_image("prev")
        end)

        swayimg.on_window_resize(function()
          if swayimg.mode == "viewer" then
            swayimg.viewer.set_fix_scale("optimal")
          end
        end)

        -- Text layer
        swayimg.text.font = "monospace"
        swayimg.text.size = ${toString config.stylix.fonts.sizes.desktop}
        swayimg.text.color = 0xff${config.lib.stylix.colors.base07}
        swayimg.text.shadow = 0x00000000
        swayimg.text.background = 0x${opacity_hex}${config.lib.stylix.colors.base00}

        -- Viewer mode
        swayimg.viewer.set_window_background(0x${opacity_hex}${config.lib.stylix.colors.base00})

        -- Gallery mode
        swayimg.gallery.selected_color = 0xff${config.lib.stylix.colors.base00}
        swayimg.gallery.unselected_color = 0xff${config.lib.stylix.colors.base00}
        swayimg.gallery.border_color = 0xff${config.lib.stylix.colors.base00}
        swayimg.gallery.window_color = 0x${opacity_hex}${config.lib.stylix.colors.base00}
      '';
    };
  };
}
