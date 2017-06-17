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

    windowManager = {
      openbox.enable = true;
      default = "openbox";
    };

    desktopManager.xterm.enable = false;

    autoRepeatDelay = 150;
    autoRepeatInterval = 25;

    exportConfiguration = true;
  };
}
