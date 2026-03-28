{ config, pkgs, lib, ... }:

{
  # ノート実機はファームウェアが効く（Wi-Fi/Bluetoothなど）
  hardware.enableRedistributableFirmware = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # 電源管理
  services.power-profiles-daemon.enable = true;

  systemd.services.battery-limit = {
    description = "Battery Charge Limit";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo 80 > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo 95 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
  };

  services.logind.settings.Login = {
    HandleLidSwitch="suspend";
    HandleLidSwitchDocked="ignore";
    HandleLidSwitchExternalPower="ignore";
    KillUserProcesses = false;
  };

  # 例：タッチパッドなど追加で調整したくなったらここに置く
  services.libinput.enable = true;

  # 例：AMD GPU向けは通常自動。必要になったらここに追加。
  # services.xserver.videoDrivers = [ "amdgpu" ];

  # ホスト名
  networking.hostName = "jormungandr";

  # resume設定
  swapDevices = [
    { device = "/dev/nvme0n1p2"; }
  ];

  boot.resumeDevice = "/dev/nvme0n1p2";

}
