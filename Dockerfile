FROM golang:1.16-alpine3.13

RUN apk update && \
    apk upgrade && \
    apk add build-base && \
    apk add git && \
    apk add yq && \
    git clone https://github.com/cli/cli.git gh-cli && \
    cd gh-cli && \
    make && \
    mv ./bin/gh /usr/local/bin/

# RUN wget https://github.com/mikefarah/yq/releases/download/v4.13.5/yq_linux_amd64 -O /usr/bin/yq &&\
#     chmod +x /usr/bin/yq

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
