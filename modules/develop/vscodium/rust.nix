{
  den.aspects.develop.vscodium.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = {
      extensions = [
        pkgs.vscode-extensions.rust-lang.rust-analyzer
      ];
      userSettings = {
        "rust-analyzer.rustfmt.overrideCommand" = [(lib.getExe pkgs.rustfmt) "--edition" "2024" "--config" "tab_spaces=2"];
      };
    };
  };
}
