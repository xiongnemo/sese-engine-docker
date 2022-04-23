FROM python:3.8.13-alpine3.15
LABEL Author "Nemo Xiong <nemo@anzupop.com>"


ENV PYTHONUNBUFFERED=1

ENV HOME=/tmp
RUN addgroup -S sese && adduser -S sese -G sese -h /tmp -s /bin/sh

WORKDIR /code/

# Install packages
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.sjtug.sjtu.edu.cn/g' /etc/apk/repositories
RUN apk update && \
    apk add libxslt-dev libxml2-dev gcc g++ libffi-dev musl-dev linux-headers git && \
    rm  -rf /tmp/* /var/cache/apk/*

RUN echo "root:$(echo $RANDOM$RANDOM$RANDOM$RANDOM$RANDOM | sha512sum | cut -d " " -f 1 )" | chpasswd
RUN echo "sese:$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 20)" | chpasswd

RUN chown sese:sese /code

USER sese

COPY ./sese-engine-building /code
RUN pip config set global.index-url https://mirror.sjtu.edu.cn/pypi/web/simple
RUN pip install -r /code/requirements.txt

USER root

RUN apk del libffi-dev musl-dev linux-headers git

USER sese

EXPOSE 4950

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]