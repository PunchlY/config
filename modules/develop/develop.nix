{den, ...}: {
  den.aspects.develop.includes = [
    (den.batteries.user-shell "bash")
  ];

  den.aspects.develop.nixos = _: {
    environment.pathsToLink = ["/share/bash-completion"];
  };

  den.aspects.develop.homeManager = _: {
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

    programs.ripgrep.enable = true;

    programs.ripgrep-all.enable = true;
  };
}
