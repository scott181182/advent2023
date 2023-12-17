require "./Schematic.cr"



schematic = Schematic.parse ARGV[0]
# schematic.parts.each{ |p|
#     puts span_neighbors(p)
# }
puts "Parts in Schematic: #{schematic.parts.size}"
puts "Symbols in Schematic: #{schematic.symbol_map.size}"

total = schematic.parts.reduce(0){ |acc, span| acc + span.num }
puts "Part 1 total: #{total}"
