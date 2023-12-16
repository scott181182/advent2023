

SRC_DIR = src
OUT_DIR = out
SRC_FILES = $(wildcard $(SRC_DIR)/*.java)
CLS_FILES = $(SRC_FILES:$(SRC_DIR)/%.java=$(OUT_DIR)/%.class)

# Compiler
JC := docker run -it --rm --name=AoC-Day1 -v "$(shell pwd):/app:rw" -w /app eclipse-temurin:21 javac
# Runtime
JR := docker run -it --rm --name=AoC-Day1 -v "$(shell pwd):/app:rw" -w /app/out eclipse-temurin:21 java
# Compile Flags
JCFLAGS := -d $(OUT_DIR)/ -cp $(SRC_DIR)/

.PHONY: build clean run run_p1 run_p2 test_p1 test_p2


run: | run_p1 run_p2

test_p1: $(CLS_FILES)
	$(JR) Part1 ../test1.txt
run_p1: $(CLS_FILES)
	@$(JR) Part1 ../input.txt

test_p2: $(CLS_FILES)
	$(JR) Part2 ../test2.txt
run_p2: $(CLS_FILES)
	@$(JR) Part2 ../input.txt

build: $(CLS_FILES)
clean:
	rm -f $(OUT_DIR)/*.class

$(CLS_FILES): $(OUT_DIR)/%.class: $(SRC_DIR)/%.java
	@$(JC) $(JCFLAGS) $<
