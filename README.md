When crashplan is too expensive, you rewrite shell scripts

Target server directory structure:
* /backups
* /backups/machine-name/rootfs/YYYY-MM-DD_HHMMSS_NS

Server side (say the above with sshd, rsync) can use 
hardlinks with recent <code>yyyy-mm-dd</code> attempts 
to keep disk space use lower between different snapshots.

## Sample Invocation
<code># rsyncplan rsyncplan-plus201.rollback.cloud</code>

It will fire off one ssh connection and close to grab most recent
directory list. 

## rsync --link-dest= strategy

We collect a ls -1d and parse present directories 
as --link-dest= args
