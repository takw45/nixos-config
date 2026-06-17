{ pkgs, ... }:

{
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
