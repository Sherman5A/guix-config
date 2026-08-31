(use-modules (guix gexp)
             (gnu home)
             (gnu home services)
             (gnu home services gnupg)
             (gnu home services shells)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages admin)
             (gnu packages fonts)
             (gnu packages gnome-xyz)
             (gnu packages xdisorg)
             (gnu packages xorg)
             (gnu packages qt)
             (gnu packages xfce)
             (gnu packages commencement)
             (gnu packages guile)
             (gnu packages messaging)
             (gnu packages password-utils)
             (gnu packages librewolf)
             (gnu packages chromium)
             (gnu packages image-viewers)
             (gnu packages ncdu)
             (gnu packages rust-apps)
             (gnu packages wm)
             (gnu packages hunspell)
             (gnu packages enchant)
             (gnu packages tree-sitter)
             (gnu packages gnupg)
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
                  pinentry
                  tree-sitter
                  hexchat
                  keepassxc
                  labwc-menu-generator
                  librewolf
                  ungoogled-chromium
                  thunar
                  tumbler
                  imv
                  uv
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
                  gcc-toolchain
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
                                 `(("QT_QPA_PLATFORMTHEME" . "qt5ct")
                                   ("QT_PLUGIN_PATH" . "$HOME/.guix-home/profile/lib/qt5/plugins")))
                 (service home-gpg-agent-service-type
                          (home-gpg-agent-configuration (pinentry-program (file-append
                                                                           pinentry
                                                                           "/bin/pinentry-gtk-2"))
                                                        (ssh-support? #t)
                                                        (extra-content
                                                         "
allow-emacs-pinentry
allow-loopback-pinentry
"))))
           %base-home-services)))

