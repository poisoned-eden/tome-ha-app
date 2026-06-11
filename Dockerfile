FROM ghcr.io/bndct-devops/tome:latest

USER root

RUN apt-get update && apt-get install -y jq

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]