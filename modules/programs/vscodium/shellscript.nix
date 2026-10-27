{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = [
        pkgs.vscode-marketplace.mkhl.shfmt
      ];
      userSettings = {
        "shfmt.executablePath" = lib.getExe pkgs.shfmt;
        "shfmt.executableArgs" = ["-i" "2" "-s"];
      };
      userSettings."[shellscript]" = {
        "editor.defaultFormatter" = "mkhl.shfmt";
      };
    };
  };
}
