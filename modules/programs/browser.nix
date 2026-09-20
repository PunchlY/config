{
  nixpkgs.config = {
    allowUnfreePackages = [
      "google-chrome"
    ];
  };

  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.chromium;
  in {
    config = lib.mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.google-chrome.override {
          commandLineArgs = [
            "--disable-features=${lib.strings.concatMapStrings (x: x + ",") [
              "OptimizationGuideOnDeviceModel"
              "PromptAPIForGeminiNano"
            ]}"
          ];
        })
      ];

      programs.chromium = {
        extensions = lib.attrNames cfg.extraOpts.ExtensionSettings;
        extraOpts.ExtensionSettings = {
          # uBlock Origin Lite
          "ddkjiahejlhfcafbddmgiahcphecmpfh" = {
            toolbar_pin = "force_pinned";
          };
          # IPvFoo
          "ecanpcehffngcegjmadlcijfolapggal" = {
            toolbar_pin = "force_pinned";
          };
          # WebRTC Control
          "fjkmabmdepjfammlpliljpnbhleegehm" = {
            toolbar_pin = "force_pinned";
          };
          # Tampermonkey
          "dhdgffkkebhmkfjojejmpbldmpobfkfo" = {};
          # Aria2 Integration
          "hnenidncmoeebipinjdfniagjnfjbapi" = {
            toolbar_pin = "force_pinned";
          };
          # Firenvim
          "egpjdkipkomnmjhjmdamaniclmdlobbo" = {};
        };
        extraOpts = {
          RestoreOnStartup = 1;
          DefaultBrowserSettingEnabled = false;
        };
      };

      hm.xdg.configFile."google-chrome/NativeMessagingHosts/firenvim.json" = {
        source = pkgs.firenvim-native;
      };
    };
  };

  flake.modules.nixos.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors;
  in {
    config = lib.mkIf config.programs.chromium.enable {
      programs.chromium = {
        extraOpts = {
          BrowserThemeColor = colors.surface.hex;
          OsColorMode = "dark";
        };
      };
    };
  };
}
