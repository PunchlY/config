{inputs, ...}: {
  den.aspects.services.danmakus.nixos = {config, ...}: {
    sops.secrets.danmakus = {
      format = "dotenv";
      sopsFile = "${inputs.self}/secrets/danmakus.env";
      key = "";
    };

    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        danmakus = {
          image = "ghcr.io/81f9db2ec2/danmakus-core:latest";
          autoStart = true;
          volumes = ["danmakus-data:/app/.danmakus"];
          environmentFiles = [config.sops.secrets.danmakus.path];
          extraOptions = ["--name=danmakus"];
        };

        danmakus-watchtower = {
          image = "containrrr/watchtower:latest";
          autoStart = true;
          volumes = ["/var/run/docker.sock:/var/run/docker.sock"];
          cmd = ["--interval" "3600" "danmakus"];
        };
      };
    };
  };
}
