.PHONY: pull reinstall install start stop restart certificate

pull:
	git pull
	make reinstall

reinstall:
	make stop
	make install

reinstall-local:
	make stop-local
	make install-local

install:
	make certificate
	docker-compose -f ./laravel-big-file-docker/docker-compose.yml up -d --build
	docker exec laravel-big-file-php bash -c "composer install"
	docker exec laravel-big-file-php bash -c "npm install"

install-local:
	make certificate
	docker-compose -f ./laravel-big-file-docker/docker-compose-local.yml up -d --build

start:
	docker-compose -f ./laravel-big-file-docker/docker-compose.yml up -d

start-local:
	docker-compose -f ./laravel-big-file-docker/docker-compose-local.yml up -d

stop:
	docker-compose -f ./laravel-big-file-docker/docker-compose.yml down

stop-local:
	docker-compose -f ./laravel-big-file-docker/docker-compose-local.yml down

restart:
	make stop
	make start

restart-local:
	make stop-local
	make start-local

certificate:
	openssl req -x509 -nodes -newkey rsa:2048 -keyout laravel-big-file-docker/nginx/key.pem -out laravel-big-file-docker/nginx/cert.pem -sha256 -days 365 -subj "/C=GB/ST=London/L=London/O=Alros/OU=IT Department/CN=localhost"