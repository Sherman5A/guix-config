(use-modules (guix gexp)
	     (guix channels)
             (gnu home)
             (gnu home services)
	     (gnu home services guix)
             (gnu home services gnupg)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services sound)
             (gnu home services desktop)
             (gnu packages)
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
             (gnu packages bittorrent)
             (gnu packages commencement)
             (gnu packages compression)
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
             (gnu packages wine)
             (gnu packages gnupg)
             (nongnu packages mozilla)
             (nongnu packages compression)
             (xyz jackfaller discord)
             (holo nongnu packages game-client)
             (holo packages gtk)
             (holo packages wm))

(home-environment
 (packages (list emacs-pgtk
  	    	 emacs-paredit
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
                 emacs-apheleia
		 emacs-plantuml-mode
                 ;; config
                 stow
                 ;; desktop env
                 xdg-desktop-portal
                 xdg-desktop-portal-gtk
                 xdg-desktop-portal-wlr
                 xdg-utils
                 xdg-user-dirs
                 labwc-menu-generator
                 xfconf
                 xfce4-settings
                 xfce4-notifyd
                 libei
                 exo
                 wlr-randr
                 gammastep
                 mako
                 ;; applications
                 pinentry
                 keepassxc
                 htop
                 tree-sitter
                 discord
                 wine64
                 ;; compression
                 xarchiver
                 unzip
                 unrar
                 7zip
                 ;; file explorer
                 thunar
                 thunar-volman
                 tumbler
                 ffmpegthumbnailer
                 ;; games
                 steam
                 heroic
                 ;; browsers
                 firefox
                 ;; media
                 (specification->package "gallery-dl@1.32.10")
                 imv
                 mpv
                 poppler
                 qbittorrent
                 ;; font
                 font-iosevka
                 font-terminus
                 font-google-noto
                 font-google-noto-sans-cjk
                 font-openmoji
                 font-adobe-source-code-pro
                 ;; themes & icons
                 qt5ct
                 papirus-icon-theme
                 arc-theme
                 raleigh-theme
                 raleigh-olive-theme
                 hackneyed-x11-cursors
                 ;; spellcheck
                 enchant
                 hunspell
                 hunspell-dict-en-gb))
 (services
  (append
   (list
    (service home-bash-service-type
	     (home-bash-configuration
              ;; Set false as using guix system
              (guix-defaults? #f)
              (variables
	       `(("PS1"
		  . "\\[\\e]0;\\w${GUIX_ENVIRONMENT:+ [env]} - ${TERM} \\l\\a\\]\\u@\\h \\w${GUIX_ENVIRONMENT:+ [env]}\\$ ")))
              (aliases '(("grep" . "grep --color=auto")
                         ("ip" . "ip -color=auto")
                         ("ll" . "ls -l")
                         ("ls" . "ls -p --color=auto")))))
    (simple-service 'env-vars-service
                    home-environment-variables-service-type
                    `(("GUIX_SANDBOX_EXTRA_SHARES"
		       . "$HOME/mnt/local/hdd:$HOME/Games")
                      ("QT_QPA_PLATFORMTHEME" . "qt5ct")
                      ("QT_PLUGIN_PATH"
		       . "$HOME/.guix-home/profile/lib/qt5/plugins")))
    (simple-service 'channels-configuration
		    home-channels-service-type
		    (list
		     (channel
		      (name 'holo-guix-local)
		      (branch "main")
		      (url (string-append "file://" "/home/jake/Source/holo-guix")))
		     (channel
		      (name 'nonguix)
		      (url "https://gitlab.com/nonguix/nonguix")
		      (introduction
		       (make-channel-introduction
			"897c1a470da759236cc11798f4e0a5f7d4d59fbc"
			(openpgp-fingerprint
			 "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
		     (channel
		      (name 'guix-discord)
		      (url "https://github.com/jack-faller/guix-discord")
		      (introduction
		       (make-channel-introduction
			"78e9fecec8b671771153505323f3face650d478a"
			(openpgp-fingerprint
			 "D97A 5464 A392 0366 1ED9  5C07 A043 7B42 9C10 4C61"))))))
    (service home-dbus-service-type)
    (service home-pipewire-service-type)
    (service home-openssh-service-type
	     (home-openssh-configuration
	      (authorized-keys
	       (list (local-file "/home/jake/.ssh/laptop.pub")))))
    (service home-ssh-agent-service-type)
    (service home-gpg-agent-service-type
	     (home-gpg-agent-configuration
	      (pinentry-program
	       (file-append pinentry "/bin/pinentry-gtk-2"))
	      (extra-content "
allow-emacs-pinentry
allow-loopback-pinentry
"))))
   %base-home-services)))
