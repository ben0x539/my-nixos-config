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
  ];

  networking = {
    networkmanager.enable = true;
    #firewall.enable = false;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  console.keyMap = "us";

  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

  system = {
    stateVersion = "17.03";
    copySystemConfiguration = true;
  };

  environment = {
    etc = {
      nixos-orig.source = let x = builtins.filterSource (path: _type:
        builtins.trace (baseNameOf path)
        (baseNameOf path != ".git")
      ) ./.;
      in builtins.trace x x;
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
    #xserver.wacom.enable = true;

    #WARNING: Error retrieving accessibility bus address: org.freedesktop.DBus.Error.ServiceUnknown: The name org.a11y.Bus was not provided by any .service files
    gnome.at-spi2-core.enable = true;

    blueman.enable = true;

    #kubernetes = {
    #  roles = [ "master" "node" ];
    #  masterAddress = "localhost";
    #  kubelet.extraOpts = "--fail-swap-on=false";
    #};
  };

  nix = {
    useSandbox = true;
    maxJobs = 2;

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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
    # pulseaudio = {
    #   enable = true;
    #   package = pkgs.pulseaudioFull;
    #   support32Bit = true;
    #   # was: load-module module-echo-cancel aec_method=webrtc use_volume_sharing=false
    #   # but this seems to work btter
    #   extraConfig = ''
    #       load-module module-echo-cancel
    #       load-module module-combine-sink sink_name=tee sink_properties=device.description="Tee"
    #     '';
    #   # without this, loading module-echo-cancel crashes the daemon
    #   daemon.config.flat-volumes = "no";
    # };
    bluetooth = {
      enable = true;
      #package = pkgs.bluezFull;
    };
  };

  programs = {
    adb.enable = true; # this has a daemon i guess # 'android_sdk.accept_license = true;'
    ssh.startAgent = true;
    gnupg.agent.enable = true;
  };

  users.users = builtins.listToAttrs (map (user: {
    name = user;
    value = {
      extraGroups = [
        "adbusers"
        "networkmanager"
      ];
    };
  }) config.adHoc.localUsers);
}
