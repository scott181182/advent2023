import argparse

from src.grid import Coord, Direction, Grid, LaserInstance




def main(filepath: str):
    grid = Grid.parse_file(filepath)
    
    laser = LaserInstance(Coord(0, 0), Direction.RIGHT)
    answer = grid.count_energized_cells(laser)
    
    print(f"Answer: {answer}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Advent of Code 2023 - Day 16")
    parser.add_argument("filepath")

    args = parser.parse_args()
    main(args.filepath)