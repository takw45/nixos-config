{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos-vm";

  # VirtualBox用のビデオドライバ
  services.xserver.videoDrivers = [ "virtualbox" ];

  # VMでは電源管理は不要（実機専用）
  services.power-profiles-daemon.enable = false;

  # VMはBluetooth不要
  hardware.bluetooth.enable = false;

  # VMではfirmware不要
  hardware.enableRedistributableFirmware = lib.mkForce false;
}
