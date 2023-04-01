{
  description = "CryServ discord bot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    devenv.url = "github:cachix/devenv";
  };

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, devenv, ... }@inputs:
    let
      systems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f:
        builtins.listToAttrs (map (name: {
          inherit name;
          value = f name;
        }) systems);

      version = "${nixpkgs.lib.substring 0 8 self.lastModifiedDate}-${
          self.shortRev or "dirty"
        }";

      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        });
    in {
      overlays.cryserv = final: prev: {
        cryserv = final.callPackage ({ lib, beam, rebar3, beamPackages }:
          let
            packages = beam.packagesWith beam.interpreters.erlang;
            pname = "cryserv";
            src = self;
            mixEnv = "prod";

            mixDeps = import ./nix/mix.nix {
              inherit lib beamPackages;
              overrides = overrideDeps;
            };

            overrideDeps = (self: super: { });
          in packages.mixRelease {
            inherit pname version src mixEnv;

            mixNixDeps = mixDeps;

            CRYSERV_GIT_COMMIT = version;

            nativeBuildInputs = [ rebar3 ];
          }) { };
      };
      overlays.default = self.overlays.cryserv;

      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) cryserv;
        default = self.packages.${system}.cryserv;
      });

      legacyPackages = forAllSystems (system: nixpkgsFor.${system});

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              {
                packages = with pkgs;
                  [ mix2nix git gnumake gcc ]
                  ++ lib.optional pkgs.stdenv.isLinux pkgs.inotify-tools;
                languages.elixir.enable = true;

                enterShell = "";
                pre-commit.hooks.actionlint.enable = true;
                pre-commit.hooks.nixfmt.enable = true;
                pre-commit.hooks.mixfmt = {
                  enable = false; # Broken??
                  name = "Mix format";
                  entry = "${pkgs.elixir}/bin/mix format";
                  files = "\\.(ex|exs)$";

                  types = [ "text" ];
                  language = "system";
                  pass_filenames = false;
                };
                pre-commit.excludes = [ "nix/mix.nix" ];
              }
              {
                env.CRYSERV_IN_DEVENV = 1;
                env.CRYSERV_GIT_COMMIT = "devenv-version-dirty";
                #services.postgres.enable = true;
                #services.postgres.listen_addresses = "127.0.0.1";
                #services.postgres.initialDatabases =
                #  [{ name = "fleet_yards_dev"; }];
              }
              ({ config, ... }: {
                process.implementation = "hivemind";
                scripts.devenv-up.exec = ''
                  ${config.procfileScript}
                '';

              })
            ];
          };
        });

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixfmt);

      checks = forAllSystems (system: {
        devenv_ci = self.devShells.${system}.default.ci;
        #cryserv = self.packages.${system}.cryserv;
      });
    };

  nixConfig = {
    extra-substituters = [ "https://kloenk.cachix.org" ];
    extra-trusted-public-keys =
      [ "kloenk.cachix.org-1:k52XSkCLOxnmEnjzuedYOzf0MtQp8P3epqOmAlCHYpc=" ];
  };
}
