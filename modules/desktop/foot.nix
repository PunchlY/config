{
  den.aspects.desktop.foot.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    xdg.terminal-exec = {
      enable = true;
      settings.niri = ["foot.desktop"];
    };

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

    programs.foot = {
      enable = true;
      settings = {
        key-bindings = {
          show-urls-launch = "Control+Shift+o";
          show-urls-copy = "Control+Shift+i";
          pipe-command-output = "[${lib.getExe' pkgs.wl-clipboard "wl-copy"}] Control+Shift+g";
        };
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
}
