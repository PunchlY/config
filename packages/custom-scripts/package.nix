{
  symlinkJoin,
  replaceVarsWith,
  makeDesktopItem,
  copyDesktopItems,
  newScope,
  lib,
}: let
  callPackage = newScope (lib.mapAttrs (name: script: "${script}/bin/${name}") scripts);

  mkScripts = lib.flip lib.genAttrs' (script: let
    attrs =
      if lib.isPath script
      then {src = script;}
      else script;
    vars = lib.pipe attrs.src [
      lib.readFile
      (lib.split "@([a-zA-Z_][0-9A-Za-z_'-]*)@")
      (lib.filter lib.isList)
      (lib.map lib.head)
      lib.unique
    ];
    basename = lib.baseNameOf attrs.src;
    ext = lib.last (lib.splitString "." basename);
    name = lib.removeSuffix ".${ext}" basename;
  in {
    inherit name;
    value = callPackage (lib.setFunctionArgs (
      replacements:
        replaceVarsWith (attrs
          // {
            inherit name replacements;
            dir = "bin";
            isExecutable = true;
            meta.mainProgram = name;
          })
    ) (lib.genAttrs vars (_: false))) {};
  });

  scripts = mkScripts [
    ./scripts/2nix.sh
    ./scripts/ai-commit.sh
    ./scripts/ips.sh
    ./scripts/nstore.sh
    ./scripts/fileurl.sh
    ./scripts/pkgs.sh
    ./scripts/qrscan.sh
    {
      src = ./scripts/scrcpy-finder.sh;
      desktopItems = [
        (makeDesktopItem {
          name = "scrcpy-finder";
          exec = "scrcpy-finder";
          desktopName = "Scrcpy Finder";
        })
      ];
      nativeBuildInputs = [
        copyDesktopItems
      ];
    }
  ];
in
  symlinkJoin {
    name = "cutstom-scripts";
    paths = lib.attrValues scripts;
    passthru.scripts = scripts;
  }
