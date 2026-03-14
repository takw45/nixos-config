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

  # 環境変数
  home.sessionVariables = {
    LSCOLORS = "exfxcxdxbxegedabagacad";
    EDITOR = "code";
    FZF_DEFAULT_OPTS = "--reverse --no-sort --no-hscroll --preview-window=down";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # 使い勝手系
    # defaultKeymap = "emacs"; # vim派なら "viins" など
    autocd = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = false;
   };


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

    setOptions = [
      "AUTO_CD"
      "SHARE_HISTORY"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_REDUCE_BLANKS"
      "PRINT_EIGHT_BIT"
      "NO_FLOW_CONTROL"
    ];

    # zshrc末尾にそのまま入れる（最小・安全）
    initContent = ''
      # bindkey
      bindkey -e
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word

      # Sheldon
      eval "$(${pkgs.sheldon}/bin/sheldon source)"

      # fzf history
      function fzf-select-history() {
        BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
        CURSOR=$#BUFFER
        zle reset-prompt
      }
      zle -N fzf-select-history
      bindkey '^r' fzf-select-history

      # cdr
      if [[ -n $(echo ''${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ''${^fpath}/cdr(N)) ]]; then
          autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
          add-zsh-hook chpwd chpwd_recent_dirs
          zstyle ':completion:*' recent-dirs-insert both
          zstyle ':chpwd:*' recent-dirs-default true
          zstyle ':chpwd:*' recent-dirs-max 1000
      fi

      # fzf cdr
      function fzf-cdr() {
          local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf)
          if [ -n "$selected_dir" ]; then
              BUFFER="cd ''${selected_dir}"
              zle accept-line
          fi
          zle clear-screen
      }
      zle -N fzf-cdr
      bindkey '^q' fzf-cdr

      # git branch selector
      user_name=$(git config user.name)
      fmt="\
      %(if:equals=$user_name)%(authorname)%(then)%(color:default)%(else)%(color:brightred)%(end)%(refname:short)|\
      %(committerdate:relative)|\
      %(subject)"

      function select-git-branch-friendly() {
        selected_branch=$(
          git branch --sort=-committerdate --format=$fmt --color=always \
          | column -ts'|' \
          | fzf --ansi --exact --preview='git log --oneline --graph --decorate --color=always -50 {+1}' \
          | awk '{print $1}'
        )
        BUFFER="''${LBUFFER}''${selected_branch}''${RBUFFER}"
        CURSOR=$((''${#LBUFFER} + ''${#selected_branch}))
        zle redisplay
      }
      zle -N select-git-branch-friendly
      bindkey '^b' select-git-branch-friendly
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/starship.toml".source = ../assets/starship.toml;
  home.file.".config/midnight-cat/dircolors".source = ../assets/dircolors;
  home.file.".gitconfig".source = ../assets/gitconfig;
  home.file.".config/wezterm/wezterm.lua".source = ../assets/wezterm.lua;

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
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
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
  home.stateVersion = "25.11";

  # Claude Code用の設定ディレクトリだけ先に作っておく
  home.file.".claude/.keep".text = "";

}
