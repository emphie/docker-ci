FROM docker:20.10

RUN apk -v --update add \
        bash \
        rsync \
        python \
        py-pip \
        groff \
        jq \
        less \
        mailcap \
        && \
    pip install --upgrade awscli python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

VOLUME /root/.aws
VOLUME /project
WORKDIR /project