When crashplan is too expensive, you write your own shell script powered by rsync.

Targed directory structure:
* /backups
* /backups/machine-name/yyyy-mm-dd

Server side (say the above nas with sshd, rsync) can use hardlinks with recent yyyy-mm-dd-* attempts 
to keep disk space use lower between different snapshots.
