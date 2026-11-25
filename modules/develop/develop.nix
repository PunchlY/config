{den, ...}: {
  den.aspects.develop.includes = [
    (den.batteries.user-shell "bash")
  ];

  den.aspects.develop.nixos = _: {
    environment.pathsToLink = ["/share/bash-completion"];
  };

  den.aspects.develop.homeManager = {pkgs, ...}: {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        custom-scripts
        just
        nix-output-monitor
        nh
        nurl
        moreutils
        wget
        q
        yq-go
        tree
        exiftool
        android-tools
        xdg-user-dirs
        screen
        gdu
        ;

      man-pages = pkgs.nur.repos.moraxyc.man-pages-zh;
    };

    home.shellAliases = {
      ".." = "cd ..";
      "-" = "cd -";

      mx = "chmod a+x";

      cls = "clear";
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyControl = ["ignoredups"];
      initExtra = ''
        PS1='\[\e[?7l\e[30m\e[46m\] '$(. /etc/os-release;printf "%s" "$NAME")' \[\e[44m\] \u@\h:\w \[\e[0m\e[?7h\]\n\$ '
      '';
    };

    programs.aria2.enable = true;

    programs.atuin = {
      enable = true;
      daemon.enable = true;
      flags = [
        # "--disable-up-arrow"
        "--disable-ai"
      ];
    };

    programs.bat.enable = true;

    programs.bottom.enable = true;

    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      colors = "auto";
      icons = "auto";
      git = true;
      extraOptions = [
        "--classify=auto"
        "--group-directories-first"
        "--hyperlink=auto"
      ];
    };

    programs.fd.enable = true;

    programs.fzf = {
      enable = true;
      historyWidget.command = "";
    };

    programs.git.enable = true;

    programs.grep.enable = true;

    programs.jq.enable = true;

    programs.lazygit.enable = true;

    programs.opencode.enable = true;

    programs.ripgrep.enable = true;

    programs.ripgrep-all.enable = true;

    programs.tmux.enable = true;

    programs.vivid.enable = true;
  };
}
