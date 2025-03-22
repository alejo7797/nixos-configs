{ pkgs, ... }: {

  programs.zsh.my.powerlevel10k = {

    p10k-zsh = pkgs.runCommand "p10k-zsh"
      {
        powerlevel10k = pkgs.zsh-powerlevel10k;
        my_patch = ./p10k.patch;
      }
      ''
        patch "$powerlevel10k/share/zsh-powerlevel10k/config/p10k-lean-8colors.zsh" "$my_patch" -o "$out"
      '';

  };
}
