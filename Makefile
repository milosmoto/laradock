D=docker
DC=docker-compose
CONTAINER=php-fpm
RUN=$(DC) run --rm $(CONTAINER)
EXEC=$(DC) exec --user=www-data $(CONTAINER)
EXEC_ROOT=$(DC) exec $(CONTAINER)
BASH=/bin/bash
CONSOLE=bin/console
UID := ${shell id -u}
CONTAINER_ID_WORKSPACE=$(shell docker-compose ps -q workspace)
CONTAINER_ID_GULP=$(shell docker-compose ps -q gulp-console)

test:
	@echo $(UID)
	@echo $(CONTAINER_ID_WORKSPACE)
	@echo $(CONTAINER_ID_GULP)

## up			: Mount the containers and fix permissions in container
up:
	@$(DC) -p tms up -d apache2 php-fpm mysql phpmyadmin

## stop			: Stop container without deleting
stop:
	@$(DC) -p tms stop

## remove			: Stops, remove the containers and their volumes
remove:
	@$(DC) -p tms down -v --remove-orphans

## bash			: Access the api container via shell
bash:
	$(D) exec -it tms_php-fpm_1 $(BASH)

## Run angular development compiler, harcode container ids as there is problem with exited containers
gulp_watch:
	$(D) run --rm --volumes-from 928ffa668736 --volumes-from a38e0413fa07 -i -t tms_gulp-console /bin/bash -c "su - tms -s /bin/bash -c 'gulp watch_dev'"
	#$(D) run --rm --volumes-from $(CONTAINER_ID_WORKSPACE) --volumes-from $(CONTAINER_ID_GULP) -i -t tms_gulp-console /bin/bash -c "su - tms -s /bin/bash -c 'gulp watch_dev'"

## composerinstall	: Execute composer install command in container
composerinstall:
	@$(EXEC_ROOT) composer install

## composer_update	: Update a Composer package
composer_update:
	@$(EXEC_ROOT) composer update "$(package)" --no-scripts

