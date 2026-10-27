{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.alacritty.enable {
      xdg.desktopEntries.Alacritty = {
        name = "Alacritty";
        type = "Application";
        genericName = "Terminal";
        comment = "A fast, cross-platform, OpenGL terminal emulator";
        icon = "Alacritty";
        exec = "alacritty";
        categories = [
          "System"
          "TerminalEmulator"
        ];
        startupNotify = true;
        terminal = false;
        settings = {
          X-TerminalArgExec = "-e";
          X-TerminalArgTitle = "--title=";
          X-TerminalArgAppId = "--class=";
          X-TerminalArgDir = "--working-directory=";
          X-TerminalArgHold = "--hold";
        };
      };

      programs.alacritty = {
        package = lib.mkDefault pkgs.alacritty-graphics;
        settings = {
          hints.enabled = let
            regex = ''(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
          in [
            {
              inherit regex;
              hyperlinks = true;
              command = "xdg-open";
              post_processing = true;
              persist = false;
              binding = {
                key = "O";
                mods = "Control|Shift";
              };
              mouse = {
                mods = "Alt";
                enabled = true;
              };
            }
            {
              inherit regex;
              hyperlinks = true;
              action = "Copy";
              post_processing = true;
              persist = false;
              mouse = {
                enabled = true;
              };
            }
          ];
          keyboard.bindings = [
            {
              key = "N";
              mods = "Shift|Control";
              action = "CreateNewWindow";
            }
          ];
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
  in {
    config = lib.mkIf config.programs.alacritty.enable {
      programs.alacritty.settings = {
        font = {
          normal = {
            family = "monospace";
            style = "Regular";
          };
          size = font.size;
        };
        window.opacity = opacity;
        colors = {
          primary = {
            foreground = colors.on_surface.hex;
            background = colors.surface.hex;
            bright_foreground = colors.on_surface.hex;
          };
          normal = {
            black = colors.color0.hex;
            red = colors.color1.hex;
            green = colors.color2.hex;
            yellow = colors.color3.hex;
            blue = colors.color4.hex;
            magenta = colors.color5.hex;
            cyan = colors.color6.hex;
            white = colors.color7.hex;
          };
          bright = {
            black = colors.color8.hex;
            red = colors.color9.hex;
            green = colors.color10.hex;
            yellow = colors.color11.hex;
            blue = colors.color12.hex;
            magenta = colors.color13.hex;
            cyan = colors.color14.hex;
            white = colors.color15.hex;
          };
          indexed_colors =
            lib.genList (i: {
              index = i + 16;
              color = colors."color${toString (i + 16)}".hex;
            })
            240;
        };
      };
    };
  };
}
