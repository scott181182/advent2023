

SRC_DIR = src

PART1_SRC_FILE = part1.cr
PART2_SRC_FILE = part2.cr

PART1_SRC_PATH = $(PART1_SRC_FILE:%.cr=$(SRC_DIR)/%.cr)
PART2_SRC_PATH = $(PART2_SRC_FILE:%.cr=$(SRC_DIR)/%.cr)

# Runtime
CR := docker run -it --rm --name=AoC-Day3 -v "$(shell pwd):/app:rw" -w /app crystallang/crystal:1.10.1 crystal

.PHONY: build clean run run_p1 run_p2 test_p1 test_p2



run: | run_p1 run_p2

test_p1:
	$(CR) $(PART1_SRC_PATH) test.txt
run_p1:
	@$(CR) $(PART1_SRC_PATH) input.txt

test_p2:
	$(CR) $(PART2_SRC_PATH) test.txt
run_p2:
	@$(CR) $(PART2_SRC_PATH) input.txt
