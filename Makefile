
install:
	install -v -d /usr/local/share/rsyncplan/
	install -v -p -t /usr/local/sbin/ rsyncplan*
	install -v -p -t /usr/local/share/rsyncplan/ README.md
uninstall:
	rm -v -f /usr/local/sbin/rsyncplan* /usr/local/share/rsyncplan/README.md
	rmdir -v /usr/local/share/rsyncplan/

