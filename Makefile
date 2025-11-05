GOPATH=${HOME}/go:/usr/share/gocode
# Safer if not lowercase. Use CamelCase. (watch out in make clean)
APP=rsyncplan
# Safer if not empty. (watch out in make clean)
RELEASEDIR=release/

all: build release release-all
build:
	make build-one GOOS=linux GOARCH=amd64
release:
	test -d release || mkdir release
	make build-one tgz GOOS=linux GOARCH=amd64
init:
	false fixme
	cd rsyncplan && go mod init ${APP}/v2
	go mod tidy || true
	go mod download

	cd ../rsyncplan-exechook && go mod init ${APP}-exechook/v2
	go mod tidy || true
	go mod download
build-one:
	cd rsyncplan-go && go build 
	cd rsyncplan-exechook && go build
	make tgz
release-all:
#	make build-one GOOS=android GOARCH=arm || true
	make build-one GOOS=darwin GOARCH=386 || true	
	make build-one GOOS=darwin GOARCH=amd64 || true
	make build-one GOOS=darwin GOARCH=arm || true
	make build-one GOOS=darwin GOARCH=arm64 || true
	make build-one GOOS=plan9 GOARCH=386 || true
	make build-one GOOS=plan9 GOARCH=amd64 || true
	make build-one GOOS=solaris GOARCH=amd64 || true
	make build-one GOOS=dragonfly GOARCH=amd64 || true
	make build-one GOOS=freebsd GOARCH=386 || true
	make build-one GOOS=freebsd GOARCH=amd64 || true
	make build-one GOOS=freebsd GOARCH=arm || true
	make build-one GOOS=linux GOARCH=arm || true
	make build-one GOOS=linux GOARCH=arm64 || true
	make build-one GOOS=linux GOARCH=ppc64 || true
	make build-one GOOS=linux GOARCH=ppc64le || true
	make build-one GOOS=linux GOARCH=mips || true
	make build-one GOOS=linux GOARCH=mipsle || true
	make build-one GOOS=linux GOARCH=mips64 || true
	make build-one GOOS=linux GOARCH=mips64le || true
	make build-one GOOS=netbsd GOARCH=386 || true
	make build-one GOOS=netbsd GOARCH=amd64 || true
	make build-one GOOS=netbsd GOARCH=arm || true
	make build-one GOOS=openbsd GOARCH=386 || true
	make build-one GOOS=openbsd GOARCH=amd64 || true
	make build-one GOOS=openbsd GOARCH=arm || true
clean:
	cd rsyncplan-go && go clean
	cd rsyncplan-exechook && go clean
	false fixme
	rm -Rf release */go.sum */go.mod
install:
	install -v -d /usr/local/share/rsyncplan/
	install -m 0644 -v -p -t /usr/local/share/rsyncplan/ README.md
#	install -m 0644 -v -p -t /etc/sudoers.d/ rsyncplan-sudoers
	install -v -p -t /usr/local/sbin/ rsyncplan-go/rsyncplan rsyncplan-exechook/rsyncplan-exechook
uninstall:
	rm -v -f /usr/local/sbin/rsyncplan* /usr/local/share/rsyncplan/README.md /etc/sudoers.d/rsyncplan-sudoers
	rmdir -v /usr/local/share/rsyncplan/
tgz:
	tar zcvf ${RELEASEDIR}/${APP}-release-${GOOS}-${GOARCH}.tgz README.md Makefile rsyncplan-go/rsyncplan rsyncplan-exechook/rsyncplan-exechook
