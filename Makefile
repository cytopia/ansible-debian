DIR = .
FILE = Dockerfile
IMAGE = kalos/ansible-debian-workstation
TAG = latest

# Ansible variables
VERBOSE=
PROFILE=kalos-jiji
ARG=

.PHONY: help build-docker test-docker-full test-docker-random test-docker-single itest-docker-full itest-docker-random itest-docker-single


#--------------------------------------------------------------------------------------------------
# Default Target
#--------------------------------------------------------------------------------------------------

help:
	@echo "################################################################################"
	@echo "#                                                                              #"
	@echo "#    Debian Provisioning with Ansible                                          #"
	@echo "#                                                                              #"
	@echo "################################################################################"
	@echo
	@echo
	@echo "------------------------------------------------------------"
	@echo " Run tests in Docker"
	@echo "------------------------------------------------------------"
	@echo
	@echo "build-docker                 Build the testing Docker image (happens automatically during tests)"
	@echo
	@echo "test-docker-full             Run a full test in a Docker (requires PROFILE)"
	@echo "test-docker-random           Run a full randomized test in a Docker (requires PROFILE)"
	@echo "test-docker-single           Run the test on a single role in a Docker (requires PROFILE and ROLE)"
	@echo
	@echo "itest-docker-full            Interactive version of test-docker-full (requires PROFILE)"
	@echo "itest-docker-random          Interactive version of test-docker-random (requires PROFILE)"
	@echo "itest-docker-single          Interactive version of test-docker-single (requires PROFILE and ROLE)"
	@echo
	@echo
	@echo "------------------------------------------------------------"
	@echo " Run tests in Vagrant"
	@echo "------------------------------------------------------------"
	@echo
	@echo "------------------------------------------------------------"
	@echo " Deploy your host system"
	@echo "------------------------------------------------------------"
	@echo


#--------------------------------------------------------------------------------------------------
# Tests with Docker
#--------------------------------------------------------------------------------------------------

build-docker:
	docker build -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

# Automated tests
test-docker-full: build-docker
	docker run --rm -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -t $(IMAGE)

test-docker-random: build-docker
	docker run --rm -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e random=1 -t $(IMAGE)

test-docker-single: build-docker
	docker run --rm -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e tag=$(ROLE) -t $(IMAGE)

# Interactive tests
# When inside the Container execute: ./run-tests.sh
itest-docker-full: build-docker
	docker run -it --rm --entrypoint=bash -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -t $(IMAGE)

itest-docker-random: build-docker
	docker run -it --rm --entrypoint=bash -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e random=1 -t $(IMAGE)

itest-docker-single: build-docker
	docker run -it --rm --entrypoint=bash -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e tag=$(ROLE) -t $(IMAGE)


#--------------------------------------------------------------------------------------------------
# Tests with Vagrant
#--------------------------------------------------------------------------------------------------

# Test your profile with Vagrant
test-vagrant:
	vagrant rsync
	PROFILE=$(PROFILE) vagrant up --provision


#--------------------------------------------------------------------------------------------------
# Deploy Targets
#--------------------------------------------------------------------------------------------------

# (Step 1/4) [requires root] Ensure required software is present
deploy-init:
ifneq ($(USER),root)
	$(error Target 'deploy-init' must be run as root or with sudo)
endif
	DEBIAN_FRONTEND=noninteractive apt-get update -qq
	DEBIAN_FRONTEND=noninteractive apt-get install -qq -q --no-install-recommends --no-install-suggests \
		python-apt \
		python-dev \
		python-jmespath \
		python-pip \
		python-setuptools
	pip install wheel
	pip install ansible

# (Step 2/4) Add new Debian sources
deploy-apt-sources:
ifeq ($(USER),root)
	$(error Target 'deploy-apt-sources' must be run as normal user without sudo)
endif
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff -t bootstrap-system --ask-become-pass

# (Step 3/4) [requires root] Adist-upgrade your system
deploy-dist-upgrade:
ifneq ($(USER),root)
	$(error Target 'deploy-dist-upgrade' must be run as root or with sudo)
endif
	DEBIAN_FRONTEND=noninteractive apt-get update -qq
	DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -qq -y

# (Step 4/4) Deploy your system
deploy-tools:
ifeq ($(USER),root)
	$(error Target 'deploy-tools' must be run as normal user without sudo)
endif
ifndef ROLE
ifndef IGNORE
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff $(ARG)
else
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff $(ARG) --skip-tags=$(IGNORE)
endif
else
ifndef IGNORE
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff $(ARG) -t $(ROLE)
else
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff $(ARG) -t $(ROLE) --skip-tags=$(IGNORE)
endif
endif

# Checkmode to test against currently installed tools
diff-tools:
ifeq ($(USER),root)
	$(error Target 'diff-tools' must be run as normal user without sudo)
endif
ifndef ROLE
ifndef IGNORE
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --check $(ARG)
else
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --check $(ARG) --skip-tags=$(IGNORE)
endif
else
ifndef IGNORE
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --check $(ARG) -t $(ROLE)
else
	ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --check $(ARG) -t $(ROLE) --skip-tags=$(IGNORE)
endif
endif
