# Advent of Code 2023

Repository for my solutions to [Advent of Code 2023](https://adventofcode.com/2023/).

## Approach

Each day I'll be spinning a [wheel of names](https://wheelofnames.com/) to determine what programming language (or similar) I'll use to solve those problems. The candidate languages are as follows:

- Java ([Day 1](./day01/README.md))
- Ruby
- Prolog
- Haskell
- Go
- Processing
- Perl
- MatLab
- C++
- Assembly
- C
- TypeScript
- Racket
- Bash
- Crystal
- Groovy
- Lua
- Kotlin
- Blockly
- PureScript
- C#
- PHP
- Rust
- Clojure
- JavaScript
- Python
- Forth

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
