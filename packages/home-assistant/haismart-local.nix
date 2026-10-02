{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "enapt";
  domain = "haismart";
  version = "0.71.2";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "haismart-local";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4BPFFYw1TX5/S9+D2jr2mG+NWHaZURkdi0Iir9BwRhU=";
  };

  meta = {
    description = "Fully-local Home Assistant control for Haier appliances that pair with the Haismart (Haier U+/uHome, SE-Asia) app — no cloud, no hardware mods.";
    homepage = "https://github.com/enapt/haismart-local";
    license = lib.licenses.mit;
  };
})
