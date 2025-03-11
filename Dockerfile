FROM pivotalrabbitmq/perf-test:dev AS amqp091-perf-test
FROM pivotalrabbitmq/stream-perf-test:dev AS stream-perf-test
FROM pivotalrabbitmq/omq:latest AS omq

FROM ubuntu:latest

ENV JAVA_HOME=/usr/lib/openjdk/jre
COPY --from=amqp091-perf-test /usr/lib/jvm/java-*-openjdk/jre $JAVA_HOME/
RUN ln -svT $JAVA_HOME/bin/java /usr/local/bin/java

COPY --from=amqp091-perf-test /perf_test /perf_test
COPY --from=stream-perf-test /stream_perf_test /stream_perf_test
COPY --from=omq /ko-app/omq /omq

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget
RUN apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN wget --no-check-certificate --progress=bar:force:noscroll https://github.com/rabbitmq/rabbitmqadmin-ng/releases/download/v0.27.0/rabbitmqadmin-0.27.0-x86_64-unknown-linux-gnu -O /usr/local/bin/rabbitmqadmin-ng
RUN chmod 755 /usr/local/bin/rabbitmqadmin-ng

CMD [""]
