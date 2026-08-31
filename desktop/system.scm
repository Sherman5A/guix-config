;; -*- mode: scheme; -*-

(use-modules (gnu)
             (gnu packages python)
             (gnu system nss)
             (gnu packages linux)
             (gnu packages xfce)
             (gnu packages polkit)
             (gnu packages wm)
             (gnu packages emacs)
             (gnu packages fonts)
             (gnu packages text-editors)
             (gnu packages admin)
             (gnu packages terminals)
             (gnu packages version-control)
             (gnu packages ssh)
             (gnu packages gnupg)
             (gnu services lightdm)
             (gnu services ssh)
             (gnu services pm)
             (gnu packages gnome-xyz)
             (gnu packages xorg)
             (gnu packages cryptsetup)
             (guix utils)
             (holo gtk)
             (holo wm)
             (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules desktop sddm xorg virtualization spice sound)
(use-package-modules gnome)

(define %default-console-font
  ;;#~(file-append font-terminus "/share/consolefonts/ter-132n.psf.gz")
  #~(string-append #+font-terminus "/share/consolefonts/ter-132n.psf.gz")
)

;; (module-set! (resolve-module '(gnu services base)) '%default-console-font #~(string-append #+font-terminus "/share/consolefonts/ter-132n.psf.gz"))

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (host-name "niko")
  (timezone "Europe/London")
  (locale "en_GB.utf8")
  (keyboard-layout (keyboard-layout "us"))
  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /efi.
  (bootloader (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets '("/efi"))
    (keyboard-layout keyboard-layout)
    (menu-entries
     (list 
      (menu-entry
       (label "Windows")
       (device (uuid "2D27-BD02" 'fat))
       (chain-loader "/efi/Microsoft/Boot/bootmgfw.efi"))))))
  (file-systems
   (append (list 
     (file-system
      (device (uuid "a67103ae-0505-44d4-a234-21bd859089f0"))
      (mount-point "/")
      (type "btrfs")
      (flags '(no-atime))
      (options "subvol=@,compress=zstd"))
     (file-system
      (device (uuid "a67103ae-0505-44d4-a234-21bd859089f0"))
      (mount-point "/home")
      (type "btrfs")
      (flags '(no-atime))
      (options "subvol=@home,compress=zstd"))
     (file-system
      (device (uuid "a67103ae-0505-44d4-a234-21bd859089f0"))
      (mount-point "/gnu")
      (type "btrfs")
      (flags '(no-atime))
      (options "subvol=@gnu,compress=zstd"))
     (file-system
      (device (uuid "a67103ae-0505-44d4-a234-21bd859089f0"))
      (mount-point "/var/log")
      (type "btrfs")
      (flags '(no-atime))
      (options "subvol=@var_log,compress=zstd"))
     (file-system
      (device (uuid "F400-7CD6" 'fat))
      (mount-point "/efi")
      (type "vfat"))) 
    %base-file-systems))
  ;; Specify a swap file for the system, which resides on the
  ;; root file system.
  (swap-devices (list (swap-space (target (uuid "736d3da0-2b3d-4941-9a8b-e322a93005d5")))))
  ;; Create user with.
  (users (cons (user-account	
    (name "jake")
    (group "users")
    (supplementary-groups '("wheel" "netdev" "audio" "video")))
   %base-user-accounts))
  ;; (groups %base-groups)
  ;; This is where we specify system-wide packages.
  (packages (append (list
                     gvfs
                     font-terminus
                     kanshi
                     brightnessctl
                     swaybg
                     foot
                     labwc
                     polkit-gnome
                     sfwbar
                     htop
                     helix
                     papirus-icon-theme
                     arc-theme
                     hackneyed-x11-cursors
                     font-adobe-source-code-pro
                     git
                     openssh
                     raleigh-theme
                     cryptsetup
                     gnupg)
                     %base-packages))
  ;; labwc only
  ;; Uses "desktop" services, which
  ;; include the log-in service, networking with
  ;; NetworkManager, and more.
  (services
   (append (list 
    (service greetd-service-type
    (greetd-configuration
     (greeter-supplementary-groups (list
       "video"
       "input"))
     (terminals (list 
        (greetd-terminal-configuration
          ;; (extra-shepherd-requirement `(seatd))
          (terminal-vt "1")
          (terminal-switch #t)
          (default-session-command
          (greetd-agreety-session
            (command (greetd-user-session
              (command (file-append labwc "/bin/labwc"))
              (command-args '()) 
              (xdg-session-type "wayland"))))))
        (greetd-terminal-configuration (terminal-vt "2"))
        (greetd-terminal-configuration (terminal-vt "3"))
        (greetd-terminal-configuration (terminal-vt "4"))
        (greetd-terminal-configuration (terminal-vt "5"))
        (greetd-terminal-configuration (terminal-vt "6"))))))
       (service mingetty-service-type (mingetty-configuration (tty "tty7"))))
       ;; (set-xorg-configuration
       ;;   (xorg-configuration (keyboard-layout keyboard-layout)))
       (modify-services %desktop-services
         (delete gdm-service-type)
         ;; (delete login-service-type)
         (delete mingetty-service-type)
         (console-font-service-type config =>
           (map (lambda (tty)
             (cons tty %default-console-font))
               '("tty1"
                  "tty2"
                  "tty3"
                  "tty4"
                  "tty5"
                  "tty6"
                  "tty7")))
         (guix-service-type config =>
           (guix-configuration (inherit config)
             (substitute-urls
               (append (list
                 "https://substitutes.nonguix.org"
                 "https://cache-test.guix.moe"
                 "https://cache-fi.guix.moe")
                 %default-substitute-urls))
             (authorized-keys
              (append (list
                (plain-file
                 "non-guix.pub"
                 "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))")
                (plain-file
                 "guix-moe.pub"
                 "(public-key (ecc (curve Ed25519) (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))"))
              %default-authorized-guix-keys)))))))
   ;; Allow resolution of '.local' host names with mDNS.
   (name-service-switch %mdns-host-lookup-nss))
