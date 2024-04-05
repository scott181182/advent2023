SRC_DIR = Part1
SRC_EXT = pde

PART1_SRC_FILE = Part1.$(SRC_EXT)
PART2_SRC_FILE = Part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=Part1/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=Part2/%.$(SRC_EXT))

# Runtime
RUNTIME := docker compose run -it --rm processing
RUNTIME_PART1 := $(RUNTIME) --sketch="Part1" --run
RUNTIME_PART2 := $(RUNTIME) --sketch="Part2" --run
.PHONY: run run_p1 run_p2 test_p1 test_p2



run: | run_p1 run_p2

test_p1:
	$(RUNTIME_PART1) test1.txt
run_p1: $(PART1_SRC_PATH)
	@$(RUNTIME_PART1) input.txt

test_p2: $(PART2_SRC_PATH)
	$(RUNTIME_PART2) test1.txt
run_p2: $(PART2_SRC_PATH)
	@$(RUNTIME_PART2) input.txt
