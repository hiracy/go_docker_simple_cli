package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	var showVersion bool
	flag.BoolVar(&showVersion, "version", false, "print version")
	flag.Parse()

	if showVersion {
		fmt.Println(getVersion())
		os.Exit(0)
	}

	fmt.Println("This is CLI tool.")
}

func getVersion() string {
	return "0.0.1"
}
