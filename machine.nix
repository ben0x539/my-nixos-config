{ config, pkgs, lib, ... }:

{
  # get booted
  boot = {
    plymouth.enable = false;
    loader.grub = {
      enable = true;
      version = 2;

      device = "/dev/sda";
      extraEntries = ''
        menuentry "Windows 10" {
          chainloader (hd1,1)+1
        }
      '';
    };

    kernelParams = [];

    initrd = {
      availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "sdhci_pci" ];
    };
    kernelModules = [ "kvm-intel" ];
    #kernelPackages = pkgs.linuxPackages_5_10;
    blacklistedKernelModules = [ "i915" "intel_agp" ];
  };

  systemd.services.zfs-mount.requiredBy = [ "local-fs.target" ];

  # // might make it not wait for the swap device to come up?
  swapDevices = [ { device = "//dev/zvol/vigil/swap"; } ];

  fileSystems = {
    "/" = {
      device = "vigil/nixos";
      fsType = "zfs";
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_1TB_S2RFNX0H612580Z-part6";
        label = "vigil-luks";
      };
      label = "vigil-luks";
    };

    "/boot" = {
        device = "/dev/disk/by-uuid/99180f49-2cd3-4aba-b55b-219c734fba67";
        fsType = "ext2";
      };

    # "/home/ben/win7" = {
    #   device = "/dev/disk/by-uuid/98CA864ACA86251A";
    #   fsType = "ntfs-3g";
    #   options = [ "nofail" "noauto" ];
    # };
  };

  # iwlwifi firmware
  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];

  # don't suspend on lid close, don't shutdown on power key
  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=suspend
    '';
  };

  #hardware.bumblebee.enable = true;
  # X: proprietary nvidia drivers
  services.xserver = {
    videoDrivers = [ "nvidia" ]; # [ "nvidiaLegacy390" ];
    deviceSection = ''
      Option "NoLogo" "TRUE"
      # Option "ModeValidation" "DFP-1: AllowNonEdidModes"
    '';

    dpi = 72;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
  };

  hardware.opengl.driSupport32Bit = true;
  #hardware.pulseaudio.support32Bit = true;
  #fonts.fontconfig.dpi = 96;
}
