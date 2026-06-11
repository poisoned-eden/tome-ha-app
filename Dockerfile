FROM ghcr.io/bndct-devops/tome:latest

RUN apk add --no-cache jq

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]