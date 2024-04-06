package src

import src.Graph



class Coord {
    int x, y

    public Coord(int x, int y) {
        this.x = x
        this.y = y
    }

    public int distance(Coord other) {
        return Math.abs(this.x - other.x) + Math.abs(this.y - other.y)
    }
}

class City {
    Graph<Coord> graph
    int width, height

    private City(Graph graph, int width, int height) {
        this.graph = graph
        this.width = width
        this.height = height
    }

    static City parseFile(String filepath) {
        def graph = new Graph<>()
        def lines = new File(filepath).text.readLines()

        // Create Graph nodes.
        for(int i = 0; i < lines.size(); i++) {
            for(int j = 0; j < lines[i].length(); j++) {
                graph.addNode("${j},${i}", new Coord(j, i))
            }
        }
        // Create Graph edges.
        for(int i = 0; i < lines.size(); i++) {
            for(int j = 0; j < lines[i].length(); j++) {
                def label = "${j},${i}"
                def cost = lines[i][j].toInteger()
                if(i > 0) {
                    // Add top edge.
                    graph.addEdge("${j},${i-1}", label, cost, Direction.DOWN)
                }
                if(i < lines.size() - 1) {
                    // Add bottom edge.
                    graph.addEdge("${j},${i+1}", label, cost, Direction.UP)
                }
                if(j > 0) {
                    // Add left edge.
                    graph.addEdge("${j-1},${i}", label, cost, Direction.RIGHT)
                }
                if(j < lines[i].length() - 1) {
                    // Add right edge.
                    graph.addEdge("${j+1},${i}", label, cost, Direction.LEFT)
                }
            }
        }

        return new City(graph, lines[0].length(), lines.size())
    }



    public int shortestCruciblePath(String fromLabel, String toLabel) {
        def from = this.graph.nodes.get(fromLabel)
        def to = this.graph.nodes.get(toLabel)

        def distances = new HashMap<CandidateBlock, Integer>()
        def explored = new HashSet<CandidateBlock>()
        def queue = new PriorityQueue<CandidateBlock>()
        def first = new CandidateBlock(from, Direction.DOWN, 1, 0, to.value.distance(from.value))
        distances.put(first, 0)
        queue.add(first)

        while(!queue.isEmpty()) {
            def next = queue.poll()
            if(explored.contains(next)) { continue }
            explored.add(next)

            if(next.node.label == toLabel) {
                return next.distance
            }

            for(edge in next.node.outwardEdges) {
                // Disallow double-backs.
                if(edge.direction == next.direction.opposite) { continue }
                // Disallow long chains.
                if(edge.direction == next.direction && next.longestChain >= 3) { continue }

                def dist = next.distance + edge.cost

                def candidate = new CandidateBlock(
                    edge.to,
                    edge.direction,
                    edge.direction == next.direction ? next.longestChain + 1 : 1,
                    dist,
                    to.value.distance(edge.to.value)
                )
                if(!queue.contains(candidate)) {
                    distances.put(candidate, dist)
                    queue.add(candidate)
                }
                // if(dist < distances.get(edge.to)) {
                //     distances.put(candidate, dist)
                // }
            }
        }
    }

    private class CandidateBlock implements Comparable<CandidateBlock>{
        GraphNode<Coord> node
        Direction direction
        int longestChain
        int distance
        int heuristic

        public CandidateBlock(GraphNode<Coord> node, Direction direction, int longestChain, int distance, int heuristic) {
            this.node = node
            this.direction = direction
            this.longestChain = longestChain
            this.distance = distance
            this.heuristic = heuristic
        }

        @Override
        public int compareTo(CandidateBlock other) {
            return Integer.compare(this.distance + this.heuristic, other.distance + other.heuristic);
        }

        @Override
        public boolean equals(Object other) {
            if(other instanceof CandidateBlock) {
                return this.node == other.node && this.longestChain >= other.longestChain && this.direction == other.direction
            }
            return false
        }
    }
}