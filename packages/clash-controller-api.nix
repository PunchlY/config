{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  hatchling,
}:
buildPythonPackage (finalAttrs: {
  pname = "clash-controller-api";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "myhades";
    repo = "clash-controller-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KwtCDCVfwj7YEibTs8DbFJFpehRmqHFROdeNC2YC5r4=";
  };

  build-system = [hatchling];

  dependencies = [aiohttp];

  meta = {
    description = "Async Python client for Clash-compatible controller APIs";
    homepage = "https://github.com/myhades/clash-controller-api";
    license = lib.licenses.mit;
  };
})
