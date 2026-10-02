{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lupa,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "sususweet";
  domain = "midea_auto_cloud";
  version = "0.4.19";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "midea_auto_cloud";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DCskt1H4k5w05WuGKRWhEQoF9gSaepHYvxqnRAZ4EK0=";
  };

  dependencies = [
    lupa
  ];

  meta = {
    description = "Control Midea devices via Cloud from Home Assistant";
    homepage = "https://github.com/sususweet/midea_auto_cloud";
    license = lib.licenses.asl20;
  };
})
