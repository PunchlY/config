{
  den.aspects.develop.homeManager = {pkgs, ...}: {
    home.shellAliases = {
      ff = "fastfetch";
    };

    programs.fastfetch = {
      enable = true;

      package = pkgs.fastfetch-unwrapped;

      settings = {
        logo.position = "top";
        display = {
          color = "blue";
          disableLinewrap = true;
          separator = " ";
          key.width = 8;
        };
        modules = [
          {
            key = "OS";
            type = "os";
          }
          {
            key = "Kernel";
            type = "kernel";
          }
          {
            key = "Shell";
            type = "shell";
          }
          {
            key = "Term";
            type = "terminal";
          }
          {
            key = "WM";
            type = "wm";
          }
          {
            paddingLeft = 7;
            type = "colors";
          }
        ];
      };
    };
  };
}
