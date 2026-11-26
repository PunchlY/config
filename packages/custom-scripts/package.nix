{
  symlinkJoin,
  replaceVarsWith,
  newScope,
  lib,
}: let
  callPackage = newScope (lib.mapAttrs (name: script: "${script}/bin/${name}") scripts);

  mkScript = name: src: let
    vars = lib.pipe src [
      lib.readFile
      (lib.split "@([a-zA-Z_][0-9A-Za-z_'-]*)@")
      (lib.filter lib.isList)
      (lib.map lib.head)
      lib.unique
    ];
  in
    callPackage (lib.setFunctionArgs (
      replacements:
        replaceVarsWith {
          inherit src name replacements;
          dir = "bin";
          isExecutable = true;
          meta.mainProgram = name;
        }
    ) (lib.genAttrs vars (_: false))) {};

  scripts =
    builtins.readDir ./scripts
    |> lib.mapAttrs' (name: _: let
      basename = lib.baseNameOf name;
      ext = lib.last (lib.splitString "." basename);
    in {
      name = lib.removeSuffix ".${ext}" basename;
      value = ./scripts/${name};
    })
    |> lib.mapAttrs mkScript;
in
  symlinkJoin {
    name = "cutstom-scripts";
    paths = lib.attrValues scripts;
    passthru.scripts = scripts;
  }
