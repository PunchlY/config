{lib, ...}: {
  options.configurations = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [];
    };
  };
}
