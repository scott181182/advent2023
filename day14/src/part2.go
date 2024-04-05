package main

import (
	"fmt"
)

func part2(p Platform) {
	// fmt.Println(p.String())
	p.RepeatSpin(1_000_000_000)
	// fmt.Println(p.String())
	load := p.CalculateNorthLoad()
	fmt.Println("Load: ", load)
}
