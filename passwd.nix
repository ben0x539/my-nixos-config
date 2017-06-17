{ lib, ... }: {
  options = {
    adHoc.localUsers = with lib; mkOption {
      default = [];
      type = types.listOf types.string;
    };
  };

  config = {
    adHoc.localUsers = [ "ben" ]; # a bit lonely in here

    users.users = {
      ben = {
        createHome = false;
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
      };
    };
  };
}
