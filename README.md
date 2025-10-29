When crashplan is too expensive, you rewrite shell scripts

* <code>git clone https://github.com/supaplextor/rsyncplan.git</code>
* <code>cd rsyncplan</code>
* <code>make</code> <code>sudo make install</code>
* <code>sudo apt install rsync rsyslog</code>

Target server directory structure:
* /backups
* /backups/machine-name/rootfs/YYYY-MM-DD_HHMMSS_NS

Server side (say the above with sshd, rsync) can use 
hardlinks with recent <code>yyyy-mm-dd</code> attempts 
to keep disk space use lower between different snapshots.

## Sample Invocation
<code># rsyncplan rsyncplan-plus201.rollback.cloud</code>

It will fire off one ssh connection and close to grab most recent
directory list. Next it will call rsync. You're advised to setup
a ssh config entry for the remote root shell. This allows
passwordless login via ssh keys.

## rsync --link-dest= strategy

We collect a ls -1d and parse present directories 
as --link-dest= args
