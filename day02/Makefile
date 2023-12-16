

SRC_DIR = src
OUT_DIR = out

PART1_SRC_FILES = Game.kt Part1.kt
PART2_SRC_FILES = Game.kt Part2.kt
OUT_PART1 = $(OUT_DIR)/Part1.jar
OUT_PART2 = $(OUT_DIR)/Part2.jar

PART1_SRC_PATHS = $(PART1_SRC_FILES:%.kt=$(SRC_DIR)/%.kt)
PART2_SRC_PATHS = $(PART2_SRC_FILES:%.kt=$(SRC_DIR)/%.kt)
JAR_FILES = $(OUT_PART1) $(OUT_PART2)

# Compiler
KC := docker compose run -it --rm kotlin kotlinc
# Runtime
JR := docker run -it --rm --name=AoC-Day2 -v "$(shell pwd):/app:rw" -w /app eclipse-temurin:21 java -jar
# Compile Flags
KCFLAGS := -include-runtime

.PHONY: build clean run run_p1 run_p2 test_p1 test_p2



run: | run_p1 run_p2

test_p1: $(OUT_PART1)
	$(JR)  $(OUT_PART1) test.txt
run_p1: $(OUT_PART1)
	@$(JR)  $(OUT_PART1) input.txt

test_p2: $(OUT_PART2)
	$(JR) $(OUT_PART2) test.txt
run_p2: $(OUT_PART2)
	@$(JR) $(OUT_PART2) input.txt

build: $(JAR_FILES)
clean:
	rm -f $(OUT_DIR)/*.jar

$(OUT_PART1): $(PART1_SRC_PATHS)
	$(KC) $(KCFLAGS) -d $@ $(PART1_SRC_PATHS)
$(OUT_PART2): $(PART2_SRC_PATHS)
	$(KC) $(KCFLAGS) -d $@ $(PART2_SRC_PATHS)
