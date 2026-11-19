{den, ...}: {
  den.aspects.desktop.niri.includes = [
    den.aspects.desktop.i3bar-river
  ];
  den.aspects.desktop.niri.homeManager = {
    config,
    pkgs,
    ...
  }: {
    programs.niri.settings.spawn-at-startup = [
      {
        argv = ["i3bar-river"];
      }
    ];

    programs.i3status-rust.bars.niri = {
      icons = "material-nf";
      theme = "${(pkgs.formats.toml {}).generate "i3status-theme.toml" config.lib.stylix.i3status-rust.bar}";
      blocks = [
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
}
