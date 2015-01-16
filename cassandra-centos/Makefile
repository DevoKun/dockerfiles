JAVA7_CONTAINER_NAME="local:centos6java7u71"
BUILD_CONTAINER_NAME="local:centos6java7u71cassandra"
DOCKER_RUN_CMD="docker run -p 8080:8080 -p 9001:9001"

.PHONY: default
default: run


.PHONY: build
build: Dockerfile
	cp ../java7-centos/compile_priam/priam/priam-web/build/libs/priam-web-2.0.1.war files/
	cp ../java7-centos/compile_priam/priam/priam-cass-extensions/build/libs/priam-cass-extensions-2.0.1.jar  files/
	docker build -t $(BUILD_CONTAINER_NAME) .


.PHONY: compile_priam
compile_priam: compile_priam
	cd ../java7-centos
	docker run -v $(shell pwd)/compile_priam:/usr/src/compile_priam -i -t $(JAVA7_CONTAINER_NAME) /usr/src/compile_priam/compile_priam.sh


.PHONY: run
run: run
	$(DOCKER_RUN_CMD)  $(BUILD_CONTAINER_NAME)

.PHONY: daemon
daemon: daemon
	$(DOCKER_RUN_CMD) -d $(BUILD_CONTAINER_NAME)

.PHONY: diagnose
diagnose: diagnose
	$(DOCKER_RUN_CMD)  $(BUILD_CONTAINER_NAME) /bin/bash


