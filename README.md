When crashplan is too expensive, you write your own shell script powered by rsync.

Targed directory structure:
* /backups
* /backups/machine-name/yyyy-mm-dd

Server side (say the above nas with sshd, rsync) can use hardlinks with recent <code>yyyy-mm-dd</code> attempts 
to keep disk space use lower between different snapshots.

## Sample Invocation

<code><pre>&lt;f.st...... var/log/syslog
    182,467,592 100%  148.99MB/s    0:00:01 (xfr#110, to-chk=573/1376624)
&lt;f..t...... var/log/journal/...../system.journal
      8,388,608 100%   38.65MB/s    0:00:00 (xfr#111, to-chk=455/1376624)
&lt;f..t...... var/log/journal/...../user-1000.journal
    117,440,512 100%  168.42MB/s    0:00:00 (xfr#112, to-chk=423/1376624)

sent 69,922,146 bytes  received 227,617 bytes  871,425.63 bytes/sec
total size is 5,837,767,005,136  speedup is 83,218.63
<font color="#4E9A06"><b>uid1234@host234</b></font>:$ history | tail -n 5
  170  w
  170  df -h
  171  ls -la
  172  sudo /usr/local/sbin/rsyncplan
  173  history | tail -n 5
<font color="#4E9A06"><b>uid1234@host234</b></font>:$
</pre></code>

# Install rsyncplan

<pre><code><font color="#FF9A06"><b>root@host234</b></font>:# make install
</pre></code>
