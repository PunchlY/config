{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.niri.enable {
      programs.niri.settings.spawn-at-startup = [
        {
          argv = ["i3bar-river"];
        }
      ];

      programs.i3bar-river.enable = true;
      programs.i3status-rust.bars.niri.blocks = [
        {
          block = "music";
          format.full = " $icon {$combo $prev $play $next |-- $play }|";
          format.short = " $icon {$combo.str(max_w:32) $prev $play $next |-- $play }|";
          format_alt = " $icon $player $cur.eng(w:1)/$avail.eng(w:1) {$volume_icon $volume }";
          seek_step_secs = 10;
          click = [
            {
              button = "up";
              action = "volume_up";
            }
            {
              button = "down";
              action = "volume_down";
            }
          ];
        }
        {
          block = "net";
          format = " $icon |";
          inactive_format = "";
          missing_format = "";
          device = "^wl";
          merge_with_next = true;
        }
        {
          block = "net";
          format = " $icon |";
          inactive_format = "";
          missing_format = "";
          device = "^en";
          merge_with_next = true;
        }
        {
          block = "memory";
          format = " $icon $mem_used_percents.eng(w:2) ";
          # format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
          merge_with_next = true;
        }
        {
          block = "cpu";
          format = " $icon $utilization.eng(w:2) ";
          # format_alt = " $icon $barchart ";
          merge_with_next = true;
        }
        {
          block = "battery";
          format = " $icon $percentage.eng(w:2) ";
          theme_overrides = {
            good_bg.link = "idle_bg";
            good_fg.link = "idle_fg";
            info_bg.link = "idle_bg";
            info_fg.link = "idle_fg";
          };
        }
        {
          block = "sound";
          format = " $icon {$volume.eng(w:2) |}";
          format_alt = " $icon $output_name ";
          merge_with_next = true;
        }
        {
          block = "sound";
          device_kind = "source";
          format = " $icon {$volume.eng(w:2) |}";
          format_alt = " $icon $output_name ";
        }
        {
          block = "time";
          format = " $timestamp.datetime(f:%R) ";
        }
        {
          block = "privacy";
          driver = [
            {name = "v4l";}
            {name = "pipewire";}
          ];
        }
      ];
    };
  };

  flake.modules.homeManager.theme = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config.theme) colors;
  in {
    config = lib.mkIf config.programs.niri.enable {
      programs.i3status-rust.bars.niri = {
        icons = "material-nf";
        theme = "${(pkgs.formats.toml {}).generate "i3status-theme.toml" {
          idle_bg = colors.surface.hex;
          idle_fg = colors.on_surface.hex;
          alternating_tint_bg = let
            toInt = v: v.r * 65536 + v.g * 256 + v.b;
          in "#${
            lib.fixedWidthString 6 "0" (lib.toHexString ((toInt colors.surface_bright.rgb) - (toInt colors.surface.rgb)))
          }00";
          info_bg = colors.surface.hex;
          info_fg = colors.blue.hex;
          good_bg = colors.surface.hex;
          good_fg = colors.green.hex;
          warning_bg = colors.surface.hex;
          warning_fg = colors.orange.hex;
          critical_bg = colors.surface.hex;
          critical_fg = colors.error.hex;
          separator = "";
        }}";
      };
    };
  };
}
