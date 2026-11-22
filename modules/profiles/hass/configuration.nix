{
  inputs,
  den,
  ...
}: {
  den.hosts.x86_64-linux.hass.users.punchly = {};

  den.aspects.hass.includes = [
    (den.batteries.tty-autologin "punchly")
    den.aspects.services.danmakus
  ];

  den.aspects.hass.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: let
    httpStoreFile = (pkgs.formats.json {}).generate "home-assistant-http.json" {
      version = 3;
      minor_version = 1;
      key = "http";
      data = {
        stable = {
          server_port = 8123;
          cors_allowed_origins = ["https://cast.home-assistant.io"];
          ip_ban_enabled = true;
          login_attempts_threshold = -1;
          ssl_profile = "intermediate_v6";
          use_x_forwarded_for = true;
          use_x_frame_options = true;
          trusted_proxies = [
            "127.0.0.1/32"
            "::1/128"
            "172.30.33.0/24"
          ];
          created_at = "1970-01-01T00:00:00+00:00";
          error = null;
          error_message = null;
        };
        pending = null;
        yaml_migration_done = true;
      };
    };
  in {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    hardware.bluetooth.enable = true;

    networking.firewall = {
      allowedTCPPorts = [
        8123
      ];
    };

    sops.secrets.hass = {
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";

      format = "yaml";
      sopsFile = "${inputs.self}/secrets/hass.yaml";
      key = "";

      restartUnits = ["home-assistant.service"];
    };

    systemd.tmpfiles.rules = [
      "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
      "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
      "f ${config.services.home-assistant.configDir}/scripts.yaml 0755 hass hass"
    ];

    systemd.services.home-assistant = {
      preStart = lib.mkAfter ''
        install -d -m700 "${config.services.home-assistant.configDir}/.storage"
        install -m600 ${httpStoreFile} "${config.services.home-assistant.configDir}/.storage/http"
      '';
      restartTriggers = [httpStoreFile];
    };

    services.home-assistant = {
      enable = true;
      customComponents = lib.attrValues {
        inherit
          (pkgs.home-assistant-custom-components)
          xiaomi_home
          ;
        inherit
          (pkgs)
          home-assistant-grid-south
          home-assistant-haier
          home-assistant-midea-auto-cloud
          home-assistant-clash-controller
          ;
      };

      customLovelaceModules = lib.attrValues {
        inherit
          (pkgs.home-assistant-custom-lovelace-modules)
          mushroom
          ;
        inherit
          (pkgs.nur.repos.mrene)
          timer-bar-card
          ;
      };

      themes = lib.attrValues {
        inherit
          (pkgs.home-assistant-themes)
          material-you-theme
          ;
      };

      extraComponents = [
        "default_config"
        "met"
        "esphome"
        "roborock"
        "bthome"
        "homekit"
        "ffmpeg"
        "zeroconf"
        "midea"
      ];
      config = {
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";

        default_config = {};

        homeassistant = {
          external_url = "https://hass.punchly.eu.org";
          internal_url = "http://hass:8123/";

          name = "Home";
          unit_system = "metric";
          temperature_unit = "C";

          latitude = "!secret latitude";
          longitude = "!secret longitude";
          elevation = "!secret elevation";
          radius = 20;
        };
      };

      extraPackages = ps:
        lib.attrValues {
          inherit
            (ps)
            isal
            zlib-ng
            hap-python
            pyqrcode
            gtts
            ;
        };
    };

    sops.secrets.hass-cloudflared-credentials = {
      format = "json";
      sopsFile = "${inputs.self}/secrets/hass-cloudflared-credentials.json";
      key = "";
      mode = "0400";
    };

    services.cloudflared = {
      enable = true;
      tunnels."4a871ad8-cf18-431f-95eb-1821dacb2bee" = {
        credentialsFile = config.sops.secrets.hass-cloudflared-credentials.path;
        default = "http_status:404";
        ingress."hass.punchly.eu.org".service = "http://localhost:8123";
      };
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
