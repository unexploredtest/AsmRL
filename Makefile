ARMGNU ?= arm-linux-gnueabi

OPS = -nostdlib -mfpu=vfp

SRC_DIR = src
BUILD_DIR = build

all: main

clean: 
	rm -rf $(BUILD_DIR) main

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	mkdir -p $(@D)
	$(ARMGNU)-gcc -g $(OPS) -c $< -o $@

ASM_FILES = $(wildcard $(SRC_DIR)/*.S)
OBJ_FILES = $(ASM_FILES:$(SRC_DIR)/%.S=$(BUILD_DIR)/%.o)

main: $(OBJ_FILES)
	$(ARMGNU)-ld -g -o main $(OBJ_FILES)

