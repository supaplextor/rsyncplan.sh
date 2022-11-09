
install:
	install -v -d /usr/local/share/rsyncplan/
	install -m 0644 -v -p -t /usr/local/share/rsyncplan/ README.md
	install -m 0644 -v -p -t /etc/sudoers.d/ rsyncplan-sudoers
	install -v -p -t /usr/local/sbin/ rsyncplan rsyncplan-exechook.sh
uninstall:
	rm -v -f /usr/local/sbin/rsyncplan* /usr/local/share/rsyncplan/README.md /etc/sudoers.d/rsyncplan-sudoers
	rmdir -v /usr/local/share/rsyncplan/

