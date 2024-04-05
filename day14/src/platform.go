package main

import (
	"bytes"
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
func (p *Platform) Clone() Platform {
	board := make([][]uint8, len(p.board))

	for i := 0; i < len(p.board); i++ {
		board[i] = make([]uint8, len(p.board[i]))
		copy(board[i], p.board[i])
	}

	return Platform{board}
}
func (p *Platform) CloneFrom(other *Platform) {
	for i := 0; i < len(p.board); i++ {
		for j := 0; j < len(p.board[i]); j++ {
			p.board[i][j] = other.board[i][j]
		}
	}
}
func (p *Platform) Equals(other *Platform) bool {
	for i := 0; i < len(p.board); i++ {
		if !bytes.Equal(p.board[i], other.board[i]) {
			return false
		}
	}

	return true
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
func (p *Platform) Hash() string {
	var sb strings.Builder
	var buf byte
	bufl := 0
	for i := 0; i < len(p.board); i++ {
		for j := 0; j < len(p.board[i]); j++ {
			if p.board[i][j] == '#' {
				continue
			}

			buf <<= 1
			bufl++
			if p.board[i][j] == 'O' {
				buf |= 1
			}

			if bufl > 6 {
				sb.WriteByte(0x21 + buf)
				buf = 0
				bufl = 0
			}
		}
	}

	if bufl > 0 {
		sb.WriteByte(0x21 + buf)
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

func (p *Platform) SlideNorth() {
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
				p.board[row][col] = '.'
				p.board[nextOpenIdx][col] = 'O'

				// Next one will have to roll on top of this one
				nextOpenIdx++
			}
		}
	}
}
func (p *Platform) SlideSouth() {
	for col := 0; col < len(p.board[0]); col++ {
		nextOpenIdx := len(p.board) - 1
		for row := len(p.board) - 1; row >= 0; row-- {
			nextChar := p.board[row][col]
			if nextChar == '#' {
				nextOpenIdx = row - 1
			} else if nextChar == 'O' {
				p.board[row][col] = '.'
				p.board[nextOpenIdx][col] = 'O'

				nextOpenIdx--
			}
		}
	}
}

func (p *Platform) SlideEast() {
	for row := 0; row < len(p.board); row++ {
		nextOpenIdx := len(p.board[row]) - 1
		for col := len(p.board[row]) - 1; col >= 0; col-- {
			nextChar := p.board[row][col]
			if nextChar == '#' {
				nextOpenIdx = col - 1
			} else if nextChar == 'O' {
				p.board[row][col] = '.'
				p.board[row][nextOpenIdx] = 'O'

				nextOpenIdx--
			}
		}
	}
}
func (p *Platform) SlideWest() {
	for row := 0; row < len(p.board); row++ {
		nextOpenIdx := 0
		for col := 0; col < len(p.board[row]); col++ {
			nextChar := p.board[row][col]
			if nextChar == '#' {
				nextOpenIdx = col + 1
			} else if nextChar == 'O' {
				p.board[row][col] = '.'
				p.board[row][nextOpenIdx] = 'O'

				nextOpenIdx++
			}
		}
	}
}

func (p *Platform) SpinCycle() {
	p.SlideNorth()
	// fmt.Println(p.String())
	p.SlideWest()
	// fmt.Println(p.String())
	p.SlideSouth()
	// fmt.Println(p.String())
	p.SlideEast()
}

func (p *Platform) RepeatSpin(times int) {
	cycleMap := make(map[string]int)

	for i := 0; i < times; i++ {
		p.SpinCycle()
		hash := p.Hash()

		if prevCycle, ok := cycleMap[hash]; ok {
			period := i - prevCycle
			remaining := times - i
			offset := remaining%period - 1
			// fmt.Printf("Cycle: %d -> %d (times offset: %d)\n", prevCycle, i, offset)
			p.RepeatSpin(offset)
			return
		} else {
			cycleMap[hash] = i
		}
	}
}
