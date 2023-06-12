FROM docker:20.10.7-dind

RUN apk -v --update add \
        bash \
        git \
        curl \
        rsync \
        groff \
        jq \
        less \
        mailcap \
        wget \
        aws-cli \
    && rm /var/cache/apk/*

WORKDIR /project
