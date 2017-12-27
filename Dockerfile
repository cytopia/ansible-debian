# vim:set ft=dockerfile:
FROM debian:stretch
MAINTAINER "cytopia" <cytopia@everythingcli.org>

RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		python-apt \
		python-dev \
		python-jmespath \
		python-pip \
		python-setuptools \
		sudo \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get purge -y --autoremove

RUN set -x \
	&& pip install wheel \
	&& pip install ansible

# Add user with password-less sudo
RUN set -x \
	&& useradd -m -s /bin/bash cytopia \
	&& echo "cytopia ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/cytopia

# Copy files
COPY ./ /home/cytopia/ansible
RUN set -x \
	&& chown -R cytopia:cytopia /home/cytopia/ansible

# Switch to user
USER cytopia

# Change working directory
WORKDIR /home/cytopia/ansible

# Randomize roles to install each time the container is build (each travis run)
RUN set -x \
	&& ROLES_INSTALL="$( for d in $(/bin/ls roles/); do if [ -d roles/${d} ]; then echo $d; fi done | grep -vE '*-meta$' | sort -R )" \
	&& ROLES_REMOVE="$(  for d in $(/bin/ls roles/); do if [ -d roles/${d} ]; then echo $d; fi done | grep -vE '*-meta$' | sort -R )" \
	\
	&& ( \
		echo "#!/bin/sh -eux"; \
		echo; \
		echo "if ! set | grep '^extra=' >/dev/null 2>&1; then"; \
		echo "    extra=\"\""; \
		echo "fi"; \
		echo "if ! set | grep '^random=' >/dev/null 2>&1; then"; \
		echo "    random=\"0\""; \
		echo "fi"; \
		echo; \
		# ---------- Installation (role by role) ----------
		echo "if [ \"\${random}\" = \"1\" ]; then"; \
			echo "	# [INSTALL] Bootstrap roles"; \
			echo "	ansible-playbook -i inventory playbook.yml -t bootstrap-system --limit \${MY_HOST} \${extra} --diff -v"; \
			echo "	ansible-playbook -i inventory playbook.yml -t bootstrap-python --limit \${MY_HOST} \${extra} --diff -v"; \
			echo; \
			echo "	# [INSTALL] Pre-defined roles (randomized)"; \
			for r in ${ROLES_INSTALL}; do \
				echo "	ansible-playbook -i inventory playbook.yml -t ${r} --limit \${MY_HOST} \${extra} --diff -v"; \
			done; \
			echo; \
			echo "	# [INSTALL] Custom apt packages"; \
			echo "	ansible-playbook -i inventory playbook.yml -t apt --limit \${MY_HOST} \${extra} --diff -v"; \
			echo; \
			echo "	# [INSTALL] Default applications"; \
			echo "	ansible-playbook -i inventory playbook.yml -t xdg --limit \${MY_HOST} \${extra} --diff -v"; \
		echo "else"; \
			echo "	ansible-playbook -i inventory playbook.yml --limit \${MY_HOST} \${extra} --diff -v"; \
		echo "fi"; \
		echo; \
		echo "apt list --installed > install1.txt"; \
		echo; \
		\
		# ---------- Installation (full 2nd round) ----------
		echo "ansible-playbook -i inventory playbook.yml --limit \${MY_HOST} \${extra} --diff -v"; \
		echo; \
		echo "apt list --installed > install2.txt"; \
		echo; \
		# ---------- Validate diff ----------
		echo "# Validate"; \
		echo "diff install1.txt install2.txt"; \
		echo; \
		# ---------- Uninstallation ----------
		echo "# [REMOVE] Pre-defined roles (randomized)"; \
		for r in ${ROLES_REMOVE}; do \
			del="$(echo $r | sed 's/-/_/g')=remove"; \
			echo "ansible-playbook -i inventory playbook.yml -t ${r} --limit \${MY_HOST} \${extra} -e ${del} --diff -v"; \
		done; \
		echo; \
		echo "# [REMOVE] Custom apt packages"; \
		echo "ansible-playbook -i inventory playbook.yml -t apt --limit \${MY_HOST} \${extra} -e apt_state=absent --diff -v"; \
		\
	) > run-tests.sh \
	&& chmod +x run-tests.sh

ENTRYPOINT ["./run-tests.sh"]
