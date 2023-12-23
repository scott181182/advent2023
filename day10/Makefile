


SRC_DIR = src
SRC_EXT = lua

PART1_SRC_FILE = part1.$(SRC_EXT)
PART2_SRC_FILE = part2.$(SRC_EXT)
PART1_SRC_PATH = $(PART1_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))
PART2_SRC_PATH = $(PART2_SRC_FILE:%.$(SRC_EXT)=$(SRC_DIR)/%.$(SRC_EXT))

# Runtime
RUNTIME := docker run -it --rm --name=AoC-Day10 -v "$(shell pwd):/app:rw" -e LUA_PATH="./src/?.lua;;" -w /app nickblah/luajit:2.0.5 luajit

.PHONY: run run_p1 run_p2 test_p1 test_p1_1 test_p1_2 test_p2



run: | run_p1 run_p2

test_p1: | test_p1_1 test_p1_2
test_p1_1: $(PART1_SRC_PATH)
	$(RUNTIME) $(PART1_SRC_PATH) test1.txt
test_p1_2: $(PART1_SRC_PATH)
	$(RUNTIME) $(PART1_SRC_PATH) test2.txt
run_p1: $(PART1_SRC_PATH)
	@$(RUNTIME) $(PART1_SRC_PATH) input.txt

test_p2: | test_p2_1 test_p2_2 test_p2_3 test_p2_4
test_p2_1: $(PART2_SRC_PATH)
	$(RUNTIME) $(PART2_SRC_PATH) test3.txt
test_p2_2: $(PART2_SRC_PATH)
	$(RUNTIME) $(PART2_SRC_PATH) test4.txt
test_p2_3: $(PART2_SRC_PATH)
	$(RUNTIME) $(PART2_SRC_PATH) test5.txt
test_p2_4: $(PART2_SRC_PATH)
	$(RUNTIME) $(PART2_SRC_PATH) test6.txt
run_p2: $(PART2_SRC_PATH)
	@$(RUNTIME) $(PART2_SRC_PATH) input.txt
