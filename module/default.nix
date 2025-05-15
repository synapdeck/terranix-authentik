{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./applications.nix
    ./outposts.nix
  ];

  options.authentik = {
    host = mkOption {
      type = types.str;
      description = "The URL of your Authentik instance";
      example = "https://auth.example.com/";
    };

    token = mkOption {
      type = types.nullOr types.str;
      description = "The token for your Authentik instance, or null to use the AUTHENTIK_TOKEN variable.";
      default = null;
      example = "your_token_here";
    };

    insecure = mkOption {
      type = types.bool;
      description = "Whether to allow insecure connections to Authentik.";
      default = false;
    };

    headers = mkOption {
      type = types.attrsOf types.str;
      description = "Additional headers to send with requests to Authentik.";
      default = {};
    };
  };

  config = {
    terraform.required_providers.authentik = {
      source = "goauthentik/authentik";
    };

    provider.authentik = {
      inherit (config.authentik) host;
      token = lib.mkIf (config.authentik.token != null) config.authentik.token;
      inherit (config.authentik) insecure;
      inherit (config.authentik) headers;
    };

    authentik.outpostSettings.authentik_host = lib.mkDefault config.authentik.host;
  };
}
