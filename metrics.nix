{ pkgs, ... }:
{
  services = {
    prometheus = {
      enable = true;
      exporters.node.enable = true;
      extraFlags = [ "-storage.local.retention=87600h" ];
      scrapeConfigs = [
        {
          job_name = "prometheus";
          scrape_interval = "5s";
          static_configs = [
            {
              targets = [ "localhost:9090" ];
            }
          ];
        }
        {
          job_name = "vigil";
          scrape_interval = "5s";
          static_configs = [
            { targets = [ "localhost:24042" ]; }
            { targets = [ "localhost:9100" ]; }
          ];
        }
      ];
    };
    grafana = {
      enable = true;
      analytics.reporting.enable = false;
    };
  };

  environment.systemPackages = [ pkgs.laptop-stats ];
  systemd.services.laptop-stats = {
    script = "${pkgs.laptop-stats}/bin/laptop-stats";
    wantedBy = [ "multi-user.target" ];
  };
}
