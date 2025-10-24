package main

import (
	"log"
	"log/syslog"
	"os"
	"os/exec"
	"strings"
)

func main() {
	argsWithoutProg := os.Args[1:]
	args := os.Args
	sysLog, err := syslog.Dial("tcp", "localhost:514", syslog.LOG_WARNING|syslog.LOG_DAEMON, "rsyncplan-exechook")
	if err != nil {
		sysLog.Warning(err.Error())
		log.Fatal(err)
	}
	defer sysLog.Close()

	if len(argsWithoutProg) == 0 {
		// Log a warning message
		sysLog.Warning("Failure to provide target directory (is rsync running this?)")
		log.Fatal("Failure to provide target directory (is rsync running this?)")
		os.Exit(1)
	}

	lastArg := args[len(args)-1]
	sysLog.Warning("MkdirAll(" + lastArg + ", 0750)")
	err = os.MkdirAll(lastArg, 0750)
	if err != nil {
		sysLog.Warning(err.Error())
		log.Fatal(err)
		os.Exit(2)
	}
	// call rsync now its date time stamped directory
	cmd := exec.Command("rsync", argsWithoutProg...)
	var out strings.Builder
	cmd.Stdout = &out
	err = cmd.Run()
	if err != nil {
		sysLog.Warning(err.Error())
		log.Fatal(err)
		os.Exit(255)
	}
}
