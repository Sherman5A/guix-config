(use-modules (guix gexp)
             (gnu home)
             (gnu home services)
             (gnu home services gnupg)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services sound)
             (gnu home services desktop)
             (gnu packages package-management)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages admin)
             (gnu packages fonts)
             (gnu packages gnome-xyz)
             (gnu packages xdisorg)
             (gnu packages xorg)
             (gnu packages qt)
             (gnu packages pdf)
             (gnu packages xfce)
             (gnu packages commencement)
             (gnu packages guile)
             (gnu packages messaging)
             (gnu packages password-utils)
             (gnu packages librewolf)
             (gnu packages chromium)
             (gnu packages image-viewers)
             (gnu packages video)
             (gnu packages ncdu)
             (gnu packages rust-apps)
             (gnu packages wm)
             (gnu packages freedesktop)
             (gnu packages hunspell)
             (gnu packages enchant)
             (gnu packages tree-sitter)
             (gnu packages gnupg)
             (nongnu packages game-client)
             (nongnu packages mozilla)
             (xyz jackfaller discord)
             (holo gtk)
             (holo wm))

(home-environment
  (packages (list emacs-pgtk
                  emacs-vterm
                  emacs-markdown-mode
                  emacs-meow
                  emacs-avy
                  emacs-guix
                  emacs-ef-themes
                  emacs-treemacs
                  emacs-geiser
                  emacs-geiser-guile
                  emacs-smartparens
                  emacs-magit
                  emacs-forge
                  emacs-vertico
                  emacs-marginalia
                  emacs-embark
                  emacs-consult
                  emacs-orderless
                  emacs-corfu
                  emacs-cape
                  emacs-helpful
                  emacs-jinx
                  emacs-pinentry
                  stow
                  steam
                  discord
                  firefox
                  pinentry
                  tree-sitter
                  keepassxc
                  labwc-menu-generator
                  ungoogled-chromium
                  xfconf
                  xfce4-settings
                  exo
                  xdg-utils
                  thunar
                  tumbler
                  ffmpegthumbnailer
                  poppler
                  imv
                  mpv
                  wlr-randr
                  font-iosevka
                  font-terminus
                  font-google-noto
                  font-google-noto-sans-cjk
                  font-openmoji
                  papirus-icon-theme
                  arc-theme
                  qt5ct
                  raleigh-theme
                  raleigh-olive-theme
                  hackneyed-x11-cursors
                  font-adobe-source-code-pro
                  gammastep
                  htop
                  enchant
                  hunspell
                  hunspell-dict-en-gb))
  (services
   (append (list (service home-bash-service-type
                          (home-bash-configuration
                           ;; Set false as using guix system
                           (guix-defaults? #f)
                           (variables `(("PS1" . "\\[\\e]0;\\w${GUIX_ENVIRONMENT:+ [env]} - ${TERM} \\l\\a\\]\\u@\\h \\w${GUIX_ENVIRONMENT:+ [env]}\\$ ")))
                           (aliases '(("grep" . "grep --color=auto")
                                      ("ip" . "ip -color=auto")
                                      ("ll" . "ls -l")
                                      ("ls" . "ls -p --color=auto")))))
                 (simple-service 'env-vars-service
                                 home-environment-variables-service-type
                                 `(("GUIX_SANDBOX_EXTRA_SHARES" . "$HOME/mnt/local/hdd")
                                   ("QT_QPA_PLATFORMTHEME" . "qt5ct")
                                   ("QT_PLUGIN_PATH" . "$HOME/.guix-home/profile/lib/qt5/plugins")))
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 (service home-openssh-service-type
                          (home-openssh-configuration (authorized-keys (list (local-file
                                                                              "/home/jake/.ssh/laptop.pub")))))
                 (service home-ssh-agent-service-type)
                 (service home-gpg-agent-service-type
                          (home-gpg-agent-configuration (pinentry-program (file-append
                                                                           pinentry
                                                                           "/bin/pinentry-gtk-2"))
                                                        (extra-content
                                                         "
allow-emacs-pinentry
allow-loopback-pinentry
"))))
           %base-home-services)))

