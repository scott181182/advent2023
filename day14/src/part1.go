package main

import (
	"fmt"
)

func part1(p Platform) {
	p.SlideNorth()
	// fmt.Println(afterSlide.String())
	load := p.CalculateNorthLoad()
	fmt.Println("Load: ", load)
}
