{
  inputs,
  den,
  lib,
  ...
}: {
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.den.flakeModules.dendritic
  ];

  flake-file.inputs = {
    flake-file.url = "github:denful/flake-file";
    den.url = "github:denful/den";

    home-manager.url = "github:nix-community/home-manager";
  };

  den.schema.host.includes = [
    ({host}:
      den.batteries.forward {
        each = [host];
        fromClass = _: "lib";
        intoClass = {class, ...}: class;
        intoPath = _: ["lib"];
        adaptArgs = lib.id;
      })
  ];

  den.schema.user.classes = ["user" "homeManager"];
  den.schema.user.includes = [
    ({user}:
      den.batteries.forward {
        each = [user];
        fromClass = _: "lib";
        intoClass = _: "homeManager";
        intoPath = _: ["lib"];
        adaptArgs = lib.id;
      })
  ];

  den.default.includes = [
    den.batteries.hostname
    den.batteries.define-user
    den.batteries.mutual-provider
    den.batteries.host-aspects
    # den.batteries.user-aspects
    den.batteries.inputs'
    den.batteries.self'
  ];

  den.default.nixos = _: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

    system.stateVersion = "26.11";
  };

  den.default.homeManager = _: {
    home.stateVersion = "26.11";
  };
}
