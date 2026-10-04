{
  linkFarm,
  fetchurl,
}:
linkFarm "Brown Dust 2" {
  "BD2StarterSetup.exe" = fetchurl {
    url = "https://web.archive.org/web/20260815/https://pc.bd2.pmang.cloud/browndust2starter/starter/update/BD2StarterSetup.exe";
    hash = "sha256-igrJr4ct+eaa1HQap6rcBu1hPt89IisTsXPg/xAIHds=";
  };
}
