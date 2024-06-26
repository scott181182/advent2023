# Advent of Code 2023

Repository for my solutions to [Advent of Code 2023](https://adventofcode.com/2023/).

## Approach

Each day I'll be spinning a [wheel of names](https://wheelofnames.com/) to determine what programming language (or similar) I'll use to solve those problems. The candidate languages are as follows:

- Java ([Day 1](./day01/README.md))
- Kotlin ([Day 2](./day02/README.md))
- Crystal ([Day 3](./day03/README.md))
- Perl ([Day 4](./day04/README.md))
- PureScript ([Day 5](./day05/README.md))
- C++ ([Day 6](./day06/README.md))
- Ruby ([Day 7](./day07/README.md))
- Haskell ([Day 8](./day08/README.md))
- MatLab ([Day 9](./day09/README.md))
- Lua ([Day 10](./day10/README.md))
- Bash ([Day 11](./day11/README.md))
- Processing ([Day 12](./day12/README.md))
- C# ([Day 13](./day13/README.md))
- Go ([Day 14](./day14/README.md))
- TypeScript ([Day 15](./day15/README.md))
- Python ([Day 16](./day16/README.md))
- Groovy ([Day 17](./day17/README.md))
- Prolog
- Assembly
- C
- Racket
- Blockly
- PHP
- Rust
- Clojure
- JavaScript
- Forth

My goal isn't to make the most optimized solution each day, but to make a fun solution in the given language and keep
the code looking _good enough_.

## Setup

Since each of these languages will introduce their own mess of language support and libraries, I'll be using Docker to
run and (if applicable) build the code for each of my challenge solutions. To common-ize the execution, each day will
have its own `Makefile` for running their respective commands in a Docker container and printing the output.
Specifically, the following commands can be used:

```sh
# Run both parts of a day's challenge.
make run

# Run either part separately.
make run_p1
make run_p2

# If the language/framework involves a build or compilation step, the following will also be available.
# It being make, it will also automatically build code for the `run` targets as necessary.
make build
make clean
```
