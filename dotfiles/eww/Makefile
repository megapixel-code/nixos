MODULES_DIR := ./modules
OUT_DIR := ./out
MODULES := battery \
	network \
	time \
	volume \
	workspaces
OUT_MODULES := $(foreach module,$(MODULES),$(OUT_DIR)/$(module))

.PHONY: all clean
all: $(OUT_MODULES)
clean:
	-rm $(filter-out .gitignore,$(OUT_DIR)/*)

$(OUT_DIR)/%.o: $(MODULES_DIR)/%.c
	$(CC) -c $< -o $@

$(OUT_DIR)/%: $(OUT_DIR)/%.o $(OUT_DIR)/library.o
	$(CC) $^ -o $@

run_%: $(OUT_DIR)/%
	$^
