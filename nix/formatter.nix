{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true;
        prettier.enable = true;
        statix.enable = true;
        deadnix.enable = true;
      };

      settings = {
        global.excludes = [
          "LICENSE"
          "test/*"
        ];

        formatter = {
          statix.priority = 1;
          deadnix.priority = 2;
          alejandra.priority = 3;
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
  };
}
