{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = [
        pkgs.vscode-marketplace.jnoortheen.nix-ide
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nil;
        "nix.serverSettings".nil = {
          formatting.command = [(lib.getExe pkgs.alejandra)];
        };
        "nix.hiddenLanguageServerErrors" = [
          "textDocument/definition"
          "textDocument/documentSymbol"
          "textDocument/formatting"
        ];
      };
      userSettings."[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
    };
  };
}
