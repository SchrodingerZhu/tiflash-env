ARCH=$(shell uname -m)
MOUNT=$(shell realpath tiflash-env)
tiflash-env:
	mkdir -p tiflash-env

tiflash-env/prepare-sysroot.sh: tiflash-env
	cp prepare-sysroot.sh tiflash-env

tiflash-env/loader: tiflash-env
	cp loader tiflash-env

tiflash-env/tiflash-linker: tiflash-env
	cp tiflash-linker tiflash-env

tiflash-env/README.md: tiflash-env
	cp README.md tiflash-env

tiflash-env/LICENSE:
	cp LICENSE tiflash-env

tiflash-env-$(ARCH).tar.xz: tiflash-env/prepare-sysroot.sh tiflash-env/loader tiflash-env/tiflash-linker tiflash-env/README.md tiflash-env/LICENSE
	docker run --rm -v $(MOUNT):/tiflash-env hub.pingcap.net/tiflash/tiflash-llvm-base:$(ARCH) /tiflash-env/prepare-sysroot.sh
	tar -I "xz -T 0 -e" -cvf tiflash-env-$(ARCH).tar.xz tiflash-env

clean:
	rm -rf tiflash-env
