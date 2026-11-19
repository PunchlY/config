{
  den.default.nixos = {lib, ...}: {
    services.logind.settings.Login = {
      HandlePowerKey = lib.mkDefault "suspend";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = lib.mkDefault "suspend";
      HandleLidSwitchExternalPower = lib.mkDefault "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
