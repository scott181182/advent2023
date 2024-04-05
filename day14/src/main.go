package main

import (
	"log"
	"os"
)

func main() {
	stderr := log.New(os.Stderr, "", 0)

	args := os.Args[1:]

	cmd := args[0]
	filepath := args[1]

	filedata, fileerr := readLines(filepath)
	if fileerr != nil {
		stderr.Fatalln("Could not open the input file")
	}

	platform := parsePlatform(filedata)

	if cmd == "part1" {
		part1(platform)
	} else if cmd == "part2" {
		part2(platform)
	} else {
		stderr.Fatalf("Unknown command: '%s'\n", cmd)
	}
}
