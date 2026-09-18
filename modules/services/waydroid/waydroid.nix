{moduleWithSystem, ...}: {
  flake-file.inputs = {
    waydroid-script = {
      url = "github:casualsnek/waydroid_script";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = moduleWithSystem ({inputs'}: {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf (config.virtualisation.waydroid.enable || config.services.waydroid-nvidia.enable) {
      environment.systemPackages = [
        inputs'.waydroid-script.packages.default
      ];

      # Tell waydroid to use memfd and not ashmem
      systemd.tmpfiles.settings.waydroid-settings."/var/lib/waydroid/waydroid_base.prop".C = {
        user = "root";
        group = "root";
        mode = "0644";
        argument = "${pkgs.writeText "waydroid_base.prop" ''
          sys.use_memfd=true
        ''}";
      };

      hm.games.waydroid.enable = true;
    };
  });

  flake.modules.homeManager.gaming = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.games.waydroid;
  in {
    options.games.waydroid = {
      enable = lib.mkEnableOption "waydroid";
      package = lib.mkPackageOption pkgs "waydroid-launcher" {};
    };

    config = lib.mkIf cfg.enable {
      programs.steam.config.nonSteamApps.Waydroid = {
        desktopEntry.enable = false;

        target = cfg.package;

        artwork = {
          cover = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/3326cc06add44197e71b0b7e6e266bab.png";
            hash = "sha256-9uEIUd/VmHw8QIM6r+SS+OeBkmrl7Cj+p1z8vCgVX1E=";
          };
          header = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/fe92ffa3e171450671eea26a3f5246e1.jpg";
            hash = "sha256-Gu5GyI3lFtM17VYEs/StkrquqQjWhKflpoFegw2ghAo=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/ee22b2f4c529c8dcc05e24ba6f7e7f34.jpg";
            hash = "sha256-9uZQ6ZJBD9QXhY/x2jB2mAa3Hjvmx/Ttr5lewn/GeTw=";
          };
          icon = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/d6de4f0418bf4015017f5c65cdecc46e.png";
            hash = "sha256-ZQNyP8k4caAhQzk99bvyKjizPtiGSMFNqW2okpaeH1g=";
          };
          logo = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/logo/eb23fe2641003ad07d93ebdd63300629.png";
            hash = "sha256-z/mxLo5QoZDacuadbcCtQVY6/+TNiSyoCGUL+DKwbOo=";
          };
        };
      };
    };
  };
}
