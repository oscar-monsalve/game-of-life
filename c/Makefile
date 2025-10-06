# === Basic settings ===
TARGET = game-of-life

CC = gcc
CFLAGS = -Wall -Wextra -std=c11 `sdl2-config --cflags`
LDFLAGS = `sdl2-config --libs`

# === Directories ===
SRC_DIR = src
BUILD_DIR = build
BIN_DIR = bin

# === Files ===
SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRC))
TARGET_PATH = $(BIN_DIR)/$(TARGET)

# === Default rule ===
all: $(TARGET_PATH)

$(TARGET_PATH): $(OBJ) | $(BIN_DIR)
	$(CC) $(OBJ) -o $@ $(LDFLAGS)

# === Compile rule for each source file ===
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# === Ensure directories exist ===
$(BUILD_DIR) $(BIN_DIR):
	mkdir -p $@

# === Clean up ===
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: all clean
