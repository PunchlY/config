{inputs, ...}: {
  den.aspects.desktop.homeManager = {
    config,
    pkgs,
    ...
  }: {
    disabledModules = ["${inputs.stylix}/modules/fcitx5/hm.nix"];

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = [
          pkgs.qt6Packages.fcitx5-chinese-addons
        ];

        settings.globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = "True";
            AltTriggerKeys = "";
            EnumerateForwardKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateGroupForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
            ActivateKeys = "";
            DeactivateKeys = "";
          };
          "Hotkey/TriggerKeys"."0" = "Super+space";
          Behavior = {
            ActiveByDefault = "False";
            ShareInputState = "No";
          };
          "Behavior/DisabledAddons"."0" = "cloudpinyin";
        };

        settings.inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "pinyin";
          GroupOrder."0" = "Default";
        };

        settings.addons.pinyin.globalSection = {
          PageSize = 5;
          CloudPinyinEnabled = "False";
          "Fuzzy/EN_ENG" = "True";
          "Fuzzy/IN_ING" = "True";
          "Fuzzy/C_CH" = "True";
          "Fuzzy/S_SH" = "True";
          "Fuzzy/Z_ZH" = "True";
        };
        settings.addons.clipboard.globalSection = {
          TriggerKey = "";
        };
        settings.addons.punctuation.globalSection = {
          Enabled = "False";
          HalfWidthPuncAfterLetterOrNumber = "True";
          "Hotkey/0" = "Control+period";
        };
      };
    };

    i18n.inputMethod.fcitx5 = {
      settings.addons.classicui.globalSection = {
        EnableFractionalScale = "True";

        Theme = "stylix";
        UseDarkTheme = false;
        UseAccentColor = false;

        Font = "${config.stylix.fonts.sansSerif.name} ${toString config.stylix.fonts.sizes.popups}";
        MenuFont = "${config.stylix.fonts.sansSerif.name} ${toString config.stylix.fonts.sizes.popups}";
        TrayFont = "${config.stylix.fonts.sansSerif.name} ${toString config.stylix.fonts.sizes.popups}";
      };

      themes.stylix = {
        theme = {
          InputPanel = {
            EnableBlur = false;
            NormalColor = config.lib.stylix.colors.withHashtag.base05;
            HighlightCandidateColor = config.lib.stylix.colors.withHashtag.base00;
            HighlightColor = config.lib.stylix.colors.withHashtag.base00;
            HighlightBackgroundColor = config.lib.stylix.colors.withHashtag.base00;
            Spacing = 3;
          };
          "InputPanel/TextMargin" = {
            Left = 10;
            Right = 10;
            Top = 6;
            Bottom = 6;
          };

          "InputPanel/Background".Color = config.lib.stylix.colors.withHashtag.base00;
          "InputPanel/Background/Margin" = {
            Left = 2;
            Right = 2;
            Top = 2;
            Bottom = 2;
          };

          "InputPanel/Highlight".Color = config.lib.stylix.colors.withHashtag.base09;
          "InputPanel/Highlight/Margin" = {
            Left = 10;
            Right = 10;
            Top = 7;
            Bottom = 7;
          };
        };
      };
    };
  };
}
