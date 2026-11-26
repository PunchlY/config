{
  inputs,
  den,
  lib,
  ...
}: {
  flake-file.inputs = {
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.autoFollow = false;
      inputs.rust-overlay.autoFollow = false;
      inputs.rust-overlay.inputs.nixpkgs.autoFollow = false;
    };

    steam-config-nix.url = "github:different-name/steam-config-nix";
  };

  flake-file.nixConfig = {
    substituters = ["https://ezkea.cachix.org"];
    trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };

  den.schema.user.includes = [
    {
      homeManager = _: {
        imports = [inputs.steam-config-nix.homeModules.default];
      };
    }
    ({user}:
      den.batteries.forward {
        each = [user];
        fromClass = _: "steamConfig";
        intoClass = _: "homeManager";
        intoPath = _: ["programs" "steam" "config"];
        adaptArgs = lib.id;
      })
  ];

  den.aspects.gaming.includes = [
    den.aspects.plymouth
  ];

  den.aspects.owner.provides.to-hosts.nixos = {
    user,
    options,
    ...
  }:
    lib.mkIf (options ? jovian) {
      jovian.steam.user = user.userName;
    };

  den.aspects.gaming.nixpkgs = _: {
    overlays = [
      (den.lib.mkOverlay inputs.aagl)
    ];
  };

  den.aspects.gaming.nixos = {lib, ...}: {
    imports = [
      "${inputs.aagl}/module"
      inputs.chaotic.vendored.jovian.nixosModules.default
    ];

    networking.mihoyo-telemetry.block = true;

    jovian.steam = {
      enable = true;
      autoStart = true;
      desktopSession = lib.mkDefault "gamescope-wayland";
      environment.PROTON_USE_RAW_INPUT = "1";
    };
  };

  den.aspects.gaming.homeManager = {lib, ...}: {
    programs.steam.config.enable = true;

    xdg.desktopEntries.switch-to-game-mode = {
      name = "Game Mode";
      genericName = "Game Mode";
      exec = "steamosctl switch-to-game-mode";
    };

    xdg.dataFile = {
      "Steam/config/htmlcache/External Extensions/kdbmhfkmnlmbkgbabkdealhhbfhlmmon.json".text = lib.toJSON {
        external_update_url = "https://clients2.google.com/service/update2/crx";
      };
    };
  };
}
