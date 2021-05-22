SAMPLE_TAG = sks/pytemplate-docker
SAMPLE_INTERACT = sks/pytemplate-interact
SAMPLE_TEST = sks/pytemplate-test
DOCKER_BUILD=docker build ./ -f Dockerfile.sample
DOCKER_RUN=docker run
VENV_VERSION_FOLDER := venv$(shell python --version | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,2\}\).*/\1/p' | sed -e "s/\.//g")
init-env:
	python -m venv ./$(VENV_VERSION_FOLDER)
	( \
		source ./$(VENV_VERSION_FOLDER)/bin/activate; \
		pip3 install --use-feature=2020-resolver -r requirements.txt; \
		pip3 install --use-feature=2020-resolver -r requirements-dev.txt; \
	)
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