{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge mapAttrs mapAttrs' mapAttrsToList filterAttrs nameValuePair imap0 flatten listToAttrs;
  json = pkgs.formats.json {};

  filterNulls = attrsSet: filterAttrs (_name: value: value != null) attrsSet;

  ldapOptions = types.submodule {
    options = {
      baseDn = mkOption {
        type = types.str;
        description = "LDAP base DN";
      };

      bindMode = mkOption {
        type = types.enum ["direct" "search"];
        default = "search";
        description = "LDAP binding mode";
      };

      searchMode = mkOption {
        type = types.enum ["direct" "anonymous"];
        default = "anonymous";
        description = "LDAP search mode";
      };

      tlsServerName = mkOption {
        type = types.str;
        description = "LDAP TLS server name for SNI";
      };

      extraConfig = mkOption {
        inherit (json) type;
        default = {};
        description = "Extra attributes to pass directly to the authentik_provider_ldap resource.";
      };
    };
  };

  oauth2RedirectUriOptions = types.submodule {
    options = {
      url = mkOption {
        type = types.str;
        description = "Redirect URI";
      };
      matchingMode = mkOption {
        type = types.enum ["strict" "startsWith"];
        default = "strict";
        description = "URI matching mode";
      };
    };
  };

  oauth2Options = types.submodule {
    options = {
      clientId = mkOption {
        type = types.str;
        description = "OAuth2 client ID";
      };

      clientSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "OAuth2 client secret (can be null for public clients)";
      };

      clientType = mkOption {
        type = types.enum ["confidential" "public"];
        default = "confidential";
        description = "OAuth2 client type, either confidential (can securely store client secrets) or public (cannot securely store secrets, like mobile or browser-based apps)";
      };

      redirectUris = mkOption {
        type = types.listOf oauth2RedirectUriOptions;
        description = "List of allowed redirect URIs";
      };

      launchUrl = mkOption {
        type = types.str;
        default = "";
        description = "URL to launch the application";
      };

      backchannelLdap = mkOption {
        type = types.nullOr ldapOptions;
        default = null;
        description = "LDAP configuration for backchannel authentication";
      };

      subMode = mkOption {
        type = types.enum ["hashed_user_id" "user_id" "user_uuid" "user_username" "user_email" "user_upn"];
        default = "hashed_user_id";
        description = "OAuth2 subject mode. Determines how user identifiers are included in tokens.";
      };

      extraConfig = mkOption {
        inherit (json) type;
        default = {};
        description = "Extra attributes to pass directly to the authentik_provider_oauth2 resource.";
      };
    };
  };

  proxyOptions = types.submodule {
    options = {
      externalHost = mkOption {
        type = types.str;
        description = "External host URL for the proxy";
      };

      extraConfig = mkOption {
        inherit (json) type;
        default = {};
        description = "Extra attributes to pass directly to the authentik_provider_proxy resource.";
      };

      basicAuth = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable passing basic authentication to the proxied application";
        };
        username = mkOption {
          type = types.str;
          default = "username";
          description = "User/group attribute to use for username";
        };
        password = mkOption {
          type = types.str;
          default = "password";
          description = "User/group attribute to use for password";
        };
      };
    };
  };

  entitlementOptions = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the entitlement";
      };

      groups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Groups that have this entitlement";
      };
    };
  };
in {
  options.authentik.applications = mkOption {
    type = types.attrsOf (types.submodule ({name, ...}: {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable this Authentik application definition.";
        };

        # --- Basic application attributes ---
        name = mkOption {
          type = types.str;
          default = name;
          description = "Display name of the application in Authentik.";
        };

        slug = mkOption {
          type = types.str;
          default = name;
          description = "Internal slug for the application (e.g., for URLs). Defaults to the application's attribute name.";
        };

        group = mkOption {
          type = types.str;
          default = "";
          description = "The group this application belongs to in the UI";
        };

        description = mkOption {
          type = types.str;
          default = "";
          description = "A description of the application";
        };

        icon = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "URL or path to the application icon";
        };

        # --- Application behavior ---
        openInNewTab = mkOption {
          type = types.bool;
          default = true;
          description = "Specifies if the application should be opened in a new tab.";
        };

        policyEngineMode = mkOption {
          type = types.enum ["any" "all"];
          default = "any";
          description = ''
            Policy engine mode.
            - "any": Pass if any policy passes.
            - "all": Pass if all policies pass.
          '';
        };

        accessGroups = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Groups that can access this application";
        };

        # --- Provider configurations ---
        ldap = mkOption {
          type = types.nullOr ldapOptions;
          default = null;
          description = "LDAP provider configuration";
        };

        oauth2 = mkOption {
          type = types.nullOr oauth2Options;
          default = null;
          description = "OAuth2 provider configuration";
        };

        proxy = mkOption {
          type = types.nullOr proxyOptions;
          default = null;
          description = "Proxy provider configuration";
        };

        protocolProvider = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Reference to an existing provider. Use this only if you're not using the built-in provider options.";
        };

        # --- Entitlements for permissions ---
        entitlements = mkOption {
          type = types.listOf entitlementOptions;
          default = [];
          description = "Entitlements for in-application permissions";
        };

        # --- Advanced configuration ---
        tfResourceName = mkOption {
          type = types.str;
          default = name;
          description = "Explicitly set the Terraform resource name. Defaults to the application's attribute name.";
        };

        extraConfig = mkOption {
          inherit (json) type;
          default = {};
          description = "Extra attributes to pass directly to the authentik_application resource.";
        };
      };
    }));
    default = {};
    description = "Configuration for Authentik applications to be managed by Terranix.";
    example = lib.literalExpression ''
      authentik.applications = {
        grafana = {
          group = "Monitoring";
          description = "Grafana monitoring dashboard";
          icon = "https://example.com/grafana.png";
          accessGroups = ["admins" "monitoring-users"];

          # OAuth2 provider configuration
          oauth2 = {
            clientId = "grafana";
            clientSecret = "supersecret"; # Required for confidential clients
            clientType = "confidential"; # server-side app that can store secrets
            redirectUris = [
              { url = "https://grafana.example.com/login/generic_oauth"; }
            ];
            launchUrl = "https://grafana.example.com";
          };

          # Entitlements for in-app permissions
          entitlements = [
            {
              name = "Grafana Admin";
              groups = ["grafana-admins"];
            }
            {
              name = "Grafana Editor";
              groups = ["grafana-editors"];
            }
          ];
        };

        wiki = {
          name = "Internal Wiki";
          group = "Documentation";
          description = "Company documentation";
          icon = "https://example.com/wiki.png";
          accessGroups = ["employees"];

          # Proxy provider configuration
          proxy = {
            externalHost = "https://wiki.example.com";
            basicAuth = {
              enable = true;
              username = "email";
              password = "uid";
            };
          };
        };

        mobileapp = {
          name = "Mobile Application";
          group = "Apps";
          description = "Mobile application using OAuth2";
          icon = "https://example.com/app.png";
          accessGroups = ["employees"];

          # OAuth2 configuration for a public client (mobile app)
          oauth2 = {
            clientId = "mobileapp";
            clientSecret = null; # Null for public clients
            clientType = "public"; # Mobile app that cannot securely store secrets
            redirectUris = [
              {
                url = "com.example.app:/oauth2callback";
                matchingMode = "exact";
              }
            ];
            launchUrl = "com.example.app:/home";
          };
        };
      };
    '';
  };

  config = mkIf (config.authentik.applications != {} && config.authentik.applications != null) {
    resource = {
      # --- Generate OAuth2 providers based on application configurations ---
      authentik_provider_oauth2 = mapAttrs' (
        name: cfg:
          nameValuePair
          "${name}-oauth2" {
            name = "${cfg.name} (OAuth2)";
            authorization_flow = config.data.authentik_flow.default-authorization-flow "id";
            invalidation_flow = config.data.authentik_flow.default-provider-invalidation-flow "id";
            client_id = cfg.oauth2.clientId;
            client_secret =
              if cfg.oauth2.clientSecret == null
              then ""
              else cfg.oauth2.clientSecret;
            client_type = cfg.oauth2.clientType;
            allowed_redirect_uris =
              map (uri: {
                inherit (uri) url;
                matching_mode = uri.matchingMode;
              })
              cfg.oauth2.redirectUris;
            sub_mode = cfg.oauth2.subMode;
            property_mappings = config.data.authentik_property_mapping_provider_scope.with_entitlements "ids";
          } // cfg.oauth2.extraConfig
      ) (filterAttrs (_name: cfg: cfg.enable && cfg.oauth2 != null) config.authentik.applications);

      # --- Generate Proxy providers based on application configurations ---
      authentik_provider_proxy = mapAttrs' (
        name: cfg:
          nameValuePair
          "${name}-proxy" {
            name = "${cfg.name} (Proxy)";
            external_host = cfg.proxy.externalHost;
            basic_auth_enabled = cfg.proxy.basicAuth.enable;
            basic_auth_username_attribute = mkIf cfg.proxy.basicAuth.enable cfg.proxy.basicAuth.username;
            basic_auth_password_attribute = mkIf cfg.proxy.basicAuth.enable cfg.proxy.basicAuth.password;
            mode = "forward_single";
            access_token_validity = "days=1";
            authorization_flow = config.data.authentik_flow.default-authorization-flow "id";
            invalidation_flow = config.data.authentik_flow.default-provider-invalidation-flow "id";
          } // cfg.proxy.extraConfig
      ) (filterAttrs (_name: cfg: cfg.enable && cfg.proxy != null) config.authentik.applications);

      # --- Generate LDAP providers based on application configurations ---
      authentik_provider_ldap = mkMerge [
        # Primary LDAP providers
        (mapAttrs' (
          name: cfg:
            nameValuePair
            "${name}-ldap" {
              name = "${cfg.name} (LDAP)";
              base_dn = cfg.ldap.baseDn;
              bind_mode = cfg.ldap.bindMode;
              search_mode = cfg.ldap.searchMode;
              bind_flow = config.data.authentik_flow.default_authentication_flow "id";
              unbind_flow = config.data.authentik_flow.default_invalidation_flow "id";
              tls_server_name = cfg.ldap.tlsServerName;
            } // cfg.ldap.extraConfig
        ) (filterAttrs (_name: cfg: cfg.enable && cfg.ldap != null) config.authentik.applications))

        # Backchannel LDAP providers
        (mapAttrs' (
            name: cfg:
              nameValuePair
              "${name}-backchannel" {
                name = "${cfg.name} (LDAP Backchannel)";
                base_dn = cfg.oauth2.backchannelLdap.baseDn;
                bind_mode = cfg.oauth2.backchannelLdap.bindMode;
                search_mode = cfg.oauth2.backchannelLdap.searchMode;
                bind_flow = config.data.authentik_flow.default_authentication_flow "id";
                unbind_flow = config.data.authentik_flow.default_invalidation_flow "id";
                tls_server_name = cfg.oauth2.backchannelLdap.tlsServerName;
              } // cfg.oauth2.backchannelLdap.extraConfig
          ) (filterAttrs (
              _name: cfg:
                cfg.enable && cfg.oauth2 != null && cfg.oauth2.backchannelLdap != null
            )
            config.authentik.applications))
      ];

      # --- Generate application resources ---
      authentik_application = mapAttrs (
        name: cfg: let
          # Determine which protocol provider to use based on configuration
          determinedProtocolProvider =
            if cfg.protocolProvider != null
            then cfg.protocolProvider # Direct provider reference
            else if cfg.oauth2 != null
            then config.resource.authentik_provider_oauth2."${name}-oauth2" "id"
            else if cfg.proxy != null
            then config.resource.authentik_provider_proxy."${name}-proxy" "id"
            else if cfg.ldap != null
            then config.resource.authentik_provider_ldap."${name}-ldap" "id"
            else null;

          # Common attributes for all applications
          baseAttrs = {
            inherit (cfg) name;
            inherit (cfg) slug;
            policy_engine_mode = cfg.policyEngineMode;
            open_in_new_tab = cfg.openInNewTab;
            meta_description = cfg.description;
            meta_icon = cfg.icon;
            inherit (cfg) group;
          };

          # Add determined protocol provider if available
          providerAttrs =
            if determinedProtocolProvider != null
            then {protocol_provider = determinedProtocolProvider;}
            else {};

          # Add meta_launch_url if available from oauth2 config
          launchUrlAttrs =
            if cfg.oauth2 != null && cfg.oauth2.launchUrl != ""
            then {meta_launch_url = cfg.oauth2.launchUrl;}
            else {};

          # Add backchannel providers if needed
          backchannelAttrs =
            if cfg.oauth2 != null && cfg.oauth2.backchannelLdap != null
            then {backchannel_providers = [config.resource.authentik_provider_ldap."${name}-backchannel" "id"];}
            else {};

          # Combine all attributes
          allAttrs = baseAttrs // providerAttrs // launchUrlAttrs // backchannelAttrs // cfg.extraConfig;
        in
          filterNulls allAttrs
      ) (filterAttrs (_name: cfg: cfg.enable) config.authentik.applications);

      # --- Generate application entitlements ---
      authentik_application_entitlement = listToAttrs (
        flatten (
          mapAttrsToList (
            name: cfg:
              imap0 (idx: entitlement: {
                name = "${name}-entitlement-${toString idx}";
                value = {
                  inherit (entitlement) name;
                  application = config.resource.authentik_application.${name} "uuid";
                };
              })
              cfg.entitlements
          )
          (filterAttrs (_name: cfg: cfg.enable) config.authentik.applications)
        )
      );

      # --- Generate policy bindings for access control ---
      authentik_policy_binding = mkMerge [
        # Application access bindings
        (listToAttrs (
          flatten (
            mapAttrsToList (
              name: cfg:
                imap0 (idx: group: {
                  name = "app-${name}-${group}-${toString idx}";
                  value = {
                    target = config.resource.authentik_application.${name} "uuid";
                    group = config.resource.authentik_group.${group} "id";
                    order = idx;
                  };
                })
                cfg.accessGroups
            )
            (filterAttrs (_name: cfg: cfg.enable) config.authentik.applications)
          )
        ))

        # Entitlement policy bindings
        (
          listToAttrs (
            flatten (
              mapAttrsToList (
                name: cfg:
                  flatten (
                    imap0 (
                      entIdx: entitlement:
                        imap0 (grpIdx: group: {
                          name = "entitlement-${name}-${toString entIdx}-${group}-${toString grpIdx}";
                          value = {
                            target = config.resource.authentik_application_entitlement."${name}-entitlement-${toString entIdx}" "id";
                            group = config.resource.authentik_group.${group} "id";
                            order = grpIdx;
                          };
                        })
                        entitlement.groups
                    )
                    cfg.entitlements
                  )
              )
              (filterAttrs (_name: cfg: cfg.enable) config.authentik.applications)
            )
          )
        )

        # LDAP search access bindings
        (mapAttrs' (
            name: _cfg:
              nameValuePair
              "ldap-search-${name}" {
                target = config.resource.authentik_application.${name} "uuid";
                user = config.resource.authentik_user.ldap_search "id";
                order = 0;
              }
          ) (filterAttrs (
              _name: cfg:
                cfg.enable
                && (
                  cfg.ldap
                  != null
                  || (
                    cfg.oauth2 != null && cfg.oauth2.backchannelLdap != null
                  )
                )
            )
            config.authentik.applications))
      ];
    };

    # --- Configure outposts ---
    authentik.outposts = {
      ldap.providers =
        mapAttrsToList (
          name: _cfg: config.resource.authentik_provider_ldap."${name}-ldap" "id"
        ) (filterAttrs (_name: cfg: cfg.enable && cfg.ldap != null) config.authentik.applications)
        ++ mapAttrsToList (
          name: _cfg: config.resource.authentik_provider_ldap."${name}-backchannel" "id"
        ) (filterAttrs (
            _name: cfg:
              cfg.enable && cfg.oauth2 != null && cfg.oauth2.backchannelLdap != null
          )
          config.authentik.applications);

      proxy.providers = mapAttrsToList (
        name: _cfg: config.resource.authentik_provider_proxy."${name}-proxy" "id"
      ) (filterAttrs (_name: cfg: cfg.enable && cfg.proxy != null) config.authentik.applications);
    };

    # --- Property mappings for OAuth2 with entitlements ---
    data.authentik_property_mapping_provider_scope.with_entitlements = {
      managed_list = [
        "goauthentik.io/providers/oauth2/scope-openid"
        "goauthentik.io/providers/oauth2/scope-email"
        "goauthentik.io/providers/oauth2/scope-profile"
        "goauthentik.io/providers/oauth2/scope-entitlements"
      ];
    };
  };
}
