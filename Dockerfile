FROM pivotalrabbitmq/perf-test:dev as amqp091-perf-test
FROM pivotalrabbitmq/stream-perf-test:dev as stream-perf-test
FROM pivotalrabbitmq/omq:latest as omq

FROM ubuntu

COPY --from=amqp091-perf-test /perf_test /perf_test
COPY --from=stream-perf-test /stream_perf_test /stream_perf_test

COPY --from=omq /ko-app/omq /omq

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y --no-install-recommends \
    ca-certificates default-jre python3 wget curl

RUN wget --no-check-certificate --progress=bar:force:noscroll https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/main/deps/rabbitmq_management/bin/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
RUN chmod 755 /usr/local/bin/rabbitmqadmin

RUN wget --no-check-certificate --progress=bar:force:noscroll https://github.com/rabbitmq/rabbitmqadmin-ng/releases/download/v0.11.0/rabbitmqadmin-0.11.0-x86_64-unknown-linux-gnu.tar.gz /tmp/rabbitmqadmin.tar.gz
RUN tar -xvf /tmp/rabbitmqadmin.tar.gz -C /tmp
RUN mv /tmp/rabbitmqadmin /usr/local/bin/rabbitmqadmin-ng

CMD [""]
