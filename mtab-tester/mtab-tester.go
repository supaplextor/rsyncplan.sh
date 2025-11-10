package main

import (
	"fmt"

	fstab "github.com/d-tux/go-fstab"
)

func main() {
	mounts, err := fstab.ParseFile("/etc/fstab")
	if err != nil {
		panic(err)
	}

	for _, mount := range mounts {
		if 0 != mount.Freq {
			fmt.Printf("Mount: %s\n", mount.File)
		} else {
			fmt.Println("Skipping " + mount.File)
		}
	}
}
