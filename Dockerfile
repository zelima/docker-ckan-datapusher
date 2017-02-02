FROM python:2

MAINTAINER Keitaro Inc <info@keitaro.info>

ENV APP_DIR /srv/app
ENV GIT_BRANCH meerbusch
ENV GIT_URL https://github.com/ViderumGlobal/datapusher.git
ENV JOB_CONFIG ${APP_DIR}/datapusher_settings.py
ENV LANG de_DE.UTF-8

WORKDIR ${APP_DIR}

RUN apt-get update && apt-get install -y \
    locales \
    git \
    libxml2-dev \
    libxslt-dev && \
    rm -rf /var/lib/apt/lists/* && \
    # Configure locale
    sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="de_DE.UTF-8"' > /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=de_DE.UTF-8 && \
    # Fetch datapusher and install
    mkdir ${APP_DIR}/src && cd ${APP_DIR}/src && \
    git clone -b ${GIT_BRANCH} --depth=1 --single-branch ${GIT_URL} && \
    cd datapusher && \
    git checkout e1c7b6f585eda706e3a1310cc964bf1432495ac5 && \
    python setup.py install && \
    pip install --no-cache-dir -r requirements.txt && \
    pip uninstall messytables -y && \
    pip install git+https://github.com/ViderumGlobal/messytables.git@68180fb1b215e3c19845dddc005369f5520d17a9#egg=messytables && \
    # Install gunicorn
    pip install gunicorn


COPY setup ${APP_DIR}

EXPOSE 8000

CMD ["gunicorn", "--log-file=-", "wsgi"]
