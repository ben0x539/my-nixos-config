{
  networking = {
    hostName = "vigil";
    hostId = "aa0ad7e4";
  };

  adHoc.localUsers = [ "ben" ]; # a bit lonely in here

  security.pam.loginLimits = [
    {
      domain = "ben";
      type = "-";
      item = "memlock";
      value = 128 * 1024;

    }
  ];

  users.users = {
    ben = {
      createHome = false;
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" ];
    };
    dropoff = {
      createHome = false;
      isNormalUser = true;
    };
    vh = {
      createHome = false;
      isNormalUser = true;
      uid = 1001;
      extraGroups = [ "wheel" ];
    };
  };
}
