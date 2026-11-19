{
  den.aspects.desktop.homeManager = {
    programs.tray-tui = {
      enable = true;
      settings = {
        columns = 1;
      };
    };
  };

  den.aspects.desktop.homeManager = {
    xdg.desktopEntries.tray-tui = {
      name = "Tray";
      genericName = "System tray in your terminal";
      exec = "tray-tui";
      terminal = true;
    };
  };
}
