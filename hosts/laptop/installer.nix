{ pkgs, ... }:

{
  services.xserver.enable = false;
  services.desktopManager.cosmic.enable = false;
  services.displayManager.sddm.enable = false;

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.openssh.enable = true;
}
