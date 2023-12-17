

SRC_DIR = src
SRC_EXT=pl

PART1_SRC_FILE = part1.$(SRC_EXT)
PART2_SRC_FILE = part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))

# Runtime
RUNTIME := docker run -it --rm --name=AoC-Day4 -v "$(shell pwd):/app:rw" -w /app perl:5.34 perl

.PHONY: build clean run run_p1 run_p2 test_p1 test_p2



run: | run_p1 run_p2

test_p1:
	$(RUNTIME) $(PART1_SRC_PATH) test.txt
run_p1:
	@$(RUNTIME) $(PART1_SRC_PATH) input.txt

test_p2:
	$(RUNTIME) $(PART2_SRC_PATH) test.txt
run_p2:
	@$(RUNTIME) $(PART2_SRC_PATH) input.txt
