FROM python:3-alpine3.13 AS installer

ENV AWSCLI_VERSION=2.2.0

RUN apk add --no-cache \
    gcc \
    git \
    libc-dev \
    libffi-dev \
    openssl-dev \
    py3-pip \
    zlib-dev \
    make \
    cmake

RUN git clone --recursive  --depth 1 --branch ${AWSCLI_VERSION} --single-branch https://github.com/aws/aws-cli.git

WORKDIR /aws-cli

# Follow https://github.com/six8/pyinstaller-alpine to install pyinstaller on alpine
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir pycrypto \
    && git clone --depth 1 --single-branch --branch v$(grep PyInstaller requirements-build.txt | cut -d'=' -f3) https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
    && cd /tmp/pyinstaller/bootloader \
    && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" python ./waf configure --no-lsb all \
    && pip install .. \
    && rm -Rf /tmp/pyinstaller \
    && cd - \
    && boto_ver=$(grep botocore setup.cfg | cut -d'=' -f3) \
    && git clone --single-branch --branch v2 https://github.com/boto/botocore /tmp/botocore \
    && cd /tmp/botocore \
    && git checkout $(git log --grep $boto_ver --pretty=format:"%h") \
    && pip install . \
    && rm -Rf /tmp/botocore  \
    && cd -

RUN sed -i '/botocore/d' requirements.txt \
    && scripts/installers/make-exe

RUN unzip dist/awscli-exe.zip \
    && ./aws/install --bin-dir /aws-cli-bin

FROM docker:20.10

RUN apk -v --update add \
        bash \
        rsync \
        groff \
        jq \
        less \
        mailcap \
    && rm /var/cache/apk/*

COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/

WORKDIR /project
