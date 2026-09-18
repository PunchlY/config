{inputs, ...}: {
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [inputs.home-manager.flakeModules.default];

  flake.modules.nixos.base = {config, ...}: {
    imports = [inputs.home-manager.nixosModules.default];

    home-manager = {
      sharedModules = [
        {
          home.stateVersion = config.system.stateVersion;
        }
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

    hm.imports = [
      inputs.self.modules.homeManager.base
    ];
  };
}
