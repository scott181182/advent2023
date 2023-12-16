package day02

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.util.function.Predicate;

import day02.game.Game



fun throwIsSubset(minThrow: Map<String, Int>, prompt: Map<String, Int>): Boolean {
    return prompt.entries.toList().all{ (color, amount) ->
        minThrow.getOrDefault(color, 0) <= amount
    }
}


val PROMPT = mapOf("red" to 12, "green" to 13, "blue" to 14)

fun main(args: Array<String>) {
    val filepath = FileSystems.getDefault().getPath(args[0]);

    try {
        val games = Files.lines(filepath)
            .filter(Predicate.not(String::isEmpty))
            .map(Game::parse)
            .filter{ game -> throwIsSubset(game.minimalThrow(), PROMPT) }
            .toList()
        
        val total = games.fold(0, {acc, game -> acc + game.id})

        System.out.format("Part 1 Total: %d\n", total);
    } catch (ioe: IOException) {
        ioe.printStackTrace();
    }
}