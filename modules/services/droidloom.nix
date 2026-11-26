{inputs, ...}: {
  flake-file.inputs = {
    droidloom.url = "github:pharra/droidloom-flake";
  };

  den.aspects.owner.provides.to-hosts.nixos = {
    user,
    options,
    lib,
    ...
  }:
    lib.mkIf (options.services ? droidloom) {
      services.droidloom.user = user.userName;
    };

  den.aspects.services.droidloom.nixos = {...}: {
    imports = [inputs.droidloom.nixosModules.default];

    services.droidloom = {
      enable = true;
      manageSubIds = true;
      autoStart = false;
    };
  };
}
