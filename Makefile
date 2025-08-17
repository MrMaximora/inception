DATA_DIR = /home/maxouvra/data

all: up

setup:
	mkdir -p $(DATA_DIR)/db $(DATA_DIR)/wp

up: setup
	docker compose -f srcs/docker-compose.yml up --build -d

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af --volumes

re: clean all

.PHONY: all up down clean re
