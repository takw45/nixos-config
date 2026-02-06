{ config, pkgs, ... }:

{
  home.username = "takashi";
  home.homeDirectory = "/home/takashi";

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
      nr = "sudo nixos-rebuild switch --flake /etc/nixos#vm";
    };

    # zshrc末尾にそのまま入れる（最小・安全）
    initContent = ''
      # Starship
      eval "$(${pkgs.starship}/bin/starship init zsh)"

      # direnv
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

      # fzf (home.packagesに入れてる前提、無ければ消してOK)
      if command -v fzf >/dev/null 2>&1; then
        source <(fzf --zsh)
      fi

      # nice-to-have
      setopt AUTO_PUSHD PUSHD_SILENT
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      format = ''
        $directory$git_branch$git_status$nodejs$rust
        $character
      '';

      # --- Directory ---
      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      # --- Git (詳細) ---
      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = " [$symbol$branch]($style)";
      };

      git_status = {
        style = "yellow";
        format = " [$modified]($style)";
	modified = "*";
      };

      cmd_duration = {
        min_time = 500;
        format = " [$duration]($style)";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };

  # あると体験が上がるツール（必要なら）
  home.packages = with pkgs; [
    zoxide
    eza
    fzf
    bat
  ];

  programs.zoxide.enable = true;

  # eza/batを使う小ワザ（好み）
  programs.zsh.shellAliases = {
    ls = "eza";
    cat = "bat";
    cd = "z";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "takashi";
      email = "takw45@gmail.com";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # CapsLock -> Ctrl（※入れ替えなら ctrl:swapcaps）
  home.keyboard = {
    layout = "us";
    options = [ "ctrl:nocaps" ];
    # options = [ "ctrl:swapcaps" ];
  };

  # home-manager の世代管理用
  home.stateVersion = "24.11";
}
