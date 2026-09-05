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

$(OUT_DIR)/library.h.gch: $(MODULES_DIR)/library.h
	$(CC) -c $< -o $@

$(OUT_DIR)/%: $(MODULES_DIR)/%.c $(OUT_DIR)/library.h.gch
	$(CC) $< -o $@ -I$(OUT_DIR)

run_%: $(OUT_DIR)/%
	$^
