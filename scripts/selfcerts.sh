openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=FR/ST=IdF/L=Paris/O=Les Grands Voisins/OU=WhoWhatEtc./CN=whowhatetc.com"
