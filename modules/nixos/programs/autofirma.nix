{ inputs, ... }:

{
  imports = [ inputs.autofirma-nix.nixosModules.default ];

  programs.autofirma = {
    firefoxIntegration.enable = true;
  };
}
