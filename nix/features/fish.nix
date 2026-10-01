{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.fish = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      plugins = [
        pkgs.fishPlugins.hydro
      ];
      configFile.content = ''
        function y
        	set tmp (mktemp -t "yazi-cwd.XXXXXX")
        	command ${lib.getExe self'.packages.yazi} $argv --cwd-file="$tmp"
        	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        		builtin cd -- "$cwd"
        	end
        	command rm -f -- "$tmp"
        end;
      '';
    };
  };
}
