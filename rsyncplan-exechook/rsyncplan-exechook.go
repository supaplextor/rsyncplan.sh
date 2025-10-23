package main

import (
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	argsWithoutProg := os.Args[1:]
	args := os.Args

	if len(argsWithoutProg) == 0 {
		log.Fatal("Failure to provide target directory (is rsync running this?)")
		os.Exit(1)
	}

	lastArg := args[len(args)-1]
	err := os.MkdirAll(lastArg, 0750)
	if err != nil {
		log.Fatal(err)
	}
	// call rsync now its date time stamped directory
	cmd := exec.Command("rsync", argsWithoutProg...)
	var out strings.Builder
	cmd.Stdout = &out
	err = cmd.Run()
	if err != nil {
		log.Fatal(err)
		os.Exit(255)
	}
}
