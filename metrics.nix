{
  services = {
    prometheus = {
      enable = true;
      nodeExporter.enable = true;
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
          static_configs = [ { targets = [ "localhost:24042" ]; } ];
        }
      ];
    };
    grafana = {
      enable = true;
      analytics.reporting.enable = false;
    };
  };
}
