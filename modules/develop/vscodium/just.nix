{
  den.aspects.develop.vscodium.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = {
      extensions = [
        pkgs.vscode-extensions.nefrob.vscode-just-syntax
      ];
      userSettings = {
        "vscode-just.lspPath" = lib.getExe pkgs.just-lsp;
      };
      userSettings."[just]" = {
        "editor.defaultFormatter" = "nefrob.vscode-just-syntax";
      };
    };
  };
}
