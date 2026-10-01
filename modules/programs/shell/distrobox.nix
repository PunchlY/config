{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.distrobox;
  in {
    config = lib.mkIf cfg.enable {
      programs.distrobox = {
        settings.container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";

        containers.fedora = {
          image = "fedora-toolbox:latest";
        };
      };
    };
  };
}
