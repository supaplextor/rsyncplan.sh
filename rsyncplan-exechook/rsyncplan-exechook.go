package main

import (
	"fmt"
	"log"
	"log/syslog"
	"os"
	"os/exec"
	"runtime"
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
	lastArg := args[len(args)-1]

	// Configure the standard logger to write to the syslog.
	// We set the priority to LOG_NOTICE and the tag to "mygoapp".
	logwriter, err := syslog.New(syslog.LOG_NOTICE|syslog.LOG_DAEMON, os.Args[0])
	if err != nil {
		log.Fatalf("%s%s %s", __LINEETC__(), "Failed to connect to syslog: ", err.Error())
		os.Exit(3)
	}
	log.SetOutput(logwriter)

	if len(argsWithoutProg) == 0 {
		log.Fatalf("%s%s", __LINEETC__(), "Failure to provide target directory (is rsync running this?)")
		os.Exit(1)
	}

	log.Printf("%s %s %s %s", __LINEETC__(), "MkdirAll(", lastArg, ", 0750)")
	err = os.MkdirAll(lastArg, 0750)
	if err != nil {
		log.Fatalf("%s %s", __LINEETC__(), err.Error())
		os.Exit(2)
	}

	// call rsync now its date time stamped directory
	log.Println("Calling rsync", argsWithoutProg)
	cmd := exec.Command("rsync", argsWithoutProg...)
	//	cmd := exec.Command("bash", "-c", "echo 'Hello from bash'; sleep 1; echo 'Done'")
	cmd.Stdout = os.Stdout // Direct stdout to the program's stdout
	cmd.Stderr = os.Stderr // Direct stderr to the program's stderr
	cmd.Stdin = os.Stdin   // maybe?

	err = cmd.Run()
	// stdoutStderr, err := cmd.CombinedOutput()
	if err != nil {
		log.Printf("rsync")
		log.Fatalf("%s %s", __LINEETC__(), err.Error())
		os.Exit(255)
	}
}
