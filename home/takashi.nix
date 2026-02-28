{ config, pkgs, lib, ... }:

let
  obsidianWrapped = pkgs.symlinkJoin {
    name = "obsidian-wayland-wrapped";
    paths = [ pkgs.obsidian ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obsidian \
        --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations" \
        --add-flags "--ozone-platform=wayland"
    '';
  };
in
{
  home.username = "takashi";
  home.homeDirectory = "/home/takashi";

  home.packages = [
    obsidianWrapped
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    # 使い勝手系
    # defaultKeymap = "emacs"; # vim派なら "viins" など
    autocd = true;

    # aliasは必要最小限
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      gd = "git diff";
      gds = "git diff --staged";
      gc = "git commit";
      gco = "git checkout";
      gl = "git log --oneline --decorate --graph -n 30";
      nr-laptop = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
      nr-vm = "sudo nixos-rebuild switch --flake /etc/nixos#vm";
    };

    # zshrc末尾にそのまま入れる（最小・安全）
    initContent = ''
      # Starship
      eval "$(${pkgs.starship}/bin/starship init zsh)"

      # direnv
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

      # midnight-cat dircolors
      eval "$(dircolors -b ~/.config/midnight-cat/dircolors)"

      # fzf (home.packagesに入れてる前提、無ければ消してOK)
      if command -v fzf >/dev/null 2>&1; then
        source <(fzf --zsh)
      fi

      # nice-to-have
      setopt AUTO_PUSHD PUSHD_SILENT

      # Midnight Cat zsh syntax highlighting
      typeset -A ZSH_HIGHLIGHT_STYLES

      # コマンド（強すぎるなら少し落ち着かせる）
      ZSH_HIGHLIGHT_STYLES[command]='fg=#8bd5a0'
      ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8bd5a0'

      # auto-cdで打つディレクトリ名（= path系）をグレー寄りに
      ZSH_HIGHLIGHT_STYLES[path]='fg=#cdd3df'
      ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#cdd3df'
      ZSH_HIGHLIGHT_STYLES[path_approx]='fg=#cdd3df'
      ZSH_HIGHLIGHT_STYLES[precommand]='fg=#cdd3df'

      # 補助
      ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
      ZSH_HIGHLIGHT_STYLES[alias]='fg=#89b4fa'
      ZSH_HIGHLIGHT_STYLES[globbing]='fg=#74c7ec'
      ZSH_HIGHLIGHT_STYLES[comment]='fg=#7b8092'

      # 未存在コマンドの赤をパステルに
      ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/starship.toml".source = ../assets/starship.toml;
  home.file.".config/midnight-cat/dircolors".source = ../assets/dircolors;
  home.file.".gitconfig".source = ../assets/gitconfig;

  programs.git = {
    enable = true;
    settings.user = {
      name = "takashi";
      email = "3017297+takw45@users.noreply.github.com";
    };

    settings = {
      core.editor = "code --wait";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  # 壁紙設定
  home.file."Pictures/wallpaper.jpg".source = ../assets/wallpaper.jpg;

  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "x-scheme-handler/terminal" = "org.wezfurlong.wezterm.desktop";
      "application/x-terminal-emulator" = "org.wezfurlong.wezterm.desktop";
    };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Papirus-Dark";
    };
  };

  xdg.userDirs = {
    enable = true;
    documents = "Documents";
    music = "Music";
    pictures = "Pictures";
    videos = "Videos";
  };


  # home-manager の世代管理用
  home.stateVersion = "24.11";
}
