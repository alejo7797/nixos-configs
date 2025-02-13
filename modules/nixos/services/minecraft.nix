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

          "ops.json".value = [
            {
              uuid = "126ce880-58a3-4479-b246-14e4af6122ff";
              name = "alejo7797";
              level = 4;
              bypassesPlayerLimit = true;
            }
          ];

          "mods/appleskin-fabric.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/b5ZiCjAr/appleskin-fabric-mc1.21-3.0.6.jar";
            sha256 = "sha256:18papz1qpjvg9fd91bf5iqvxg1fbdn9fc21a744cf6sb570ww6cs";
          };

          "mods/fabric-api.jar" = builtins.fetchurl {
            name = "fabric-api.jar";
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/9YVrKY0Z/fabric-api-0.115.0%2B1.21.1.jar";
            sha256 = "sha256:0xv0q7lq54q9z77hgnd6989gfl8m4qjpx9zy0vpxlwy1af96awd9";
          };

          "mods/modernfix-fabric.jar" = builtins.fetchurl {
            name = "modernfix-fabric.jar";
            url = "https://cdn.modrinth.com/data/nmDcB62a/versions/tn4FFqcg/modernfix-fabric-5.20.2%2Bmc1.21.1.jar";
            sha256 = "sha256:0g4p4w0hrhvj1qfwfgmzq51347mq0c18adfp3qk007z113gnv9m1";
          };

          "mods/jade-fabric.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/1Ucj3FzM/Jade-1.21.1-Fabric-15.8.3.jar";
            sha256 = "sha256:149nwvswfjs4qww0wq0890dmkfd23di4mhy5n6kg802fn24iaxwr";
          };

          "mods/lithium-fabric.jar" = builtins.fetchurl {
            name = "lithium-fabric.jar";
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/NHA11tBg/lithium-fabric-0.14.7%2Bmc1.21.1.jar";
            sha256 = "sha256:0na3h6z25dsy8nfrfhwbmr5k838s7dakdhya6wn3ldlbvhhd9idn";
          };

          "mods/ferritecore-fabric.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/bwKMSBhn/ferritecore-7.0.2-hotfix-fabric.jar";
            sha256 = "sha256:1ym402bqi4p3cz0bpbplk3zf0324s2prxc4v9zlkajj747iyiyp3";
          };

          "mods/journeymap-fabric.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/VgrCCuhR/journeymap-fabric-1.21.1-6.0.0-beta.37.jar";
            sha256 = "sha256:0lmkyvvz5m7dxj2amdbir2wvdwyqihx4blaw3f9qxqjjg5dvg5sz";
          };

          "mods/jei-fabric.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/Ni0ejaDO/jei-1.21.1-fabric-19.21.0.247.jar";
            sha256 = "sha256:0afxyqljk07589p17sqc3cbwd22v8sa8m0kij27lvvwig26x0qsr";
          };

        };
      };
    };

    sops.secrets = {
      # File containing the RCON password.
      "minecraft" = { owner = "minecraft"; };
    };
  };
}
