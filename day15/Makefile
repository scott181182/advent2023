


SRC_DIR = src
SRC_EXT = ts

PART1_SRC_FILE = part1.$(SRC_EXT)
PART2_SRC_FILE = part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))

# Runtime
RUNTIME := docker run -it --rm --name=AoC-Day15 -v "$(shell pwd):/app:rw" -w /app oven/bun:1.1.1-distroless run
TEST_RUNTIME := docker run -it --rm --name=AoC-Day15 -v "$(shell pwd):/app:rw" -w /app oven/bun:1.1.1-distroless test

.PHONY: run run_p1 run_p2 test_p1 test_p2 unit



run: | run_p1 run_p2

unit: $(PART1_SRC_PATH) $(PART2_SRC_PATH)
	$(TEST_RUNTIME)

test_p1: $(PART1_SRC_PATH)
	$(RUNTIME) $(PART1_SRC_PATH) test.txt
run_p1: $(PART1_SRC_PATH)
	@$(RUNTIME) $(PART1_SRC_PATH) input.txt

test_p2: $(PART2_SRC_PATH)
	$(RUNTIME) $(PART2_SRC_PATH) test.txt
run_p2: $(PART2_SRC_PATH)
	@$(RUNTIME) $(PART2_SRC_PATH) input.txt
