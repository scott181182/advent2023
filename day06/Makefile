


SRC_DIR = src
SRC_EXT = cpp
OUT_DIR = out

PART1_SRC_FILE = part1.$(SRC_EXT)
PART2_SRC_FILE = part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))

PART1_OUT_PATH = $(PART1_SRC_PATH:$(SRC_DIR)/%.$(SRC_EXT)=$(OUT_DIR)/%)
PART2_OUT_PATH = $(PART2_SRC_PATH:$(SRC_DIR)/%.$(SRC_EXT)=$(OUT_DIR)/%)

# Compiler
COMPILER := docker compose run -it --rm cpp clang++
COMPILER_OPTS := -Wall -Wextra
# Runtime
RUNTIME := docker run -it --rm --name=AoC-Day6 -v "$(shell pwd):/app:rw" -w /app ubuntu:22.04

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

clean:
	rm -f $(OUT_DIR)/* && touch $(OUT_DIR)/.keep

$(PART1_OUT_PATH): $(PART1_SRC_PATH)
	$(COMPILER) $(COMPILER_OPTS) -o $@ $<
$(PART2_OUT_PATH): $(PART2_SRC_PATH)
	$(COMPILER) $(COMPILER_OPTS) -o $@ $<
