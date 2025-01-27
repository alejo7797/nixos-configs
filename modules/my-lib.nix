{
  lib,
  ...
}:

with lib.fileset;

{
  options.myLib = lib.mkOption {
    description = "Internal configuration utilities.";
    type = with lib.types; attrsOf anything;
  };

  config.myLib = {

    loadModules = path:
      # Load only files which are genuine modules.
      fileFilter (file: file.hasExt "nix")

      # Exclude the file where we call loadModules from.
      (difference path [ /${path}/default.nix ]);
  };
}
