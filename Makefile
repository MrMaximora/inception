NAME = inception
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

fclean: clean
	@if [ -n "$$(docker volume ls -q -f "name=srcs")" ]; then \
		docker volume rm $$(docker volume ls -q -f "name=srcs"); \
	fi
	@if [ -n "$$(docker network ls -q -f "name=inception")" ]; then \
		docker network rm $$(docker network ls -q -f "name=inception"); \
	fi
	docker run --rm -v $(DATA_DIR):/data debian bash -c "rm -rf /data/db /data/wp && mkdir -p /data/db /data/wp"


re: fclean all

.PHONY: all up down clean fclean re
