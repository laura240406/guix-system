(begin
  (list (channel
          (name 'guix)
          (branch "master")
          (url "https://codeberg.org/guix/guix.git")
          (introduction
           (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
             "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
        (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
        (channel
          (name 'rosenthal)
          (url "https://codeberg.org/hako/rosenthal.git")
          (branch "trunk"))
        (channel
          (name 'lauras-channel)
          (url "https://github.com/jakiki6/lauras-channel"))
;        (channel
;          (name 'guix-hpc)
;          (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
;          (branch "master"))
        (channel
          (name 'guix-science)
          (url "https://codeberg.org/guix-science/guix-science.git")
          (introduction
           (make-channel-introduction
            "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
            (openpgp-fingerprint
             "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
        (channel
          (name 'shepherd)
          (url "https://git.savannah.gnu.org/git/shepherd.git")
          (branch "main")
          (introduction
           (make-channel-introduction
            "788a6d6f1d5c170db68aa4bbfb77024fdc468ed3"
            (openpgp-fingerprint "3CE464558A84FDC69DB40CFB090B11993D9AEBB5"))))
        (channel
          (name 'small-guix)
          (url "https://codeberg.org/fishinthecalculator/small-guix.git")
          (branch "main")
          (introduction
           (make-channel-introduction
            "f260da13666cd41ae3202270784e61e062a3999c"
            (openpgp-fingerprint
             "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2"))))))
