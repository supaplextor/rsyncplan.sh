GOPATH=${HOME}/go:/usr/share/gocode
# Safer if not lowercase. Use CamelCase. (watch out in make clean)
APP=rsyncplan
# Safer if not empty. (watch out in make clean)
RELEASEDIR=releases/

all: build
build:
	make build-one GOOS=linux GOARCH=amd64
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
clean:
	rm -f ${RELEASEDIR}${APP}* */go.sum */go.mod
	go clean
install:
	install -v -d /usr/local/share/rsyncplan/
	install -m 0644 -v -p -t /usr/local/share/rsyncplan/ README.md
	install -m 0644 -v -p -t /etc/sudoers.d/ rsyncplan-sudoers
	install -v -p -t /usr/local/sbin/ rsyncplan-go/rsyncplan rsyncplan-exechook/rsyncplan-exechook
uninstall:
	rm -v -f /usr/local/sbin/rsyncplan* /usr/local/share/rsyncplan/README.md /etc/sudoers.d/rsyncplan-sudoers
	rmdir -v /usr/local/share/rsyncplan/
