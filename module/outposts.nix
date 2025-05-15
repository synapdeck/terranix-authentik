{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkIf mkMerge;

  json = pkgs.formats.json {};

  baseOutpostConfig = {
    authentik_host_browser = "";
    authentik_host_insecure = false;
    container_image = null;
    docker_labels = null;
    docker_map_ports = true;
    docker_network = null;
    kubernetes_disabled_components = [];
    kubernetes_image_pull_secrets = [];
    kubernetes_ingress_annotations = {};
    kubernetes_ingress_class_name = null;
    kubernetes_ingress_secret_name = "authentik-outpost-tls";
    kubernetes_json_patches = null;
    kubernetes_namespace = "authentik";
    kubernetes_replicas = 1;
    kubernetes_service_type = "ClusterIP";
    log_level = "info";
    object_naming_template = "ak-outpost-%(name)s";
    refresh_interval = "minutes=5";
  };
in {
  options.authentik = {
    outpostSettings = mkOption {
      inherit (json) type;
      default = {};
      description = "Global configuration to apply to all outposts";
    };

    outposts = {
      proxy = {
        name = mkOption {
          type = types.str;
          default = "authentik Embedded Outpost";
          description = "The name of the Proxy outpost";
        };

        providers = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "List of proxy provider IDs for the embedded outpost";
        };

        tfResourceName = mkOption {
          type = types.str;
          default = "embedded-outpost";
          description = "The Terraform resource name for the embedded outpost";
        };
      };

      # LDAP outpost
      ldap = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable the LDAP outpost";
        };

        name = mkOption {
          type = types.str;
          default = "LDAP Outpost";
          description = "The name of the LDAP outpost";
        };

        providers = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "List of LDAP provider IDs";
        };

        config = mkOption {
          type = types.attrs;
          default = {};
          description = "Additional configuration for the LDAP outpost";
        };

        tfResourceName = mkOption {
          type = types.str;
          default = "ldap";
          description = "The Terraform resource name for the LDAP outpost";
        };
      };

      # RADIUS outpost
      radius = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable the RADIUS outpost";
        };

        name = mkOption {
          type = types.str;
          default = "RADIUS Outpost";
          description = "The name of the RADIUS outpost";
        };

        providers = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "List of RADIUS provider IDs";
        };

        config = mkOption {
          type = types.attrs;
          default = {};
          description = "Additional configuration for the RADIUS outpost";
        };

        tfResourceName = mkOption {
          type = types.str;
          default = "radius";
          description = "The Terraform resource name for the RADIUS outpost";
        };
      };
    };
  };

  config = mkMerge [
    # Only include outposts when host is defined
    (mkIf (config.authentik ? host && config.authentik.host != null) {
      resource.authentik_outpost = mkMerge [
        # Embedded outpost
        {
          "${config.authentik.outposts.embedded.tfResourceName}" = {
            inherit (config.authentik.outposts.embedded) name;
            type = "proxy";
            protocol_providers = config.authentik.outposts.embedded.providers;
          };
        }

        # LDAP outpost
        (mkIf config.authentik.outposts.ldap.enable {
          "${config.authentik.outposts.ldap.tfResourceName}" = {
            inherit (config.authentik.outposts.ldap) name;
            type = "ldap";
            protocol_providers = config.authentik.outposts.ldap.providers;
            config = builtins.toJSON (
              baseOutpostConfig
              // {authentik_host = config.authentik.host;}
              // config.authentik.outpostSettings.config
              // config.authentik.outposts.ldap.config
            );
          };
        })

        # RADIUS outpost
        (mkIf config.authentik.outposts.radius.enable {
          "${config.authentik.outposts.radius.tfResourceName}" = {
            inherit (config.authentik.outposts.radius) name;
            type = "radius";
            protocol_providers = config.authentik.outposts.radius.providers;
            config = builtins.toJSON (
              baseOutpostConfig
              // {authentik_host = config.authentik.host;}
              // config.authentik.outpostSettings.config
              // config.authentik.outposts.radius.config
            );
          };
        })
      ];
    })
  ];
}
