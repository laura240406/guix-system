(define-public fwupd-patched
  (package
    (name "fwupd")
    (version "1.9.32")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/fwupd/fwupd")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0nabjgskbpinj7sj44kblnd8g6psppas4g8qgajfs3p19skp07y1"))))
    (build-system meson-build-system)
    (arguments
     (list
      #:configure-flags #~(list "--wrap-mode=nofallback"
                                "-Dsystemd=false"
                                (string-append "-Defi_os_dir="
                                               #$gnu-efi "/lib")
                                "-Defi_binary=false"
                                (string-append "-Dudevdir="
                                               #$output "/lib/udev")
                                "--localstatedir=/var"
                                (string-append "--libexecdir="
                                               #$output "/libexec")
                                "-Dsupported_build=true"
                                "-Dlvfs=true")
      #:glib-or-gtk? #t               ;To wrap binaries and/or compile schemas
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'make-source-writable
            (lambda _
              (for-each (lambda (file)
                          ;; Skip symlinks as `make-file-writable' fails for those.
                          (unless (eq? 'symlink (stat:type (lstat file)))
                            (format #t "Make writable: ~A~%" file)
                            (make-file-writable file)))
                        (find-files "."))
              (substitute* "src/fu-self-test.c"
                (("/bin/sh")
                 (which "sh")))
              ;; fwupdmgr checks for missing polkit actions, prints
              ;; error message and exits if the polkit actions are
              ;; not found.
              ;; The path points to gnu store path of polkit and
              ;; there are no actions there. Point this to the actual
              ;; location used on Guix System. This will still fail on
              ;; foreign distros as /usr/share/polkit-1 is used mostly.
              (substitute* "src/fu-util.c"
                (("g_autofree gchar \\*directory = NULL;")
                 "")
                (("directory = fu_path_from_kind\\(FU_PATH_KIND_POLKIT_ACTIONS\\)")
                 "const gchar* directory = \"/etc/polkit-1/actions\""))))
          ;; These two files are zipped by Python, so need a newer timestamp.
          (add-after 'unpack 'newer-timestamps-for-python-zip
            (lambda _
              (let ((circa-1980 (* 10 366 24 60 60)))
                (for-each (lambda (file)
                            (make-file-writable file)
                            (utime file circa-1980 circa-1980))
                          '("./libfwupdplugin/tests/colorhug/firmware.bin"
                            "./libfwupdplugin/tests/colorhug/firmware.bin.asc")))))
          (add-before 'build 'setup-home
            (lambda _
              (setenv "HOME" "/tmp")))
          (add-before 'install 'no-polkit-magic
            (lambda _
              (setenv "PKEXEC_UID" "something")))
          (add-after 'glib-or-gtk-wrap 'fix-esp
            (lambda _
              (call-with-output-file (string-append #$output "/etc/fwupd/daemon.conf")
                (lambda (port)
                  (format port "\nEspLocation=/boot")))))
          (add-after 'glib-or-gtk-wrap 'install-fwupd.efi
            ;; fwupd looks for its .efi file within its own prefix, so link
            ;; the directory containing the arch-specific executable here.
            ;; If we install a symlink to the efi directory before
            ;; 'glib-or-gtk-wrap, then the wrapping procedure mistakes the
            ;; directory symlink for an executable and tries to wrap it.
            (lambda _
              (symlink (string-append #$(this-package-input "fwupd-efi")
                                      "/libexec/fwupd/efi")
                       (string-append #$output "/libexec/fwupd/efi")))))))
    (native-inputs (list gobject-introspection
                         python-jinja2
                         python-pygobject
                         python-pillow
                         python-pycairo
                         python
                         pkg-config
                         vala
                         gtk-doc
                         which
                         umockdev
                         `(,glib "bin")
                         help2man
                         gettext-minimal))
    (inputs (append
             (list bash-completion
                   elogind
                   libgudev
                   libxmlb
                   sqlite
                   polkit
                   eudev
                   libelf
                   tpm2-tss
                   cairo
                   efivar
                   pango
                   protobuf-c
                   fwupd-efi
                   mingw-w64-tools
                   gnu-efi)
             (if (supported-package? libsmbios
                                     (or (and=> (%current-target-system)
                                                platform-target->system)
                                         (%current-system)))
                 (list libsmbios)
                 '())))
    ;; In Requires of fwupd*.pc.
    (propagated-inputs (list curl
                             gcab
                             glib
                             gnutls
                             gusb
                             json-glib
                             libarchive
                             libjcat))
    (home-page "https://fwupd.org/")
    (synopsis "Daemon to allow session software to update firmware")
    (description "This package aims to make updating firmware on GNU/Linux
automatic, safe and reliable.  It is used by tools such as GNOME Software.")
    (license license:lgpl2.1+)))
