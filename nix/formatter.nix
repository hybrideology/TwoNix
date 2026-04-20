{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true;
        prettier.enable = true;
        statix.enable = true;
      };

      settings = {
        global.excludes = [
          "LICENSE"
          "test/*"
          # unsupported extensions
          # "*.{gif,png,svg,tape,mts,lock,mod,sum,toml,env,envrc,gitignore,pages}"
        ];

        formatter = {
          statix.priority = 1;

          alejandra.priority = 2;

          prettier = {
            options = [
              "--tab-width"
              "4"
            ];
            includes = ["*.{css,html,js,json,jsx,md,mdx,scss,ts,yaml}"];
          };
        };
      };
    };

    checks.deadnix =
      pkgs.runCommandLocal "deadnix" {
        nativeBuildInputs = [pkgs.deadnix];
      } ''
        deadnix --fail ${inputs.self}/nix
        touch $out
      '';

    devShells.default = pkgs.mkShell {
      packages = [config.treefmt.build.wrapper pkgs.deadnix];
    };
  };
}
