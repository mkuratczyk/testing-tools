FROM emqx/emqtt-bench:latest AS emqtt-bench
FROM erlang:latest as erlang
FROM pivotalrabbitmq/stream-perf-test:dev as stream-perf-test

FROM pivotalrabbitmq/perf-test:dev

COPY --from=stream-perf-test /stream_perf_test /stream_perf_test

COPY --from=erlang /usr/local/lib/erlang /usr/local/lib/erlang
COPY --from=erlang /usr/local/bin/* /usr/local/bin
COPY --from=emqtt-bench /emqtt_bench /emqtt_bench

CMD [""]
