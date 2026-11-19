{den, ...}: {
  den.aspects.desktop.mako.includes = [
    den.aspects.desktop.fuzzel
  ];
  den.aspects.desktop.mako.homeManager = {
    services.mako = {
      enable = true;
      settings = {
        outer-margin = 0;
        margin = 8;
        padding = "8,16";
        border-size = 2;
        default-timeout = 5000;
        "urgency=high" = {
          default-timeout = 0;
        };
        on-button-left = ''exec makoctl menu -n "$id" -- fuzzel --dmenu --prompt "Select action: " --minimal-lines'';
      };
    };
  };
}
