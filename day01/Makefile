

SRC_DIR = src
OUT_DIR = out
SRC_FILES = $(wildcard $(SRC_DIR)/*.java)
CLS_FILES = $(SRC_FILES:$(SRC_DIR)/%.java=$(OUT_DIR)/%.class)

# Compiler
JC := javac
# Compile Flags
JCFLAGS := -d $(OUT_DIR)/ -cp $(SRC_DIR)/

.PHONY: build

build: $(CLS_FILES)

$(CLS_FILES): $(OUT_DIR)/%.class: $(SRC_DIR)/%.java
    $(JC) $(JCFLAGS) $<
