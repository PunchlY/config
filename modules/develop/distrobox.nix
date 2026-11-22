{
  den.aspects.develop.distrobox.nixos = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  };
  den.aspects.develop.distrobox.homeManager = {
    programs.distrobox = {
      enable = true;
      settings.container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";

      containers.fedora = {
        image = "fedora-toolbox:latest";
      };
    };
  };
}
