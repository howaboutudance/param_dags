SAMPLE_TAG = sks/pytemplate-docker
SAMPLE_INTERACT = sks/pytemplate-interact
SAMPLE_TEST = sks/pytemplate-test
DOCKER_BUILD=docker build ./ -f Dockerfile.sample
DOCKER_RUN=docker run
VENV_VERSION_FOLDER := venv$(shell python --version | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,2\}\).*/\1/p' | sed -e "s/\.//g")
AIRFLOW_HOME:=$(shell pwd)/.airflow
export AIRFLOW_HOME

init-env:
	python -m venv ./$(VENV_VERSION_FOLDER)
	( \
		source ./$(VENV_VERSION_FOLDER)/bin/activate; \
		pip3 install --use-feature=2020-resolver -r requirements.txt; \
		pip3 install --use-feature=2020-resolver -r requirements-dev.txt; \
	)

test: FORCE
	tox -e py36
	mypy sample_module/

start-postgres:
	docker run --name airflow_dev_postgres \
		-e POSTGRES_PASSWORD=wolf_creek -p 5432:5432 \
		postgres:latest

kill-postgres:
	docker stop airflow_dev_postgres
	docker rm airflow_dev_postgres

copy-dags:
	cp dags/*.py .airflow/dags/

start-airflow: copy-dags
	( \
		airflow scheduler & airflow webserver; \
	)

FORCE: