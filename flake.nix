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

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
        inputs.git-hooks-nix.flakeModule
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
              <b><u>{{label}}</u></b><br>
              <b>type</b>: {{type}}<br>
              <b>default</b>: {{default}}<br>
              <b>example</b>: {{example}}<br>
              <b>defined</b>: <a href="{{url}}">{{defined}}</a><br>
              <b>description</b>: {{description}}<br>
            </li>
            {{/options}}
            </ul>
          '';
        in {
          type = "app";
          program = toString (pkgs.writers.writeBash "options" ''
            cat ${terranixOptions} | ${pkgs.jq}/bin/jq 'to_entries | .[] | select(.key | startswith("_module") | not) |
              {
                label: .key,
                type: .value.type,
                description: .value.description,
                example: .value.example | tojson,
                default: .value.default | tojson,
                defined: .value.declarations[0].path,
                url: .value.declarations[0].url,
              }' | ${pkgs.jq}/bin/jq -s '{ options: . }' \
              | ${pkgs.mustache-go}/bin/mustache ${mustacheTemplate} \
              > options.md
            cat ${terranixOptions} | ${pkgs.jq}/bin/jq 'with_entries(select(.key | startswith("_module") | not))' \
              > options.json
          '');
        };

        pre-commit = {
          settings.hooks = {
            treefmt.enable = true;
          };
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
            startup.pre-commit.text = config.pre-commit.installationScript;
          };
        };
      };

      flake = {
        terranixModules.authentik = import ./module;
        terranixModule.imports = [self.terranixModules.authentik];
      };
    });
}
