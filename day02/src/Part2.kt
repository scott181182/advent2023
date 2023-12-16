package day02

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.util.function.Predicate;

import day02.game.Game



fun throw2power(minThrow: Map<String, Int>): Int {
    return minThrow.values.toList().fold(1, Int::times)
}



fun main(args: Array<String>) {
    val filepath = FileSystems.getDefault().getPath(args[0]);

    try {
        val total = Files.lines(filepath)
            .filter(Predicate.not(String::isEmpty))
            .map(Game::parse)
            .map(Game::minimalThrow)
            .map(::throw2power)
            .toList()
            .fold(0, Int::plus)

        System.out.format("Part 2 Total: %d\n", total);
    } catch (ioe: IOException) {
        ioe.printStackTrace();
    }
}