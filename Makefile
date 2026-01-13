rebuild:
	git pull
	# git commit -am "Building new system"
	# git push
	make -C ./containers/homarr/ update
	sudo nixos-rebuild switch --upgrade --flake ./#whowhatetc

rebuild-ass:
	make rebuild
	make -C ./containers/homarr/ update
	sudo machinectl restart homarr

check:
	nix flake check
	make -C ./containers/homarr check

garbage-collect:
	nix-collect-garbage --delete-older-than 7d
	nix-store --gc