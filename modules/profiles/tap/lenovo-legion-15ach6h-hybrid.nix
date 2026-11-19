{inputs, ...}: {
  den.aspects.tap.nixos = _: {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h-nvidia
    ];

    hardware.nvidia.prime.amdgpuBusId = "PCI:05:0:0";
    hardware.nvidia.branch = "latest";
  };
}
