package main

import (
	"bytes"
	"fmt"
	"log"
	"log/syslog"
	"os"
	"os/exec"
	"runtime"
	"strings"
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

	//	lastArg
	me, err := os.Hostname()
	if err != nil {
		log.Fatalf("%s Cannot find hostname %s", __LINEETC__(), err.Error())
		os.Exit(10)
	} else {
		log.Printf("%s I am %s", __LINEETC__(), me)
	}

	// Get the current time
	t := time.Now()

	// Format a custom date and time string
	customFormat := "2006-01-02_150405.98765"
	log.Printf("%s Custom format: %s", __LINEETC__(), t.Format(customFormat))

	//	# rsyncplan -p /home -l home -h rsyncplan-dump
	//links=$(
	// ssh "${RSYNCPLAN_DESINATION_HOST}" ls -1d "${OFS}/????-??-??*/" 2>/dev/null |\
	//sort -nr |\
	//head -n 20 |\
	//awk '{print "--link-dest=__OFS__/"$1"/"}' |\
	//sed -e "s#__OFS__##g" | tr -s /
	//)
	//

	// Get the current time.
	now := time.Now()

	// The reference layout for HHMMSS.ns is 15:04:05.000000000
	// 15 is the hour (3PM)
	// 04 is the minute
	// 05 is the second
	// .000000000 represents nanoseconds
	layout := "2006-01-02_150405.000000000"

	// Format the current time using the layout.
	formattedTime := now.Format(layout)
	if err != nil {
		log.Fatalf("Cannot format timestamp %s", err.Error())
		os.Exit(9)
	}

	// rsync $ops $links $ifs "${RSYNCPLAN_DESINATION_HOST}":"${OFS}/${TIMESTAMP_YMDHMS_NS}/"
	OFS := "/backups/" + me + "/rootfs/"
	log.Println("Calling ssh", RSYNCPLAN_DESTINATION_HOST, "ls -1d ... ")
	cmd := exec.Command("ssh", RSYNCPLAN_DESTINATION_HOST,
		"ls -1d "+OFS+"????-??-??*/ | sort -nr | head -n 20")

	// Create a bytes.Buffer to capture the stdout
	var stdoutBuffer bytes.Buffer
	cmd.Stdout = &stdoutBuffer

	// Run the command
	err = cmd.Run()
	if err != nil {
		log.Fatalf("Command execution failed: %v", err)
	}

	// Retrieve the captured stdout as a string
	outputString := stdoutBuffer.String()
	ld := strings.Split(outputString, "\n")
	// --link-dest=

	ops := "--rsync-path=/usr/local/sbin/rsyncplan-exechook --timeout=1200 --exclude=/swapfile -iSaXAlx"
	opsArray := strings.Split(ops, " ")
	rootfs := "/" // client side; TODO/FIXME/ labels and other filesystems.

	log.Printf("Target destination directory calculated as: %s", OFS+formattedTime+"/")
	allopts := []string{"rsync"}
	log.Printf("%s exec: %v", __LINEETC__(), allopts)

	allopts = append(allopts, opsArray...)
	log.Printf("%s opsArray... %v", __LINEETC__(), opsArray)

	allopts = append(allopts, ld...)
	log.Printf("%s ld... %v (all the --link-dest= targets)", __LINEETC__(), ld)

	allopts = append(allopts, rootfs, RSYNCPLAN_DESTINATION_HOST+":"+OFS+formattedTime+"/")
	log.Printf("%s finally %v", __LINEETC__(), allopts)

	cmd = exec.Command("echo", allopts...)
	if err != nil {
		log.Fatalf("%s %s %s", __LINEETC__(), "rsync", err.Error())
		os.Exit(255)
	}
	log.Printf("%s %s", __LINEETC__(), cmd.Stdout)
}
