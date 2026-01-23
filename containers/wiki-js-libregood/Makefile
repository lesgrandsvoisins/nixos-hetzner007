cert:
	mkcert wiki-js-libregood.local
	sudo mkdir -p /etc/wiki-js-libregood/certs
	mv wiki-js-libregood.local.com /etc/wiki-js-libregood/certs
	mv wiki-js-libregood.local-key.com /etc/wiki-js-libregood/certs
	python -c "import secrets; print(secrets.token_hex(16));" >> /etc/wiki-js-libregood/.dbpassword
	sudo chmod 0640 /etc/wiki-js-libregood/.dbpassword
	sudo chown wiki-js:services -R /etc/wiki-js-libregood/