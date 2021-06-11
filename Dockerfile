FROM docker:20.10

RUN apk -v --update add \
        bash \
        rsync \
        python3 \
        py3-pip \
        groff \
        jq \
        less \
        mailcap \
        && \
    pip install --upgrade awscli python-magic --ignore-installed six && \
    rm /var/cache/apk/*

VOLUME /root/.aws
VOLUME /project
WORKDIR /project
