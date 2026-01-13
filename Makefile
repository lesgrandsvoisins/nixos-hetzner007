switch-flake:
	git pull
	# git commit -am "Building new system"
	# git push
	make -C ./containers/homarr/ update
	sudo nixos-rebuild switch --upgrade --flake ./#whowhatetc
	sudo machinectl restart homarr

check:
	make -C ./containers/homarr check
	nix flake check

take-out-the-old-garbage:
	nix-collect-garbage --delete-older-than 7d
	nix-store --gc