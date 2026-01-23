certs:
	mkcert radicale.local
	mv radicale.local.pem /etc/radicale/certs
	mv radicale.local-key.pem /etc/radicale/certs
	sudo chown -R radicale:services /etc/keycloak/certs
