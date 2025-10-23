GOPATH=${HOME}/go:/usr/share/gocode
# Safer if not lowercase. Use CamelCase. (watch out in make clean)
APP=rsyncplan
# Safer if not empty. (watch out in make clean)
RELEASEDIR=releases/

all: build
build:
	make build-one GOOS=linux GOARCH=amd64
init:
	cd rsyncplan && go mod init ${APP}/v2
	go mod tidy || true
	go mod download

	cd ../rsyncplan-exechook && go mod init ${APP}/v2
	go mod tidy || true
	go mod download
build-one:
	go build -o ${RELEASEDIR}rsyncplan rsyncplan
	go build -o ${RELEASEDIR}rsyncplan-exechook rsyncplan-exechook


#	make release-most || echo release-most ${GOOS}
#release-most:
#	tar -C ${RELEASEDIR} -cvf ${RELEASEDIR}${APP}-${GOOS}-${GOARCH}.tar.bz2 ${APP}-${GOOS}-${GOARCH} ../README.md
#release-windows:
#	zip -j ${RELEASEDIR}${APP}-${GOOS}-${GOARCH}.zip ${RELEASEDIR}${APP}-${GOOS}-${GOARCH}${dotEXE} README.md
build-release: build
	make build-one GOOS=linux GOARCH=386
#	make build-one GOOS=windows GOARCH=386 dotEXE=.exe
#	make build-one GOOS=windows GOARCH=amd64 dotEXE=.exe
build-more:
	make build-one GOOS=darwin GOARCH=amd64 || true
#	make build-one GOOS=android GOARCH=arm || true
	make build-one GOOS=darwin GOARCH=386 || true
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
	rm -f ${RELEASEDIR}${APP}-* go.sum go.mod
	go clean
run:
	sleep 1
	./${RELEASEDIR}${APP}-linux-amd64

install:
	install -v -d /usr/local/share/rsyncplan/
	install -m 0644 -v -p -t /usr/local/share/rsyncplan/ README.md
	install -m 0644 -v -p -t /etc/sudoers.d/ rsyncplan-sudoers
	install -v -p -t /usr/local/sbin/ rsyncplan rsyncplan-exechook.sh
uninstall:
	rm -v -f /usr/local/sbin/rsyncplan* /usr/local/share/rsyncplan/README.md /etc/sudoers.d/rsyncplan-sudoers
	rmdir -v /usr/local/share/rsyncplan/