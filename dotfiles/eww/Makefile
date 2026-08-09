CC = cc

all: out/battery out/network out/time out/volume out/workspaces

clean:
	rm $(filter-out .gitignore,out/*)

out/battery: modules/battery.c
	$(CC) $< -o $@
out/network: modules/network.c
	$(CC) $< -o $@
out/time: modules/time.c
	$(CC) $< -o $@
out/volume: modules/volume.c
	$(CC) $< -o $@
out/workspaces: modules/workspaces.c
	$(CC) $< -o $@
