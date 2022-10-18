When crashplan is too expensive, you write your own shell script powered by rsync.

Targed directory structure:
* /backups
* /backups/machine-name/rootfs/YYYY-MM-DD_HHMMSS_NS

Server side (say the above nas with sshd, rsync) can use hardlinks with recent <code>yyyy-mm-dd</code> attempts 
to keep disk space use lower between different snapshots.

## Sample Invocation

<code># rsyncplan rsyncplan-plus201.rollback.cloud </code>

It will fire off one ssh connection and close to grab most recent
directory list. 

A second ssh connection is the one doing the rsync
work. Eventually this *might* be streamlinded in the future 
by patching rsyncplan-exechook.sh to rewrite the server side logic
without the client needing two ssh invocations per push.

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

<code><font color="#4E9A06">
<pre><b>uid1234@host234</b></font>:$ sudo make install</pre>
</font></code>
</pre></code>

## rsync --link-dest= strategy

The first ssh connection is collecting a list
of <code>/backups/machine-name/rootfs/????-??-??/</code> present on
your rollback.cloud

The list of directories or symlinks to directories we can hardlink into.
If you change <code>rsyncplan-exechook.sh</code> option inside you can debug
the rsync arguments ready to roll. This is where the hook parses the
destination path ready for timestamp appending. /backups/path/timestamp/
where path is the host and rootfs/label (labels are untested, avoid it)

## Other ways to take advantage of --link-dest=

The client side logic would not be any wiser if you mix and
match snapshots in the same /backups/<b>hostname</b>/rootfs
path. E.g., you could somewhat cheat to squish some hardlinks
of identical content between a workgroup of very similar
clients.

Consider the following on your rollback.cloud server.
We'll have to try that... but here goes.

<pre><code># cd /backups
mkdir -p /backups/runner22.IEEE802.cloud/rootfs
cd runner22.IEEE802.cloud/rootfs
ln -s /backups/runners-snapshot.IEEE802.cloud 9999-99-99
ls -l /backups/runner22.IEEE802.cloud/rootfs/
total 0
lrwxrwxrwx 1 root root 39 Oct 18 00:43 9999-99-99 -> /backups/runners-snapshot.IEEE802.cloud
</code></pre>

