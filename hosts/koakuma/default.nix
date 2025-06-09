{ self, ... }: {

  system.stateVersion = "25.05";

  imports = [
    self.nixosModules.users.ewan ./hardware.nix
  ];

  swapDevices = [{
    device = "/var/swapfile";
    size = 2047; # 2GiB.
  }];

  networking = {
    # Personal playground.
    domain = "patchoulihq.cc";
    hostName = "koakuma";

    firewall.allowedTCPPorts = [ 22 ];
  };

  home-manager = {
    users.ewan = import ./home.nix;
  };

}
