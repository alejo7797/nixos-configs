{
  nixpkgs.overlays = [
    (_: prev: {
      steam = prev.steam.override {
        extraBwrapArgs = [
          "--bind $XDG_DATA_HOME/Steam/home $HOME"
          "--bind $XDG_DATA_HOME $HOME/.local/share"
        ];
      };
    })
  ];
}
