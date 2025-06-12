{ config, ... }: {

  security.acme = {

    acceptTerms = true; # https://letsencrypt.org/repository/.

    defaults = {
      email = "ewan@patchoulihq.cc"; dnsProvider = "desec";
      environmentFile = config.sops.secrets.desec-token.path;
      server = "https://api.test4.buypass.no/acme/directory";
    };

  };
}
