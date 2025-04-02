DOCKER_COMPOSE = docker compose --project-directory srcs


help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

build: ## Build the containers
	@rm -f .build_output
	@echo "Building the docker images." "\n"

#	Here is the docker compose build
	@$(DOCKER_COMPOSE) build > .build_output 2>/dev/null

	@echo "Built services:"
	@cat .build_output | grep "load .dockerignore" | awk '{print $$2}' | cut -c 2- | awk '{print "  - " $$1}'

logs: ## Show the docker compose logs
	@$(DOCKER_COMPOSE) logs | bat

up: ## Starts the docker compose with '--detach' flag
	@$(DOCKER_COMPOSE) up --detach

follow: ## Starts the docker compose without '--detach' flag
	@$(DOCKER_COMPOSE) up

down: ## Stops the cocker compose
	@$(DOCKER_COMPOSE) down

containers: ## List containers
	@chmod +x ./.utils.sh
	@./.utils.sh containers

volumes: ## Shows all volumes
	@chmod +x ./.utils.sh
	@./.utils.sh volumes

networks: ## Show all networks
	@chmod +x ./.utils.sh
	@./.utils.sh networks

clean: ## Cleans all docker images / volumes / networks on the VM

	@echo "Stopping all containers"
	$(eval RUNNING_DOCKERS=`docker ps -qa`)
	@-docker stop $(RUNNING_DOCKERS) > /dev/null 2>&1
	@echo "Removing all built containers"
	$(eval BUILT_CONTAINERS=`docker ps -qa`)
	@-docker rm $(BUILT_CONTAINERS) > /dev/null 2>&1
	@echo "Removing all containers images"
	$(eval DOCKER_IMAGES=`docker images -qa`)
	@-docker rmi -f $(DOCKER_IMAGES) > /dev/null 2>&1
	@echo "Removing all containers volumes"
	$(eval DOCKER_VOLUMES=`docker volume ls -q`)
	@-docker volume rm $(DOCKER_VOLUMES) > /dev/null 2>&1
	@echo "Removing all containers networks"
	$(eval DOCKER_NETWORKS=`docker network ls -q`)
	@-docker network rm $(DOCKER_NETWORKS) > /dev/null 2>&1
	@echo "Cleaned the machine of all docker-related info"


start: up ## Will call the 'up' rule
stop: down ## Will call the 'down' rule
ps: containers ## Will call 'containers' rule
vl: volumes ## Will call 'volumes' rule
nt: networks ## Will call 'networks' rule
reset: clean ## Will call 'clean' rule