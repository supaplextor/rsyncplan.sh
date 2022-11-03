When crashplan is too expensive, you write your own shell script powered by rsync.

Target directory structure:
* /backups
* /backups/machine-name/rootfs/YYYY-MM-DD_HHMMSS_NS

Server side (say the above with sshd, rsync) can use 
hardlinks with recent <code>yyyy-mm-dd</code> attempts 
to keep disk space use lower between different snapshots.

## Sample Invocation
<code># rsyncplan rsyncplan-plus201.rollback.cloud</code>

It will fire off one ssh connection and close to grab most recent
directory list. 

A second ssh connection is the one doing the rsync work.
<code><pre><font color="#E09A06"><b>root@host234</b></font>:# rsyncplan rsyncplan-plus201.rollback.cloud
&lt;f.st...... var/log/syslog
    182,467,592 100%  148.99MB/s    0:00:01 (xfr#110, to-chk=573/1376624)
&lt;f..t...... var/log/journal/...../system.journal
      8,388,608 100%   38.65MB/s    0:00:00 (xfr#111, to-chk=455/1376624)
&lt;f..t...... var/log/journal/...../user-1000.journal
    117,440,512 100%  168.42MB/s    0:00:00 (xfr#112, to-chk=423/1376624)

sent 69,922,146 bytes  received 227,617 bytes  871,425.63 bytes/sec
total size is 5,837,767,005,136  speedup is 83,218.63
<font color="#E09A06"><b>root@host234</b></font>:# 
</pre></code>

## Install rsyncplan
<code><pre><font color="#4E9A06"><b>uid1234@host234</b></font>:$ 
$ git clone https://github.com/supaplextor/rsyncplan.git
Cloning into 'rsyncplan'...
remote: Enumerating objects: 106, done.
remote: Counting objects: 100% (76/76), done.
remote: Compressing objects: 100% (48/48), done.
remote: Total 106 (delta 37), reused 59 (delta 25), pack-reused 30
Receiving objects: 100% (106/106), 25.42 KiB | 839.00 KiB/s, done.
Resolving deltas: 100% (40/40), done.
$ cd rsyncplan
$ ls      
Makefile  README.md  rsyncplan  rsyncplan-exechook.sh
$ fakeroot make install
install -v -d /usr/local/share/rsyncplan/
install -v -p -t /usr/local/sbin/ rsyncplan*
install: cannot remove '/usr/local/sbin/rsyncplan': Permission denied
install: cannot remove '/usr/local/sbin/rsyncplan-exechook.sh': Permission denied
make: *** [Makefile:4: install] Error 1
$ rsyncplan
/usr/local/sbin/rsyncplan: rsync to remote and collect existing timestamp leaf
  directories to hardlink with, saving space and xfer time/bw.

(C) 2022 GPLv2 https://github.com/supaplextor/rsyncplan
$ # use /root/.ssh keys wisely
$ # configure root ssh logins eg /etc/ssh/sshd_config
$ # -- apropos ssh is your friend
$ sudo rsyncplan rsyncplan-plus201.rollback.cloud

$ 

</pre></code>

## rsync --link-dest= strategy

The first ssh connection is collecting a list
of <code>/backups/machine-name/rootfs/????-??-??*/</code> present on
your rollback.cloud

The list of directories or symlinks to directories we can hardlink into.
If you change <code>rsyncplan-exechook.sh</code> option inside you can debug
the rsync arguments ready to roll. This is where the hook parses the
destination path ready for timestamp appending. /backups/path/timestamp/
where path is the host and rootfs/label (labels are untested, avoid it)

## Other ways to take advantage of --link-dest=

The client side logic would not be any wiser* if you mix and
match snapshots in the same /backups/<b>hostname</b>/rootfs
path. E.g., you could somewhat cheat to squish some hardlinks
of identical content between a workgroup of very similar
clients. (* yes, this needs testing proofs, real life suggests
"don't get creative" )
