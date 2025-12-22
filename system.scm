;; -*- mode: scheme; -*-
;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS, and a swap file.

(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))
(use-modules (gnu)
             (gnu system nss)
             (guix utils)
             (gnu packages linux)
             (gnu packages xfce)
             (gnu packages wm)
             (gnu packages emacs)
             (gnu packages text-editors)
             (gnu packages admin)
             (gnu packages terminals)
             (gnu packages version-control)
             (gnu packages ssh)
             (gnu packages gnupg)
             (gnu services lightdm)
             (gnu services pm))
(use-service-modules desktop sddm xorg)
(use-package-modules gnome)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (host-name "holo")
  (timezone "Europe/London")
  (locale "en_GB.utf8")

  ;; Choose US English keyboard layout.  The "altgr-intl"
  ;; variant provides dead keys for accented characters.
  (keyboard-layout (keyboard-layout "gb"))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/efi"))
                (keyboard-layout keyboard-layout)))

  ;; Specify a mapped device for the encrypted root partition.
  ;; The UUID is that returned by 'cryptsetup luksUUID'.
  (mapped-devices (list (mapped-device
                          (source (uuid "04616477-f284-4566-b447-1f0188e53952"))
                          (target "root")
                          (type luks-device-mapping))))

  (file-systems (append (list (file-system
                                (device (file-system-label "root"))
                                (mount-point "/")
                                (type "xfs")
                                (dependencies mapped-devices))
                              (file-system
                                (device (uuid "5008-227B"
                                              'fat))
                                (mount-point "/efi")
                                (type "vfat"))) %base-file-systems))

  ;; Specify a swap file for the system, which resides on the
  ;; root file system.
  (swap-devices (list (swap-space
                        (target (uuid "76d0faab-ac87-4246-b0b7-fbe56ce0ee00")))))

  ;; Create user with.
  (users (cons (user-account
                 (name "jake")
                 (password (crypt "alice" "$6$abc"))
                 (group "users")
                 (supplementary-groups '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

  ;; (groups %base-groups)
  
  ;; This is where we specify system-wide packages.
  (packages (append (list
                     ;; for user mounts
                     gvfs
                     xfce4-whiskermenu-plugin
                     foot
                     labwc
                     emacs
                     htop
                     btop
                     helix
                     git
                     openssh
                     gnupg
                     pinentry-tty
                     tlp) %base-packages))

  ;; XFCE only
  ;; Uses "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services
   (append (list (service lightdm-service-type)
                 (service xfce-desktop-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))
                  lightdm-service-type)
                 (service tlp-service-type
                          (tlp-configuration
			    (tlp-default-mode "BAT")
			    (start-charge-thresh-bat0 0)
                            (stop-charge-thresh-bat0 1))))
           (modify-services %desktop-services
             (delete gdm-service-type)
             (guix-service-type config =>
                                (guix-configuration (inherit config)
                                                    (substitute-urls (append (list
                                                                              "https://substitutes.nonguix.org")
                                                                      %default-substitute-urls))
                                                    (authorized-keys (append (list
                                                                              (plain-file
                                                                               "non-guix.pub"
                                                                               "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                                                      %default-authorized-guix-keys)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
