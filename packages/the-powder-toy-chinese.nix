{
  the-powder-toy,
  fetchFromGitHub,
}:
the-powder-toy.overrideAttrs {
  pname = "the-powder-toy-chinese";
  version = "100.1.400";

  src = fetchFromGitHub {
    owner = "Dragonrster";
    repo = "The-Powder-Toy-Chinese";
    rev = "d3ab305144df8eade02119c80e2d545e130cbc5c";
    hash = "sha256-MwOrbcNSWxT+7ITyn6famKoqWCPi+09XRiuwq80dBn4=";
  };
}
