{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.services.openssh.enable {
      services.openssh.settings = {
        PasswordAuthentication = false;
        PubkeyAuthentication = true;
      };
    };
  };
}
