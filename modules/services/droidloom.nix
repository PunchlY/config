{inputs, ...}: {
  flake-file.inputs = {
    droidloom.url = "github:pharra/droidloom-flake";
  };

  den.default.nixos = _: {
    imports = [inputs.droidloom.nixosModules.default];
  };

  den.aspects.owner.provides.to-hosts.nixos = {user, ...}: {
    services.droidloom.user = user.userName;
  };

  den.aspects.services.droidloom.nixos = _: {
    services.droidloom = {
      enable = true;
      manageSubIds = true;
      autoStart = false;
    };
  };
}
