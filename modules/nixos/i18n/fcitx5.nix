{ pkgs, ... }: {

  i18n.inputMethod = {

    type = "fcitx5";

    fcitx5 = {
      plasma6Support = true;
      addons = with pkgs; [
        fcitx5-mozc-ut
        fcitx5-rime
      ];
    };

  };
}
