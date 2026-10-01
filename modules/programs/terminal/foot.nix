{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.foot.enable {
      xdg.desktopEntries.foot = {
        name = "Foot";
        type = "Application";
        genericName = "Terminal";
        comment = "A wayland native terminal emulator";
        icon = "foot";
        exec = "foot";
        categories = [
          "System"
          "TerminalEmulator"
        ];
        startupNotify = true;
        terminal = false;
        settings = {
          Keywords = "shell;prompt;command;commandline;";
          X-TerminalArgExec = "--";
          X-TerminalArgTitle = "--title";
          X-TerminalArgAppId = "--app-id";
          X-TerminalArgDir = "--working-directory";
          X-TerminalArgHold = "--hold";
        };
      };

      programs.foot.settings = {
        key-bindings = {
          show-urls-launch = "Control+Shift+o";
          show-urls-copy = "Control+Shift+i";
          pipe-command-output = "[${lib.getExe' pkgs.wl-clipboard "wl-copy"}] Control+Shift+g";
        };
      };

      programs.bash.initExtra = ''
        if [[ $TERM == foot* ]]; then
          source "${pkgs.bash-preexec}/share/bash/bash-preexec.sh"

          command_start() {
            printf '\e]133;C\e\\'
          }
          preexec_functions+=(command_start)

          command_done() {
            printf '\e]133;D\e\\'
          }
          precmd_functions+=(command_done)

          prompt_marker() {
            printf '\e]133;A\e\\'
          }
          precmd_functions+=(prompt_marker)

          osc7_cwd() {
            local strlen=''${#PWD}
            local encoded=""
            local pos c o
            for (( pos=0; pos<strlen; pos++ )); do
              c=''${PWD:$pos:1}
              case "$c" in
                [-/:_.!\'\(\)~[:alnum:]] ) o="$c" ;;
                * ) printf -v o '%%%02X' "'$c" ;;
              esac
              encoded+="''${o}"
            done
            printf '\e]7;file://%s%s\e\\' "''${HOSTNAME}" "''${encoded}"
          }
          precmd_functions+=(osc7_cwd)
        fi
      '';
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors font opacity;
  in {
    config = lib.mkIf config.programs.foot.enable {
      programs.foot.settings = {
        main.font = "monospace:size=${toString font.size}";
        colors-dark =
          {
            alpha = opacity;
            foreground = colors.on_surface.hex_stripped;
            background = colors.surface.hex_stripped;
            flash = colors.primary.hex_stripped;
          }
          // lib.listToAttrs (
            lib.genList (i: {
              name = "regular${toString i}";
              value = colors."color${toString i}".hex_stripped;
            })
            8
            ++ lib.genList (i: {
              name = "bright${toString i}";
              value = colors."color${toString (i + 8)}".hex_stripped;
            })
            8
            ++ lib.genList (i: {
              name = toString i;
              value = colors."color${toString i}".hex_stripped;
            })
            256
          );
      };
    };
  };
}
