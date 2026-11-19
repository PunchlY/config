{den, ...}: {
  den.aspects.punchly.includes = [
    den.batteries.primary-user
  ];

  den.aspects.punchly.user = _: {
    description = "PunchlY";
    extraGroups = [
      "audio"
      "video"
      "input"
    ];
    initialHashedPassword = "$y$j9T$K/hxRPyR.lSbYJwU1kbEI.$Uk.bhCt/rESx.qWrrUhUKKJMitZpWjqJpA0.URGoKXB";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMvu8NSsF7TP9JxxPhHeij113Kmw61KSPfpbLQvpsoY punchly@nano"
    ];
  };

  den.aspects.punchly.homeManager = _: {
    programs.git = {
      settings.user = {
        name = "PunchlY";
        email = "punchly9lin@gmail.com";
      };
    };
  };

  den.aspects.punchly.jovian = {user, ...}: {
    steam.user = user.userName;
  };
}
