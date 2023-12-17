
record Coord, x : Int32, y : Int32
record PartSpan, start : Coord, width : Int32, num : Int32

class PartSymbol
    def initialize(@loc : Coord, @sym : Char)
        @neighbors = Array(PartSpan).new
    end


    def loc
        @loc
    end
    def sym
        @sym
    end
    def neighbors
        @neighbors
    end

    def add_neighbor(part : PartSpan)
        @neighbors.push part
    end
end

def span_neighbors(span : PartSpan) : Array(Coord)
    neighbors = Array(Coord).new

    neighbors.concat ((span.start.x - 1)..(span.start.x + span.width)).map{ |x| Coord.new(x, span.start.y - 1) }
    neighbors.push Coord.new(span.start.x - 1, span.start.y)
    neighbors.push Coord.new(span.start.x + span.width, span.start.y)
    neighbors.concat ((span.start.x - 1)..(span.start.x + span.width)).map{ |x| Coord.new(x, span.start.y + 1) }

    neighbors
end
def coord2string(coord : Coord) : String
    "#{coord.x},#{coord.y}"
end



class Schematic
    def initialize(@parts : Array(PartSpan), @symbol_map : Hash(String, PartSymbol))
    end

    def Schematic.parse(filename : String) : Schematic
        lines = File.read_lines filename

        candidate_parts = Array(PartSpan).new
        symbol_map = Hash(String, PartSymbol).new

        current_start = -1
        current_width = 0
        buf = ""
        lines.each_with_index do |line, y|
            line.each_char_with_index do |c, x|
                if c == '.'
                    if buf.size > 0
                        # Period at the end of a number should end the number
                        candidate_parts.push PartSpan.new(Coord.new(current_start, y), current_width, buf.to_i)
                        current_start = -1
                        current_width = 0
                        buf = ""
                    end
                elsif c.number?
                    buf += c
                    current_width += 1
                    if current_start == -1
                        current_start = x
                    end
                else
                    if buf.size > 0
                        # Symbol at the end of a number should end the number
                        candidate_parts.push PartSpan.new(Coord.new(current_start, y), current_width, buf.to_i)
                        current_start = -1
                        current_width = 0
                        buf = ""
                    end

                    coord = Coord.new(x, y)

                    symbol_map[coord2string(coord)] = PartSymbol.new(coord, c)
                end
            end

            # Number at the end of a line.
            if buf.size > 0
                # Symbol at the end of a number should end the number
                candidate_parts.push PartSpan.new(Coord.new(current_start, y), current_width, buf.to_i)
                current_start = -1
                current_width = 0
                buf = ""
            end
        end

        # Filter actual parts
        parts = candidate_parts.select{ |p|
            span_neighbors(p)
                .map{ |coord| coord2string(coord) }
                .reduce(false){ |acc, key|
                    if symbol_map.has_key? key
                        symbol_map[key].add_neighbor p
                        true
                    else
                        acc || false
                    end
                }
        }

        Schematic.new(parts, symbol_map)
    end

    def parts
        @parts
    end
    def symbol_map
        @symbol_map
    end



    def gears : Array(PartSymbol)
        @symbol_map.values.select{ |sym|
            sym.sym == '*' && sym.neighbors.size == 2
        }
    end
end
