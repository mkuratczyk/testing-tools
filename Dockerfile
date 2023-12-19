FROM emqx/emqtt-bench:latest AS emqtt-bench
FROM erlang:latest as erlang
FROM pivotalrabbitmq/perf-test:dev as amqp091-perf-test
FROM pivotalrabbitmq/stream-perf-test:dev as stream-perf-test
FROM mkuratczyk/omq:latest as omq

FROM ubuntu

COPY --from=amqp091-perf-test /perf_test /perf_test
COPY --from=stream-perf-test /stream_perf_test /stream_perf_test

COPY --from=erlang /usr/local/lib/erlang /usr/local/lib/erlang
COPY --from=erlang /usr/local/bin/* /usr/local/bin/
COPY --from=emqtt-bench /emqtt_bench /emqtt_bench
COPY --from=omq /ko-app/omq /omq

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y --no-install-recommends \
    ca-certificates default-jre python3 wget curl

RUN wget --no-check-certificate --progress=bar:force:noscroll https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/main/deps/rabbitmq_management/bin/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
RUN chmod 755 /usr/local/bin/rabbitmqadmin

CMD [""]
