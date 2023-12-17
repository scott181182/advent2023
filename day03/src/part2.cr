require "./Schematic.cr"



schematic = Schematic.parse ARGV[0]

total = schematic.gears
    .map{ |g| g.neighbors.reduce(1){ |acc, n| acc * n.num } }
    .sum
puts "Part 2 total: #{total}"
