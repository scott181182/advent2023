package main

import (
	"fmt"
)

func part1(p Platform) {
	afterSlide := p.SlideNorth()
	// fmt.Println(afterSlide.String())
	load := afterSlide.CalculateNorthLoad()
	fmt.Println("Load: ", load)
}
