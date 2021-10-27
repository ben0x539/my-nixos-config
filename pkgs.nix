{ pkgs, ... }: {
  # fairly limited env, ideally just enough to fix shit when installing more
  # packages is not an option
  environment.systemPackages = with pkgs; [
    psmisc # killall
    findutils
    lsof
    file
    sysstat

    rsync
    screen

    # TODO: I think this pulls in X/X libs, which sucks, but regular vim
    # sucks more.
    vim_configurable

    exfat
    pmount # this is here because it can't get setuid-wrapped from a user env
  ];

  security.wrappers = {
    pmount = {
      source = "${pkgs.pmount.out}/bin/pmount";
      owner = "root";
      group = "root";
    };
    pumount = {
      source = "${pkgs.pmount.out}/bin/pumount";
      owner = "root";
      group = "root";
    };
  };
}

