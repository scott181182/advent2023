package src

import java.util.function.Predicate
import java.util.stream.Collectors



class Graph<T> {
    private HashMap<String, GraphNode<T>> nodes

    public Graph() {
        this.nodes = new HashMap<>();
    }

    public GraphNode<T> addNode(String label, T value) {
        def node = new GraphNode<>(this, label, value)
        this.nodes.put(label, node)
        return node
    }
    public GraphEdge<T> addEdge(String fromLabel, String toLabel, int cost, Direction dir) {
        def from = this.nodes.get(fromLabel)
        def to = this.nodes.get(toLabel)
        return this.addEdge(from, to, cost, dir)
    }
    public GraphEdge<T> addEdge(GraphNode<T> from, GraphNode<T> to, int cost, Direction dir) {
        def edge = new GraphEdge<>(from: from, to: to, cost: cost, direction: dir)
        from.outwardEdges.add(edge)
        return edge
    }

    public List<GraphEdge<T>> getOutwardEdges(String nodeLabel) {
        def node = this.nodes.get(nodeLabel)
        return node.outwardEdges
    }



    public int shortestPath(String fromLabel, String toLabel) {
        def from = this.nodes.get(fromLabel)

        def distances = new HashMap<GraphNode<T>, Integer>()
        def previous = new HashMap<GraphNode<T>, GraphNode<T>>()
        def queue = new PriorityQueue<CandidateNode>()
        distances.put(from, 0)
        queue.add(new CandidateNode(from, 0))

        while(!queue.isEmpty()) {
            def next = queue.poll()

            if(next.node.label == toLabel) {
                return next.priority
            }

            for(edge in next.node.outwardEdges) {
                def dist = next.priority + edge.cost

                if(!distances.containsKey(edge.to)) {
                    previous.put(edge.from, edge.to)
                    distances.put(edge.to, dist)
                    queue.add(new CandidateNode(edge.to, dist))
                } else if(dist < distances.get(edge.to)) {
                    previous.put(edge.from, edge.to)
                    distances.put(edge.to, dist)
                    queue.remove(edge.to)
                    queue.add(new CandidateNode(edge.to, dist))
                }
            }
        }
    }

    private class CandidateNode implements Comparable<CandidateNode>{
        GraphNode<T> node
        int priority

        public CandidateNode(GraphNode<T> node, int priority) {
            this.node = node
            this.priority = priority
        }

        @Override
        public int compareTo(CandidateNode other) {
            return Integer.compare(this.priority, other.priority);
        }

        @Override
        public boolean equals(Object other) {
            if(other instanceof CandidateNode) {
                return this.node == other.node
            }
            if(other instanceof GraphNode<T>) {
                return this.node == other
            }
            return false
        }
    }
}

class GraphNode<T> {
    String label
    Graph<T> graph
    T value

    ArrayList<GraphEdge<T>> outwardEdges

    public GraphNode(Graph graph, String label, T value) {
        this.graph = graph
        this.label = label
        this.value = value
        this.outwardEdges = new ArrayList<>()
    }

    String toString() {
        return this.label
    }
}

enum Direction {
    UP(Direction.DOWN),
    DOWN(Direction.UP),
    LEFT(Direction.RIGHT),
    RIGHT(Direction.LEFT)

    public Direction opposite

    private Direction(Direction opposite) {
        this.opposite = opposite
    }
}
class GraphEdge<T> {
    GraphNode<T> from
    GraphNode<T> to

    int cost
    Direction direction

    String toString() {
        return "Edge(${from.label} -> ${to.label}, ${direction}, ${cost})"
    }
}