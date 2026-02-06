{ config, pkgs, lib, ... }:

{
  # Bootloader (systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Flakes / nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  # オーディオ（PipeWire）
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # COSMIC（Wayland）
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # 日本語入力（fcitx5 + mozc）
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      # Qtアプリを使うならどちらか（環境で名前が違うことあり）
      # kdePackages.fcitx5-qt
      # libsForQt5.fcitx5-qt
    ];
  };

  # フォント
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      jetbrains-mono
    ];
  };

  # sudo（wheelはNOPASSWD）
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # zshをログインシェルに
  programs.zsh.enable = true;

  users.users.takashi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # 便利ツールはOS側に置く派（最低限）
  environment.systemPackages = with pkgs; [
    wget
    git
    direnv
    nix-direnv
    vscode
    vivaldi
  ];

  # NixOSの互換性バージョン（インストール時に合わせる）
  system.stateVersion = "24.11";
}
