{
  flake.modules.nixosConfiguration.base = {
    config,
    lib,
    ...
  }: {
    options.owner = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "PunchlY";
      };
      username = lib.mkOption {
        type = lib.types.str;
        default = "punchly";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "punchly9lin@gmail.com";
      };
      keys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMvu8NSsF7TP9JxxPhHeij113Kmw61KSPfpbLQvpsoY punchly@nano"
        ];
      };
      initialHashedPassword = lib.mkOption {
        type = lib.types.str;
        default = "$y$j9T$K/hxRPyR.lSbYJwU1kbEI.$Uk.bhCt/rESx.qWrrUhUKKJMitZpWjqJpA0.URGoKXB";
      };
    };
    config.host = {
      imports = [
        (lib.mkAliasOptionModule ["user"] ["users" "users" config.owner.username])
        (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.owner.username])
      ];

      user = {
        uid = 1000;
        isNormalUser = true;
        useDefaultShell = true;
        initialHashedPassword = config.owner.initialHashedPassword;

        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "video"
          "input"
        ];

        openssh.authorizedKeys.keys = config.owner.keys;
      };

      hm.programs.git = {
        settings.user = {
          name = config.owner.name;
          email = config.owner.email;
        };
      };
    };
  };
}
