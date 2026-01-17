cert:
	mkcert keycloak
	sudo mkdir -p /etc/keycloak/certs
	mv keycloak keycloak-pem /etc/keycloak/certs
	python -c "import secrets; print(secrets.token_hex(16));" >> /etc/keycloak/.dbpassword
