package main

import (
	"fmt"
	"log"
	"log/syslog"
	"os"
	"os/exec"
	"runtime"
	"time"
)

func __LINEETC__() string {
	_, file, line, ok := runtime.Caller(1) // Get info about the caller of this function
	if !ok {
		file = "unknown"
		line = 0
	}
	return fmt.Sprintf("%s:%d ", file, line)
}

func main() {
	argsWithoutProg := os.Args[1:]
	args := os.Args
	RSYNCPLAN_DESTINATION_HOST := args[len(args)-1]

	// Configure the standard logger to write to the syslog.
	// We set the priority to LOG_NOTICE and the tag to "mygoapp".
	logwriter, err := syslog.New(syslog.LOG_NOTICE|syslog.LOG_DAEMON, os.Args[0])
	if err != nil {
		log.Fatalf("%s%s %s", __LINEETC__(), "Failed to connect to syslog: ", err.Error())
		os.Exit(3)
	}
	log.SetOutput(logwriter)

	if len(argsWithoutProg) == 0 {
		log.Fatalf("%s %s", __LINEETC__(), "Failure to provide target backup server (ssh+rsync+etc)?")
		os.Exit(1)
	}

	hostname, err := os.Hostname()
	if err != nil {
		log.Fatalf("Error getting my hostname: %v", err)
		os.Exit(4)
	}

	// Get the current time
	t := time.Now()

	// Format a custom date and time string
	customFormat := "2006-01-02_150405.98765"
	log.Printf("Custom format: %s", t.Format(customFormat))

	OFS := "/backups/" + hostname + "/rootfs/"

	//	# rsyncplan -p /home -l home -h rsyncplan-dump
	//links=$(
	// ssh "${RSYNCPLAN_DESINATION_HOST}" ls -1d "${OFS}/????-??-??*/" 2>/dev/null |\
	//sort -nr |\
	//head -n 20 |\
	//awk '{print "--link-dest=__OFS__/"$1"/"}' |\
	//sed -e "s#__OFS__##g" | tr -s /
	//)
	//

	// rsync $ops $links $ifs "${RSYNCPLAN_DESINATION_HOST}":"${OFS}/${TIMESTAMP_YMDHMS_NS}/"

	log.Println("Calling ssh", RSYNCPLAN_DESTINATION_HOST, "ls -1d ... ")
	cmd := exec.Command("ssh", RSYNCPLAN_DESTINATION_HOST,
		"ls -1d "+OFS+"????-??-??*/ | sort -nr | head -n 20")

	/*
		stdin, err := cmd.StdinPipe()
		if err != nil {
			log.Fatalf("%s %s %s %s", __LINEETC__(), RSYNCPLAN_DESTINATION_HOST,
				"ls -1d "+OFS+"????-??-??* / ... ", err.Error())
			os.Exit(255)
		}
	*/

	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatalf("%s %s %s", __LINEETC__(), "echo", stdout)
		os.Exit(255)
	}

	ops := "--rsync-path=/usr/local/sbin/rsyncplan-exechook --timeout=1200 --exclude=/swapfile -iSaXAlx"
	rootfs := "/"
	cmd = exec.Command("echo", "rsync", ops, rootfs, RSYNCPLAN_DESTINATION_HOST+":"+OFS)
	if err != nil {
		log.Fatalf("%s %s %s", __LINEETC__(), "rsync", err.Error())
		os.Exit(255)
	}
	log.Printf("%s", cmd.Stdout)
}
