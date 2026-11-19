{den, ...}: {
  den.schema.host.includes = [
    den.aspects.services.sshd
  ];

  den.aspects.services.sshd.nixos = _: {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PubkeyAuthentication = true;
      };
    };
  };
}
