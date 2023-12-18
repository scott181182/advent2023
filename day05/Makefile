


SRC_DIR = src
SRC_EXT = purs
OUT_DIR = dist
OUT_EXT = mjs

PART1_SRC_FILE = Part1.$(SRC_EXT)
PART2_SRC_FILE = Part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))

PART1_OUT_PATH = $(PART1_SRC_PATH:$(SRC_DIR)/%.$(SRC_EXT)=$(OUT_DIR)/%.$(OUT_EXT))
PART2_OUT_PATH = $(PART2_SRC_PATH:$(SRC_DIR)/%.$(SRC_EXT)=$(OUT_DIR)/%.$(OUT_EXT))

# Compiler
COMPILER := docker compose run -it --rm purescript spago bundle-app
COMPILER_OPTS := --platform node
# Runtime
RUNTIME := docker run -it --rm --name=AoC-Day5 -v "$(shell pwd):/app:rw" -w /app node:20 node

.PHONY: build clean run run_p1 run_p2 test_p1 test_p2



run: | run_p1 run_p2

test_p1: $(PART1_OUT_PATH)
	$(RUNTIME) $(PART1_OUT_PATH) test.txt
run_p1: $(PART1_OUT_PATH)
	@$(RUNTIME) $(PART1_OUT_PATH) input.txt

test_p2: $(PART2_OUT_PATH)
	$(RUNTIME) $(PART2_OUT_PATH) test.txt
run_p2: $(PART2_OUT_PATH)
	@$(RUNTIME) $(PART2_OUT_PATH) input.txt

build:
	$(COMPILER) $(COMPILER_OPTS)
clean:
	rm -f $(OUT_DIR)/*.$(OUT_EXT)

$(PART1_OUT_PATH): $(PART1_SRC_PATH)
	$(COMPILER) $(COMPILER_OPTS) --to $@ --main Part1
$(PART2_OUT_PATH): $(PART2_SRC_PATH)
	$(COMPILER) $(COMPILER_OPTS) --to $@ --main Part2
