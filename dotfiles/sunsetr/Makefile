.PHONY: all clean
CFLAGS := -O3

all: out/main
	out/main
clean:
	rm -rf out/ build/

out/:
	mkdir -p out
build/:
	mkdir -p build

build/%.o: script/%.c build/
	$(CC) $(CFLAGS) -c -o $@ $<

out/%: build/%.o out/
	$(CC) $(CFLAGS) -o $@ $<
