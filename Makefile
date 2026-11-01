unexport LIVE_IMAGE

update: src/secrets.scm
	./scripts/update.sh

deploy: src/secrets.scm
	sudo $(shell which guix) system init configs/$(shell hostname).scm /mnt

test: src/secrets.scm
	$(shell guix system vm os.scm) -m 6G -smp 4 --enable-kvm

format:
	@./scripts/format.sh

gc:
	sudo guix system delete-generations
	sudo python3 scripts/copy_kernel.py
	guix home delete-generations
	guix gc

build:
	./scripts/build.sh

src/secrets.scm: src/secrets.scm.age
	age -d $< > $@

.PHONY: update deploy test gc
