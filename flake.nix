{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-root.url = "github:srid/flake-root";

    terranix = {
      url = "github:typedrat/terranix/expose-config";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({self, ...}: {
      imports = [
        inputs.devshell.flakeModule
        inputs.flake-root.flakeModule
        inputs.terranix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = import inputs.systems;

      perSystem = {
        config,
        system,
        pkgs,
        ...
      }: let
        terranixOptions = inputs.terranix.lib.terranixOptions {
          inherit system;
          moduleRootPath = toString ./.;
          urlPrefix = "https://github.com/synapdeck/terranix-authentik/tree/main/module";
          modules = [self.terranixModules.authentik];
        };
      in {
        packages = {
          options = terranixOptions;
        };

        apps.options = let
          mustacheTemplate = pkgs.writeText "template.mustache" ''
            # `authentik` module options

            <ul>
            {{#options}}
            <li>
              <b><u><code>{{label}}</code></u></b><br>
              <b>type</b>: <code>{{type}}</code><br>
              <b>default</b>: <pre>{{default}}</pre><br>
              <b>example</b>: <pre>{{example}}</pre><br>
              <b>defined</b>: <a href="{{url}}">{{defined}}</a><br>
              <b>description</b>: {{description}}<br>
            </li>
            {{/options}}
            </ul>
          '';
        in {
          type = "app";
          program = toString (pkgs.writers.writeBash "options" ''
                cat ${terranixOptions} | ${pkgs.jq}/bin/jq 'def removeKeys(s):
                  with_entries(if (.key | startswith(s)) then empty else
                    if (.value | type == "object") then .value |= removeKeys(s) else . end end);
                  removeKeys("_") |
                  to_entries | .[] |
                  {
                    label: .key,
                    type: .value.type,
                    description: .value.description,
                    example: (if .value.example | has("text") then .value.example.text else .value.example end),
                    default: (if .value.default | has("text") then .value.default.text else .value.default end),
                    defined: .value.declarations[0].path,
                    url: .value.declarations[0].url,
                  }' | ${pkgs.jq}/bin/jq -s '{ options: . }' \
                  | ${pkgs.mustache-go}/bin/mustache ${mustacheTemplate} \
                  > options.md
                cat ${terranixOptions} | ${pkgs.jq}/bin/jq 'def removeKeys(s):
                  with_entries(if (.key | startswith(s)) then empty else
                    if (.value | type == "object") then .value |= removeKeys(s) else . end end);
                  removeKeys("_")' > options.json
          '');
        };
        treefmt.config = {
          inherit (config.flake-root) projectRootFile;
          package = pkgs.treefmt;

          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };

          settings.formatter."create-options" = {
            command = config.apps.options.program;
            includes = ["*.nix"];
          };
        };

        formatter = config.treefmt.build.wrapper;
        checks.formatting = config.treefmt.build.check self;

        devshells.default = {
          commands = [
            {
              name = "treefmt";
              category = "development";
              package = config.treefmt.build.wrapper;
            }
          ];

          devshell = {
            packages = with pkgs; [
              nodejs
              nixd
            ];
          };
        };
      };

      flake = {
        terranixModules.authentik.imports = [./module];
      };
    });
}
