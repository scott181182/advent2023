


SRC_DIR = src
SRC_EXT = hs

PART1_SRC_FILE = Part1.$(SRC_EXT)
PART2_SRC_FILE = Part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))

# Runtime
RUNTIME := docker run -it --rm --name=AoC-Day8 -v "$(shell pwd):/app:rw" -v "$(shell pwd)/configs/cabal:/root/.cabal:rw" -v "$(shell pwd)/configs/ghc:/root/.ghc:rw" -w /app haskell:9.8.1 cabal run
RUNTIME_OPTS := -v0
.PHONY: run run_p1 run_p2 test_p1 test_p2



run: | run_p1 run_p2

test_p1: | test_p1_1 test_p1_2
	$(RUNTIME) $(RUNTIME_OPTS) part1 test1.txt
	$(RUNTIME) $(RUNTIME_OPTS) part1 test2.txt
test_p1_1: $(PART1_SRC_PATH)
	$(RUNTIME) $(RUNTIME_OPTS) part1 test1.txt
test_p1_2: $(PART1_SRC_PATH)
	$(RUNTIME) $(RUNTIME_OPTS) part1 test2.txt
run_p1: $(PART1_SRC_PATH)
	@$(RUNTIME) $(RUNTIME_OPTS) part1 input.txt

test_p2: $(PART2_SRC_PATH)
	$(RUNTIME) $(RUNTIME_OPTS) part2 test3.txt
run_p2: $(PART2_SRC_PATH)
	@$(RUNTIME) $(RUNTIME_OPTS) part2 input.txt
