{den, ...}: {
  den.aspects.gaming.desktop.__functor = _self: desktopSession:
    den.lib.policy.when
    (ctx: ctx.hasAspect den.aspects.gaming)
    {
      name = "desktop(${desktopSession})";
      meta.aspect-chain = ["gaming"];
      nixos = _: {
        jovian.steam.desktopSession = desktopSession;
      };
    };
}
