{ config, pkgs, lib, ... }:

{
  # ノート実機はファームウェアが効く（Wi-Fi/Bluetoothなど）
  hardware.enableRedistributableFirmware = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # WiFi
  networking.wireless.enable = true;

  # 電源管理
  services.power-profiles-daemon.enable = true;

  # 例：タッチパッドなど追加で調整したくなったらここに置く
  services.libinput.enable = true;

  # 例：AMD GPU向けは通常自動。必要になったらここに追加。
  # services.xserver.videoDrivers = [ "amdgpu" ];

  # ホスト名
  networking.hostName = "jormungandr";
}
