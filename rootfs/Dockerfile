FROM keitaro/base:0.1

MAINTAINER Keitaro Inc <info@keitaro.info>

ENV APP_DIR=/srv/app
ENV GIT_BRANCH 0.0.8
ENV GIT_URL https://github.com/ckan/datapusher.git
ENV JOB_CONFIG ${APP_DIR}/datapusher_settings.py

WORKDIR ${APP_DIR}

RUN apk add --no-cache python \
    py-pip \
    py-gunicorn \
    libxslt

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    git \
    musl-dev \
    python-dev \
    libxml2-dev \
    libxslt-dev 

RUN mkdir ${APP_DIR}/src && cd ${APP_DIR}/src && \
    git clone -b ${GIT_BRANCH} --depth=1 --single-branch ${GIT_URL} && \
    cd datapusher && \
    python setup.py install && \
    pip install --no-cache-dir -r requirements.txt

RUN apk del .build-deps && \
    rm -rf ${APP_DIR}/src

COPY setup ${APP_DIR}

EXPOSE 8000

CMD ["gunicorn", "wsgi"]
