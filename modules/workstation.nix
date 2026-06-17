{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = false;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
  ];

  services.udev.extraHwdb = ''
    evdev:input:*
      KEYBOARD_KEY_3a=leftctrl
  '';

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

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

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

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
    initialPassword = "passwd";
  };

  programs.dconf.enable = true;
  services.dbus.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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

    wezterm

    nemo-with-extensions
    papirus-icon-theme
    fluent-icon-theme

    glib
    gsettings-desktop-schemas

    vivaldi

    android-studio
    android-tools
    vscode

    mangohud
    gamescope
    protonup-qt
    vulkan-tools
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
    };
  };

  programs.virt-manager.enable = true;
}