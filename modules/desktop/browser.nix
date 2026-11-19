{den, ...}: {
  den.aspects.desktop.includes = [
    den.aspects.services.searx
  ];
  den.aspects.desktop.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: let
    searx_url = "http://localhost:${toString config.services.searx.settings.server.port}";

    extensions = {
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
      # Get cookies.txt LOCALLY
      cclelndahbckbenkjhflpdbgdldlbecc = {
        toolbar_pin = "force_pinned";
      };
    };
  in {
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
      enable = true;
      extensions = lib.attrNames extensions;
      extraOpts.ExtensionSettings = extensions;
      extraOpts = {
        RestoreOnStartup = 1;
        DefaultBrowserSettingEnabled = false;
      };

      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "${searx_url}/search?q={searchTerms}";
      defaultSearchProviderSuggestURL = "${searx_url}/autocompleter?q={searchTerms}";
      extraOpts = {
        DefaultSearchProviderImageURL = "${searx_url}/static/themes/simple/img/favicon.svg";
        DefaultSearchProviderKeyword = "searx";
        DefaultSearchProviderName = "Searx";
      };
    };
  };
}
