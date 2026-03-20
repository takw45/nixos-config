{ config, pkgs, lib, ... }:
{
  home.username = "takashi";
  home.homeDirectory = "/home/takashi";

  home.packages = with pkgs; [
    obsidian
    zellij
    neovim
    yazi
    ripgrep
    fd
    fzf
    bat
    eza
    zoxide
    lazygit
    lazydocker
    lazysql
    btop
    jq
    tree
    wl-clipboard
    xclip
    docker-client
    docker-compose
    gitui
    delta
  ];

  # 環境変数
  home.sessionVariables = {
    LSCOLORS = "exfxcxdxbxegedabagacad";
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
    TERMINAL = "wezterm";
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
      y = "yazi";
      lg = "lazygit";
      ld = "lazydocker";
      lsql = "lazysql";
      ide = "zellij --layout terminal-ide";
      devlogs = "docker compose logs -f --tail=100";
      dcu = "docker compose up -d";
      dcd = "docker compose down";
      dps = "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";
      dbui = "lazysql";
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

      # bat theme fallback
      export BAT_THEME="TwoDark"

      # yazi cwd sync helper
      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.eza.enable = true;

  home.file.".gitconfig".source = ../assets/gitconfig;
  xdg.configFile."starship.toml".source = ../assets/starship.toml;
  xdg.configFile."midnight-cat/dircolors".source = ../assets/midnight-cat/dircolors;
  xdg.configFile."wezterm/wezterm.lua".source = ../assets/wezterm/wezterm.lua;
  xdg.configFile."zellij/config.kdl".source = ../assets/zellij/config.kdl;
  xdg.configFile."zellij/layouts/terminal-ide.kdl".source = ../assets/zellij/layouts/terminal-ide.kdl;
  xdg.configFile."yazi/yazi.toml".source = ../assets/yazi/yazi.toml;
  xdg.configFile."yazi/keymap.toml".source = ../assets/yazi/keymap.toml;

  programs.git = {
    enable = true;
    settings.user = {
      name = "takashi";
      email = "3017297+takw45@users.noreply.github.com";
    };

    settings = {
      core.editor = "nvim";
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
