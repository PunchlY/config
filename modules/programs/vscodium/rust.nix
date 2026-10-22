{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
      userSettings = {
        "rust-analyzer.rustfmt.overrideCommand" = [(lib.getExe pkgs.rustfmt) "--edition" "2024" "--config" "tab_spaces=2"];
      };
    };
  };
}
