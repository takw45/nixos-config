{ config, pkgs, lib, inputs, ... }:
{
  # Bootloader (systemd-boot)
  boot = {
    plymouth = {
      enable = true;
      theme = "spinner";
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto" 
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
    loader.grub.devices = [ "/dev/nvme0n1p1" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.systemd.enable = true;
  };

  # Flakes / nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # タイムゾーン / ロケール（例：UI＋日本向け）
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # ネットワーク
  networking.networkmanager.enable = true;

  # NixOSの互換性バージョン（インストール時に合わせる）
  system.stateVersion = "26.04";
}
