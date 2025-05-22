# home.nix

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.neovim
    pkgs.emacs
    pkgs.stow
    pkgs.pass
    pkgs.kitty
    pkgs.nnn
    pkgs.lua5_1

    pkgs.isync
    pkgs.msmtp
    pkgs.neomutt
    pkgs.notmuch
    pkgs.urlscan
    pkgs.w3m

    pkgs.luarocks
    pkgs.ripgrep
    pkgs.khard
    pkgs.eza
    pkgs.tree
    pkgs.ripgrep

    pkgs.yazi

    pkgs.buku

    pkgs.texliveFull

    pkgs.nixfmt-rfc-style

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less -r";
    MANPAGER = "nvim +Man!";
    KEYID = "0x994DB28C8F367B2F";
    ZK_NOTEBOOK_DIR = "/Users/shreeram/Documents/notes";
  };

  home.shellAliases = {
    b = "buku --suggest";
    e = "eza";
    ea = "eza --all";
    el = "eza --long --header --git --icons --classify --all";
    et = "eza --tree --level=2 --long --header --git --icons --classify --all";
    lg = "lazygit";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    autocd = true;

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"

      FPATH="$(brew --prefix)/share/zsh/site-functions:''${FPATH}"
    '';

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
    '';

    completionInit = ''
      autoload -Uz compinit && compinit -C

      zstyle ':completion:*' rehash true
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a1 --color=always $realpath'
      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'
      # preview nvim
      zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'cat $realpath'
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'
    '';

    initExtra = ''
      autoload edit-command-line; zle -N edit-command-line
      bindkey -e
      bindkey '^e' edit-command-line

      export NNN_FIFO=/tmp/nnn.fifo
      export NNN_OPTS="egxAH"
      export NNN_TRASH=1
      export NNN_PLUG='p:preview-tui;c:cbcpy'

      n () {
          # Block nesting of nnn in subshells
          [ "$NNNLVL" -eq 0 ] || {
              echo "nnn is already running"
              return
          }

          # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
          # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
          # see. To cd on quit only on ^G, remove the "export" and make sure not to
          # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
          #      NNN_TMPFILE="$HOME/.config/nnn/.lastd"
          export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

          # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
          # stty start undef
          # stty stop undef
          # stty lwrap undef
          # stty lnext undef

          # The command builtin allows one to alias nnn to n, if desired, without
          # making an infinitely recursive alias
          command nnn "$@"

          [ ! -f "$NNN_TMPFILE" ] || {
              . "$NNN_TMPFILE"
              rm -f "$NNN_TMPFILE" > /dev/null
          }
        }

      function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
              builtin cd -- "$cwd"
          fi
          rm -f -- "$tmp"
      }
    '';

    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "061jjpgghn8d5q2m2cd2qdjwbz38qrcarldj16xvxbid4c137zs2";
        };
        file = "fzf-tab.plugin.zsh";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.git = {
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = false;
      };
    };
    enable = true;
    ignores = [ ".DS_Store" ];
    userName = "Shreeram Modi";
    userEmail = "smodi@smodi.net";
    signing.key = "0x994DB28C8F367B2F";
    extraConfig = {
      credential = {
        helper = "store";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "D104506D47E7579BF01E3205994DB28C8F367B2F";
      default-new-key-algo = "ed25519/cert";
    };
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

}
