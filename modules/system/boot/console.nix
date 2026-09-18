{
  flake.modules.nixos.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors;
  in {
    config = lib.mkIf config.console.enable {
      console = {
        colors = lib.genList (i: colors."color${toString i}".hex_stripped) 16;
      };
    };
  };
}
