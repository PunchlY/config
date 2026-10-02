{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchpatch,
  pycryptodome,
  brotli,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "wongshandev";
  domain = "china_southern_power_grid_stat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "HA-grid-south";
    rev = "53f598e21bdfcff45ad4af1af5866c17009abd52";
    hash = "sha256-R1J/vW8iVVt++cEWgowt+ZgdmAukcbJR8bxl+Co/1yQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/wongshandev/HA-grid-south/pull/2.patch";
      hash = "sha256-BbFbWTEGAc/T5wkBlkr0BvaDWoXy57Td0vAu55CkI5g=";
    })
  ];

  dependencies = [
    pycryptodome
    brotli
  ];

  meta = {
    description = "Home Assistant intergration to get statictics from China Southern Power Grid (CSG)";
    homepage = "https://github.com/wongshandev/HA-grid-south";
    license = lib.licenses.gpl3Only;
  };
})
