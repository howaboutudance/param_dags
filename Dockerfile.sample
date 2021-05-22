FROM python:3.8 as source 
WORKDIR app
COPY ./requirements.txt ./
COPY ./setup.py ./ README.md ./
RUN pip3 install -r requirements.txt
COPY ./sample_module/. ./sample_module

FROM source as test
COPY ./test ./test
COPY ./tox.ini ./ ./requirements-dev.txt ./
RUN pip3 install -r requirements-dev.txt
CMD tox -e py38 && mypy sample_module/

FROM source as builder
RUN pip3 install wheel
RUN python setup.py bdist_wheel

FROM python:3.8 as interact
COPY --from=builder /app/dist ./app/dist
WORKDIR app
COPY ./requirements-interact.txt ./
RUN pip3 install -r requirements-interact.txt && pip3 install dist/example_pkg_mpenhallegon*
CMD jupyter console

FROM python:3.8-slim as app
COPY --from=builder /app/dist ./app/dist
WORKDIR app
RUN pip3 install dist/example_pkg_mpenhallegon*
CMD python -m sample_module