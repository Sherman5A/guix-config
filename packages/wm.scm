(define-module (packages wm)
  #:use-module (guix)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix git-download)
  #:use-module (gnu packages web)
  #:use-module (gnu packages gtk))

(define-public sfwbar
  (package
    (name "sfwbar")
    (version "v1.0_beta16.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/LBCrion/sfwbar.git")
             (commit "v1.0_beta16.1")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0sli2ap6wbhr9d85jckhll3b71hf7sxn1kni94g1ymdlgxfl23sq"))))
    (native-inputs (list pkg-config))
    (inputs (list json-c gtk-layer-shell gtk+))
    (build-system meson-build-system)
    (arguments
     (list
      #:glib-or-gtk? #t
      #:configure-flags
      #~(list ;Required for RUNPATH validation.
              (string-append "-Dc_link_args=-Wl,-rpath="
                             #$output "/lib/sfwbar"))))
    (home-page "https://github.com/LBCrion/sfwbar")
    (synopsis
     "SFWBar (S* Floating Window Bar) is a flexible taskbar application for wayland compositors, designed with a stacking layout in mind. Originally developed for Sway, SFWBar will work with any wayland compositor supporting layer shell protocol, the taskbar and window switcher functionality shall work with any compositor supportinig foreign toplevel protocol, but the pager, and window placement functionality require sway (or at least i3 IPC support).")
    (description "S* Floating Window Bar ")
    (license license:gpl3)))

;; This allows you to run guix shell -f guix-packager.scm.
;; Remove this line if you just want to define a package.
;; sfwbar

