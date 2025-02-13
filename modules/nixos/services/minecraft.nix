{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.minecraft;
in

{
  options.myNixOS.minecraft.enable = lib.mkEnableOption "my personal Minecraft server";

  config = lib.mkIf cfg.enable {

    services.minecraft-servers = {
      enable = true;

      # Remember: this is the Mojang EULA you agree to.
      # https://account.mojang.com/documents/minecraft_eula
      eula = true;

      openFirewall = true;

      environmentFile = config.sops.secrets."minecraft".path;

      servers.default = {
        enable = true;

        package = pkgs.fabricServers.fabric-1_21_1;
        jvmOpts = "-Xms1024M -Xmx4096M";

        serverProperties = {
          difficulty = "normal";
          motd = "hello all";

          enable-rcon = true;
          white-list = true;

          # Smart secrets management.
          "rcon.password" = "@rconpwd@";
        };

        symlinks = {

        };

        files = {

        };

      };
    };

    sops.secrets = {
      # File containing the RCON password.
      "minecraft" = { owner = "minecraft"; };
    };
  };
}
