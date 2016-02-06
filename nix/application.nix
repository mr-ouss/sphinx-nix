{
  machine = { config, resources, pkgs, ... }:
  let
    app = import ../. { pkgs = pkgs; };
  in
  {
    networking.firewall.enable = false;
    services.openssh.enable = true;
    services.nginx.enable = true;

    services.nginx.config = ''
      events { }
      http {
        include ${pkgs.nginx}/conf/mime.types;
        server {
          listen 80 default_server;
          server_name _;
          location / {
            alias ${app}/documentation/;
          }
        }
      }
    '';
  };
}
