certs:
	mkcert gitea.local
	mv gitea.local.pem /etc/gitea/certs
	mv gitea.local-key.pem /etc/gitea/certs
	sudo chown -R gitea:services /etc/gitea/certs
