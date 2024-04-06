package src

import src.City



class Main {
    public static void main(String... args) {
        def filepath = args[0]
        def city = City.parseFile(filepath)
        println "City(${city.width}x${city.height})"

        def firstEdges = city.graph.getOutwardEdges("0,0")
        for (edge in firstEdges) {
            println edge.toString()
        }

        def badAnswer = city.graph.shortestPath("0,0", "${city.width - 1},${city.height - 1}")
        println "Not Answer: ${badAnswer}"

        def answer = city.shortestCruciblePath("0,0", "${city.width - 1},${city.height - 1}")
        println "Answer: ${answer}"
    }
}