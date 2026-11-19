{
  flake-file.inputs = {
    piri.url = "github:Asthestarsfalll/piri";
  };

  den.aspects.desktop.niri.homeManager = {
    inputs',
    pkgs,
    lib,
    ...
  }: {
    programs.niri.settings = {
      spawn-at-startup = [
        {
          argv = [(lib.getExe inputs'.piri.packages.default) "daemon"];
        }
      ];
    };

    xdg.configFile."niri/piri.toml" = {
      source = (pkgs.formats.toml {}).generate "piri-config" {
        piri.plugins.swallow = true;
      };
    };
  };
}
