{
  den.aspects.develop.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.gomi];
    home.shellAliases.rm = "gomi";

    xdg.configFile."gomi/config.yaml" = {
      source = (pkgs.formats.yaml {}).generate "gomi-config" {
        core.trash.strategy = "xdg";
      };
    };
  };
}
