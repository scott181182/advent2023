package day02.game

import java.util.regex.Pattern
import kotlin.math.max



private val GAME_PATTERN = Pattern.compile("^Game (\\d+):(.*)$")
private val THROW_PATTERN = Pattern.compile("(\\d+) (\\w+)")

private fun parseCubeThrow(str: String): Pair<String, Int> {
    val throwMatch = THROW_PATTERN.matcher(str);
    if(!throwMatch.matches()) {
        System.err.format("No throw found in string: '%s'\n", str);
    }

    return Pair(throwMatch.group(2)!!, Integer.parseInt(throwMatch.group(1)))
}
private fun parseSubGame(str: String): Map<String, Int> {
    return str.split(",")
        .map(String::trim)
        .associate(::parseCubeThrow);
}

private fun reduceShowings(min: Map<String, Int>, showing: Map<String, Int>): Map<String, Int> {
    return showing.entries.toList().fold(min, { acc, (color, amount) -> 
        acc + Pair(color, max(amount, acc.getOrDefault(color, 0)))   
    })
}



class Game(
    val id: Int,
    val showings: List<Map<String, Int>>
) {
    companion object {
        fun parse(line: String): Game {
            val gameMatch = GAME_PATTERN.matcher(line);
            if(!gameMatch.matches()) {
                System.err.format("No game found on line: '%s'\n", line);
            }

            val id = Integer.parseInt(gameMatch.group(1));
            val subgames = gameMatch.group(2).split(";")
                .map(String::trim)
                .map(::parseSubGame);

            return Game(id, subgames)
        }
    }

    override fun toString(): String {
        return "Game#${this.id}(${this.showings.toString()})"
    }

    fun minimalThrow(): Map<String, Int> {
        return this.showings.reduce(::reduceShowings)
    }
}




