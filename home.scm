(use-modules (gnu home)
	     (gnu home services)
	     (gnu home services shells)
	     (gnu packages emacs)
	     (gnu packages emacs-xyz)
	     (gnu packages admin)
	     (gnu packages fonts)
	     (gnu packages gnome-xyz)
	     (gnu packages xdisorg)
	     (gnu packages xorg)
	     (gnu packages commencement)
	     (gnu packages guile)
	     (gnu packages messaging)
	     (gnu packages password-utils)
	     (gnu packages librewolf)
	     (gnu packages ncdu)
	     (gnu packages rust-apps)
	     (gnu packages wm)
             (gnu packages hunspell)
	     (gnu packages enchant)
	     (holo wm))

(home-environment
 (packages (list
	    arc-theme
	    emacs-pgtk
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
	    hexchat
	    keepassxc
	    labwc-menu-generator
	    librewolf
	    uv
	    wlr-randr
	    font-iosevka
	    font-terminus
	    font-google-noto
	    font-openmoji
	    gammastep
	    gcc-toolchain
	    hackneyed-x11-cursors
	    htop
	    enchant
	    arc-theme
	    hunspell
	    hunspell-dict-en-gb))
 (services
  (append (list (service home-bash-service-type
			 (home-bash-configuration
			  ;; Set false as using guix system
			  (guix-defaults? #f)
			  (aliases '(("grep" . "grep --color=auto")
                                     ("ip" . "ip -color=auto")
                                     ("ll" . "ls -l")
                                     ("ls" . "ls -p --color=auto"))))))
	  %base-home-services)))
