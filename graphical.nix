{ ... }: {
  services.xserver = {
    enable = true;

    layout = "us";
    xkbOptions = "eurosign:e";

    synaptics = {
      enable = true;
      minSpeed = "0.6";
      maxSpeed = "1";
      accelFactor = "0.001";
    };

    displayManager.defaultSession = "none+openbox";
    windowManager = {
      openbox.enable = true;
    #  default = "none+openbox";
    };

    desktopManager.xterm.enable = false;

    autoRepeatDelay = 150;
    autoRepeatInterval = 25;

    exportConfiguration = true;
  };
}
