#!/bin/sh

set -e
#set -x
set -u

MY_NAME="docker-run.sh"

logmsg() {
	# Only log to stdout when verbose is turned on
	echo "$(date +'%Y-%m-%d %H:%M:%S') ${MY_NAME}: [INFO]  ${*}"
}

logerr() {
	echo "$(date +'%Y-%m-%d %H:%M:%S') ${MY_NAME}: [ERROR] ${*}" >&2
}

print_usage() {
	echo "Usage: ${MY_NAME} -l [-vtr]"
	echo "       ${MY_NAME} -h"
	echo "       ${MY_NAME} --help"
}

LIMIT=
VERBOSE=
TAG=
RAND=
# Get options
while [ ${#} -gt 0 ]; do
	case "${1}" in
		-h | --help)
			print_usage
			exit
			;;
		-l | --limit)
			shift
			if [ -z "${1+s}" ]; then
				logerr "-l requires an argument"
				exit 1
			fi
			LIMIT="${1}"
			;;
		-v | --verbose)
			shift
			if [ "${1}" != "1" ] && [ "${1}" != "2" ] && [ "${1}" != "3" ]; then
				logerr "-v must be either 1, 2 or 3. Current value: ${1}"
				exit 1
			fi
			VERBOSE="${1}"
			;;
		-t | --tag)
			shift
			TAG="${1}"
			;;
		-r | --random)
			shift
			if [ "${1}" != "0" ] && [ "${1}" != "1" ]; then
				logerr "-r must be either 0 or 1. Current value: ${1}"
				exit 1
			fi
			RAND="${1}"
			;;
		-*) # Unknown option
			logerr "Error: Unknown option: ${1}"
			exit 1
			;;
		*)  # No more options
			break
			;;
	esac
	shift
done

# Limit
if [ -z "${LIMIT}" ]; then
	logerr "-l is required"
	exit 1
fi
LIMIT="-e MY_HOST=${LIMIT}"

# Tag
if [ -n "${TAG}" ]; then
	TAG="-e tag=${TAG}"
fi

# Random
if [ -n "${RAND}" ]; then
	RAND="-e random=${RAND}"
fi

# Verbose
if [ -n "${VERBOSE}" ]; then
	VERBOSE="-e verbose=${VERBOSE}"
fi

docker_id="$( mktemp )"


###
### 1. Start container
###
docker run \
	--privileged \
	--detach \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	${LIMIT} \
	${TAG} \
	${VERBOSE} \
	${RAND} \
	-t ansible-debian > "${docker_id}"


###
### 2. Attach and run tests
###
FAILURE=1
if docker exec --user=cytopia -it "$( cat "${docker_id}" )" ./run-tests.sh; then
	FAILURE=0
fi

###
### 3. Clean-up
###
docker stop "$( cat "${docker_id}" )"
rm "${docker_id}"


###
### 4. Return state
###
exit ${FAILURE}
