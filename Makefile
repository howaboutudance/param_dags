SAMPLE_TAG = sks/pytemplate-docker
SAMPLE_INTERACT = sks/pytemplate-interact
SAMPLE_TEST = sks/pytemplate-test
DOCKER_BUILD=docker build ./ -f Dockerfile.sample
DOCKER_RUN=docker run

build: FORCE
	${DOCKER_BUILD} --no-cache=true --target=app -t ${SAMPLE_TAG}

run:
	${DOCKER_RUN} ${SAMPLE_TAG}

interact: FORCE
	${DOCKER_BUILD} --target=interact -t ${SAMPLE_TEST}
	${DOCKER_RUN} -it ${SAMPLE_INTERACT}

test: FORCE
	${DOCKER_BUILD} --target=test -t ${SAMPLE_INTERACT}
	${DOCKER_RUN} -it ${SAMPLE_INTERACT}

local-test: FORCE
	tox -e py36
	mypy sample_module/

FORCE: