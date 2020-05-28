let
  addPatch = pkg: patch: pkg.overrideAttrs (super: {
    patches = [ patch ] ++ pkg.patches or [];
  });
  overlay = self: super: {
    pmount = addPatch super.pmount ./pmount-exfat.patch;
  };

in { ... }: {
  nixpkgs.overlays = [ overlay ];
}
