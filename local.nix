{
  networking = {
    hostName = "vigil";
    hostId = "aa0ad7e4";
  };

  adHoc.localUsers = [ "ben" ]; # a bit lonely in here

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
