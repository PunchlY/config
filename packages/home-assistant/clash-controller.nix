{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  clash-controller-api,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "myhades";
  domain = "clash_controller";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "ha-clash-controller";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/Xp61R9vpl9ixQjOyYSsPshrKmzcBNe89ZiGi0y+X1Q=";
  };

  dependencies = [
    clash-controller-api
  ];

  meta = {
    description = "A Home Assistant integration for controlling external Clash instances";
    homepage = "https://github.com/myhades/ha-clash-controller";
    license = lib.licenses.mit;
  };
})
