{ config, pkgs, lib, inputs, ... }:
{
  # Bootloader (systemd-boot)
  boot = {
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
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
  };

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
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # COSMIC（Wayland）
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
  ];

  services.udev.extraHwdb = ''
    evdev:input:*
      KEYBOARD_KEY_3a=leftctrl
  '';

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
      hackgen-nf-font
    ];
  };
  fonts.fontconfig.enable = true;

  # sudo（wheelはNOPASSWD）
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # zshをログインシェルに
  programs.zsh.enable = true;

  users.users.takashi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "adbusers"
      "libvirtd"
      "kvm"
    ];
    shell = pkgs.zsh;
  };

  programs.dconf.enable = true;
  services.dbus.enable = true;

  # Wayland / COSMIC 重要
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Game(Steam)
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [  
    wget
    git
    gh
    direnv
    nix-direnv
    
    #ターミナル
    wezterm
        
    #ファイルマネージャ
    nemo-with-extensions
    #アイコンテーマ
    papirus-icon-theme
    fluent-icon-theme
    

    # setting tools
    glib
    gsettings-desktop-schemas
    
    #ブラウザ
    vivaldi

    #開発環境    
    android-studio
    android-tools
    vscode

    # Games
    mangohud
    gamescope
    protonup-qt
    vulkan-tools
  ];

  nixpkgs.config = {
    android_sdk.accept_license = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    # QEMU/KVMの最適化（ほぼ必須）
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
    };
  };

  programs.virt-manager.enable = true;

  # NixOSの互換性バージョン（インストール時に合わせる）
  system.stateVersion = "25.11";
}
