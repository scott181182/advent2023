import argparse

from src.grid import Coord, Direction, Grid, LaserInstance




def main(filepath: str):
    grid = Grid.parse_file(filepath)
    
    max_energized = 0
    count = 0
    max_config = None

    def try_laser(x: int, y: int, dir: Direction):
        nonlocal count
        nonlocal max_energized
        nonlocal max_config

        laser = LaserInstance(Coord(x, y), dir)
        count = grid.count_energized_cells(laser)
        if count > max_energized:
            max_energized = count
            max_config = (Coord(x, y), dir)

    for x in range(grid.width):
        try_laser(x, 0, Direction.DOWN)
        try_laser(x, grid.height - 1, Direction.UP)

    for y in range(grid.height):
        try_laser(0, y, Direction.RIGHT)
        try_laser(grid.width - 1, y, Direction.LEFT)
    
    print(f"Answer: {max_energized}")
    print(max_config)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Advent of Code 2023 - Day 16")
    parser.add_argument("filepath")

    args = parser.parse_args()
    main(args.filepath)