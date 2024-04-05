


SRC_DIR = src
SRC_EXT = py

PART1_SRC_FILE = part1.$(SRC_EXT)
PART2_SRC_FILE = part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))

# Runtime
RUNTIME := docker run -it --rm --name=AoC-Day16 -v "$(shell pwd):/app:rw" -w /app python:3.12-alpine python

.PHONY: run run_p1 run_p2 test_p1 test_p2 unit



run: | run_p1 run_p2

test_p1: $(PART1_SRC_PATH)
	$(RUNTIME) -m src.part1 test.txt
run_p1: $(PART1_SRC_PATH)
	@$(RUNTIME) -m src.part1 input.txt

test_p2: $(PART2_SRC_PATH)
	$(RUNTIME) -m src.part2 test.txt
run_p2: $(PART2_SRC_PATH)
	@$(RUNTIME) -m src.part2 input.txt
