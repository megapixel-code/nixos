.PHONY: all clean
all: out/main
	out/main
clean:
	rm -rf out/ build/

out/:
	mkdir -p out
build/:
	mkdir -p build

build/%.o: script/%.c build/
	$(CC) -c -o $@ $<

out/%: build/%.o out/
	$(CC) -o $@ $<
