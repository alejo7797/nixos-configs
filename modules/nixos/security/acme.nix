{ config, ... }: {

  security.acme = {

    acceptTerms = true; # https://letsencrypt.org/repository/.

    defaults = {
      email = "ewan@patchoulihq.cc"; dnsProvider = "desec";
      environmentFile = config.sops.secrets."acme/desec".path;
      server = "https://api.test4.buypass.no/acme/directory";
    };

  };
}
