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

      # Port 25565 is the default.
      openFirewall = true;

      # Pass configuration secrets to the server instances.
      environmentFile = config.sops.secrets."minecraft".path;

      servers.patchouli-hq =

        let
          modpack = pkgs.fetchPackwizModpack {
            url = "https://git.patchoulihq.cc/alex/packwiz-modpacks/-/raw/1.0.0/patchouli-hq/pack.toml";
            packHash = "sha256-z5U8XVnYGnn33m/e7RHPrNqIumKtkf+YX50sw5pKgQY=";
          };
        in

        {
          enable = true;

          package = pkgs.quiltServers.quilt-1_21;
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
            "mods" = "${modpack}/mods";

            "ops.json".value = [
              {
                name = "alejo7797"; level = 4;
                uuid = "126ce880-58a3-4479-b246-14e4af6122ff";
                bypassesPlayerLimit = true;
              }
            ];
          };
        };

    };

    sops.secrets = {
      # File containing the RCON password.
      "minecraft" = { owner = "minecraft"; };
    };
  };
}
