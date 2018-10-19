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

    #./wireguard.nix

    ./metrics.nix
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
    openssh = {
      enable = true;
      forwardX11 = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };

    #WARNING: Error retrieving accessibility bus address: org.freedesktop.DBus.Error.ServiceUnknown: The name org.a11y.Bus was not provided by any .service files
    gnome3.at-spi2-core.enable = true;

    kbfs.enable = true;
  };

  nix = {
    useSandbox = true;
    maxJobs = 2;
    #distributedBuilds = true;
    #buildMachines = [
    #  {
    #    hostName = "51.15.50.214";
    #    sshUser = "nix_remote";
    #    sshKey = "/root/.ssh/id_nix_remote_build";
    #    system = "x86_64-linux";
    #    maxJobs = 8;
    #  }
    #  {
    #    hostName = "51.15.50.214";
    #    sshUser = "nix_remote";
    #    sshKey = "/root/.ssh/id_nix_remote_build";
    #    system = "i686-linux";
    #    maxJobs = 8;
    #  }
    #];
  };

  nixpkgs.config.allowUnfree = true;

  powerManagement.cpuFreqGovernor = "powersave";

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
    };
    libvirtd.enable = true;
  };

  # broken by #43857
  #services.dockerRegistry.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      # was: load-module module-echo-cancel aec_method=webrtc use_volume_sharing=false
      # but this seems to work btter
      extraConfig = ''
          load-module module-echo-cancel
          load-module module-combine-sink sink_name=tee sink_properties=device.description="Tee"
        '';
      # without this, loading module-echo-cancel crashes the daemon
      daemon.config.flat-volumes = "no";
    };
    bluetooth.enable = true;
  };

  programs = {
    adb.enable = true; # this has a daemon i guess
    ssh = {
      startAgent = true;
      knownHosts = [{
        hostNames = [ "51.15.50.214" ];
        publicKeyFile = ./remote_build_host_key.pub;
      }];
    };
  };

  users.users = map (user: {
    name = user;
    extraGroups = [
      "adbusers"
      "networkmanager"
    ];
  }) config.adHoc.localUsers;
}
