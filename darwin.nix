# darwin.nix

{ pkgs, ... }:

{
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages =
    [ pkgs.vim ];

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    # services.karabiner-elements.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    # programs.zsh.enable = true;  # default shell on catalina
    # programs.fish.enable = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # Enable Touch ID for sudo
    security.pam.enableSudoTouchIdAuth = true;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";

    services.yabai = {
        enable = true;
        package = pkgs.yabai;
        enableScriptingAddition = true;
        config = {
                mouse_follows_focus = "off";
                focus_follows_mouse = "off";
                window_origin_display = "default";
                window_placement = "second_child";
                window_shadow = "off";
                window_opacity = "off";
                window_opacity_duration = 0.0;
                active_window_opacity = 1.0;
                normal_window_opacity = 0.90;
                insert_feedback_color = "0xFFCCA37E";
                split_ratio = 0.50;
                split_type = "auto";
                auto_balance = "off";
                mouse_modifier = "ctrl";
                mouse_action1 = "move";
                mouse_action2 = "resize";
                mouse_drop_action = "stack";
                window_animation_duration = 0.0;
                window_animation_frame_rate = 120;

                layout = "bsp";
                top_padding = 5;
                bottom_padding = 5;
                left_padding = 5;
                right_padding = 5;
                window_gap = 5;
        };
        extraConfig = ''
            yabai -m rule --add app="^Disk Utility$" manage=off
            yabai -m rule --add app="^Flux$" manage=off
            yabai -m rule --add app="^Raycast$" manage=off
            yabai -m rule --add app="^Discord*" space=last
            yabai -m rule --add app="^Emacs$" manage=on
            yabai -m rule --add app="^Steam$" manage=off
            yabai -m rule --add app="^Finda$" manage=off
        '';
    };

    services.skhd = {
        enable = true;
        package = pkgs.skhd;
    };

    users.users.shreeram = {
        name = "shreeram";
        home = "/Users/shreeram";
    };
}
