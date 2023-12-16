


record Coord, x : Int32, y : Int32
record PartSpan, start : Coord, width : Int32, num : Int32
record PartSymbol, loc : Coord, sym : Char

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

        parts = Array(PartSpan).new
        symbol_map = Hash(String, PartSymbol).new

        current_start = -1
        current_width = 0
        buf = ""
        lines.each_with_index do |line, y|
            line.each_char_with_index do |c, x|
                if c == '.'
                    if buf.size > 0
                        # Period at the end of a number should end the number
                        parts.push PartSpan.new(Coord.new(current_start, y), current_width, buf.to_i)
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
                        parts.push PartSpan.new(Coord.new(current_start, y), current_width, buf.to_i)
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
                parts.push PartSpan.new(Coord.new(current_start, y), current_width, buf.to_i)
                current_start = -1
                current_width = 0
                buf = ""
            end
        end

        Schematic.new(parts, symbol_map)
    end

    def parts
        @parts
    end
    def symbol_map
        @symbol_map
    end



    def valid_parts : Array(PartSpan)
        @parts.select{ |p|
            span_neighbors(p)
                .map{ |coord| coord2string(coord) }
                .any?{ |key|
                    @symbol_map.has_key? key
                }
        }
    end
end



schematic = Schematic.parse ARGV[0]
# schematic.parts.each{ |p|
#     puts span_neighbors(p)
# }
puts "Numbers in Schematic: #{schematic.parts.size}"
puts "Symbols in Schematic: #{schematic.symbol_map.size}"
puts "Valid Parts in Schematic: #{schematic.valid_parts.size}"

total = schematic.valid_parts.reduce(0){ |acc, span| acc + span.num }
puts "Part 1 total: #{total}"
