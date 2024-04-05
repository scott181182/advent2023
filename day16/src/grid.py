from dataclasses import dataclass
from enum import Enum




Direction = Enum("Direction", ["UP", "RIGHT", "DOWN", "LEFT"])

@dataclass
class Coord:
    x: int
    y: int

    def next(self, dir: Direction) -> "Coord":
        if dir == Direction.UP:
            return Coord(self.x, self.y - 1)
        elif dir == Direction.DOWN:
            return Coord(self.x, self.y + 1)
        elif dir == Direction.LEFT:
            return Coord(self.x - 1, self.y)
        elif dir == Direction.RIGHT:
            return Coord(self.x + 1, self.y)
    def __str__(self) -> str:
        return f"({self.x},{self.y})"

@dataclass
class LaserInstance:
    position: Coord
    direction: Direction



@dataclass
class Grid:
    board: list[list[str]]
    width: int
    height: int

    @staticmethod
    def parse_file(filepath: str) -> "Grid":
        with open(filepath, "r") as input_file:
            lines = input_file.readlines()
        return Grid(
            # Gotta cut off the newlines.
            [ list(line.strip()) for line in lines ],
            len(lines[0].strip()),
            len(lines)
        )
    
    def count_energized_cells(self, laser: LaserInstance) -> int:
        cell_map = dict()
        self.simulate_laser(laser, cell_map)
        return len(cell_map)

    def simulate_laser(self, laser: LaserInstance, energized_tiles: dict[str, set[Direction]]):
        while laser.position.x >= 0 and laser.position.x < self.width and \
              laser.position.y >= 0 and laser.position.y < self.height:
            
            # Mark tile as energized, and do some checks to avoid loops.
            coord_str = str(laser.position)
            if coord_str in energized_tiles:
                if laser.direction in energized_tiles[coord_str]:
                    # We've been here before in the same direction, so loop!
                    return
                else:
                    energized_tiles[coord_str].add(laser.direction)
            else:
                energized_tiles[coord_str] = set([laser.direction])

            # Let's see where we go next!
            tile = self.board[laser.position.y][laser.position.x]
            if tile == "/":
                if laser.direction == Direction.RIGHT:
                    laser.direction = Direction.UP
                elif laser.direction == Direction.UP:
                    laser.direction = Direction.RIGHT
                elif laser.direction == Direction.LEFT:
                    laser.direction = Direction.DOWN
                elif laser.direction == Direction.DOWN:
                    laser.direction = Direction.LEFT
            elif tile == "\\":
                if laser.direction == Direction.RIGHT:
                    laser.direction = Direction.DOWN
                elif laser.direction == Direction.DOWN:
                    laser.direction = Direction.RIGHT
                elif laser.direction == Direction.LEFT:
                    laser.direction = Direction.UP
                elif laser.direction == Direction.UP:
                    laser.direction = Direction.LEFT
            elif tile == "-":
                if laser.direction == Direction.UP or laser.direction == Direction.DOWN:
                    # Split to the left
                    self.simulate_laser(LaserInstance(
                        laser.position.next(Direction.LEFT),
                        Direction.LEFT
                    ), energized_tiles)
                    # Continue rightward in this call frame
                    laser.direction = Direction.RIGHT
            elif tile == "|":
                if laser.direction == Direction.LEFT or laser.direction == Direction.RIGHT:
                    # Split downwards
                    self.simulate_laser(LaserInstance(
                        laser.position.next(Direction.DOWN),
                        Direction.DOWN
                    ), energized_tiles)
                    # Continue upward in this call frame
                    laser.direction = Direction.UP

            laser.position = laser.position.next(laser.direction)



