{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos-vm";

  # -----------------------------
  # VirtualBox Guest Additions
  # -----------------------------
  virtualisation.virtualbox.guest.enable = true;

  # VirtualBox用のビデオドライバ
  services.xserver.videoDrivers = [ "virtualbox" ];

  # 画面解像度まわりの相性改善
  services.displayManager.gdm.autoSuspend = false;

  # VMでは電源管理は不要（実機専用）
  services.power-profiles-daemon.enable = false;

  # VMはBluetooth不要
  hardware.bluetooth.enable = false;

  # VMではfirmware不要
  hardware.enableRedistributableFirmware = lib.mkForce false;
}
