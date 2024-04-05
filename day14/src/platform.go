package main

import (
	"strings"
)

type Platform struct {
	board [][]uint8
}

func parsePlatform(lines []string) Platform {
	board := make([][]uint8, len(lines))

	for i := 0; i < len(lines); i++ {
		board[i] = make([]uint8, len(lines[i]))
		for j := 0; j < len(lines[i]); j++ {
			board[i][j] = lines[i][j]
		}
	}

	return Platform{board}
}
func (p *Platform) WithoutRoundedRocks() Platform {
	board := make([][]uint8, len(p.board))

	for i := 0; i < len(p.board); i++ {
		board[i] = make([]uint8, len(p.board[i]))
		for j := 0; j < len(p.board[i]); j++ {
			if p.board[i][j] == 'O' {
				board[i][j] = '.'
			} else {
				board[i][j] = p.board[i][j]
			}
		}
	}

	return Platform{board}
}

func (p *Platform) String() string {
	var sb strings.Builder

	for i := 0; i < len(p.board); i++ {
		for j := 0; j < len(p.board[i]); j++ {
			sb.WriteByte(p.board[i][j])
		}
		sb.WriteRune('\n')
	}

	return sb.String()
}

func (p *Platform) CalculateNorthLoad() int {
	height := len(p.board)
	load := 0
	for i := 0; i < height; i++ {
		for j := 0; j < len(p.board[i]); j++ {
			if p.board[i][j] == 'O' {
				load += (height - i)
			}
		}
	}
	return load
}

func (p *Platform) SlideNorth() Platform {
	ret := p.WithoutRoundedRocks()

	for col := 0; col < len(p.board[0]); col++ {
		// Iterate columns down
		nextOpenIdx := 0
		for row := 0; row < len(p.board); row++ {
			nextChar := p.board[row][col]
			if nextChar == '#' {
				// Found a wall, can only place a rounded rock after it.
				nextOpenIdx = row + 1
			} else if nextChar == 'O' {
				// fmt.Printf("Rock at (%d, %d) going to %d\n", row, col, nextOpenIdx)
				// Roll the rock upwards
				ret.board[nextOpenIdx][col] = 'O'

				// Next one will have to roll on top of this one
				nextOpenIdx++
			}
		}
	}

	return ret
}
