{ lib, ... }:

{
  options = {
    adHoc.localUsers = with lib; mkOption {
      default = [];
      type = types.listOf types.string;
    };
  };
}
