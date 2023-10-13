NAME=clashF
BUILDTIME=$(shell date -u)

build:
	cd Clash.Meta && go mod download && CGO_ENABLED=0 && go build -tags with_gvisor -trimpath -ldflags ' -X "github.com/Dreamacro/clash/constant.BuildTime=$(BUILDTIME)" -w -s -buildid=' -o ../module/clash/clashkernel/clashMeta
	cd module && zip -r ../$(NAME).zip *

