{ config, ... }: {

  security.acme = {

    acceptTerms = true; # See https://letsencrypt.org/repository/.

    defaults = {
      email = "ewan@patchoulihq.cc"; dnsProvider = "cloudflare";
      environmentFile = config.sops.secrets."acme/cloudflare".path;
    };

  };
}
