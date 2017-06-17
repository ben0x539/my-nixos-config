{ config, pkgs, lib, ... }:

{
  imports = [
    ./options.nix # adHoc.localUsers

    # get booted, get graphics
    # autogenerated hardware config gets at least swap device wrong,
    # so we do all of that in machine.nix instead.
    ./machine.nix

    # who lives here? hostname, users
    ./local.nix

    # openbox, touchpad/keyboard prefs
    ./graphical.nix

    # patch pmount to allow exfat
    ./overlays

    # systemPackages
    ./pkgs.nix
  ];

  networking = {
    networkmanager.enable = true;
    #firewall.enable = false;
  };

  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };

  system = {
    stateVersion = "17.03";
    copySystemConfiguration = true;
  };

  environment = {
    etc = {
      nixos-orig.source = ./.;
    };
    variables = {
      EDITOR = "vim";
    };
  };

  services = {
    openssh.enable = true;
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    #WARNING: Error retrieving accessibility bus address: org.freedesktop.DBus.Error.ServiceUnknown: The name org.a11y.Bus was not provided by any .service files
    gnome3.at-spi2-core.enable = true;
  };

  nix = {
    useSandbox = true;
    maxJobs = 8;
  };
  nixpkgs.config.allowUnfree = true;

  powerManagement.cpuFreqGovernor = "powersave";

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
    libvirtd.enable = true;
  };

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  programs.adb.enable = true; # this has a daemon i guess

  users.users = map (user: {
    name = user;
    extraGroups = [
      "adbusers"
      "networkmanager"
    ];
  }) config.adHoc.localUsers;
}
