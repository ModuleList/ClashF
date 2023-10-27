NAME=clashF
BUILDTIME=$(shell date -u)
BRANCH=$(shell cd Clash.Meta && git branch --show-current)
ifeq ($(BRANCH),Alpha)
VERSION=alpha-$(shell cd Clash.Meta && git rev-parse --short HEAD)
else ifeq ($(BRANCH),Beta)
VERSION=beta-$(shell cd Clash.Meta && git rev-parse --short HEAD)
else ifeq ($(BRANCH),)
VERSION=$(shell cd Clash.Meta && git describe --tags)
else
VERSION=$(shell cd Clash.Meta && git rev-parse --short HEAD)
endif
CLANG ?= clang-14
CFLAGS := -O2 -g -Wall -Werror $(CFLAGS)
BUILD=CGO_ENABLED=0 go build -tags with_gvisor -trimpath -ldflags '-X "github.com/Dreamacro/clash/constant.Version=$(VERSION)" \
		-X "github.com/Dreamacro/clash/constant.BuildTime=$(BUILDTIME)" \
		-w -s -buildid='
all: android-arm64-v8a android-armeabi-v7a
	cd module && zip -r ../$(NAME).zip *

android-arm64-v8a:
	GOOS=android GOARCH=arm64 cd Clash.Meta && $(BUILD) -o ../module/bin/clashMeta-android-$@
	cd module/bin && tar -vcjf clashMeta-android-$@.tar.bz2 clashMeta-android-$@
	rm -rf ./module/bin/clashMeta-$@

android-armeabi-v7a:
	 GOOS=android GOARCH=arm cd Clash.Meta && $(BUILD) -o ../module/bin/clashMeta-android-$@
	cd module/bin && tar -vcjf clashMeta-android-$@.tar.bz2 clashMeta-android-$@
	rm -rf ./module/bin/clashMeta-$@

default:
	cd Clash.Meta && $(BUILD) -o ../module/bin/clashMeta-android-$@
	cd module/bin && tar -vcjf clashMeta-android-$@.tar.bz2 clashMeta-android-$@
	rm -rf ./module/bin/clashMeta-android-$@
	cd module && zip -r ../$(NAME).zip *
