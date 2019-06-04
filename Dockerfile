FROM registry.svc.ci.openshift.org/openshift/release:golang-1.12 AS builder
WORKDIR /go/src/github.com/coreos/prometheus-operator
COPY . .
RUN make operator-no-deps

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/coreos/prometheus-operator/operator /usr/bin/
# doesn't require a root user.
USER 1001
ENTRYPOINT ["/usr/bin/operator"]
LABEL io.k8s.display-name="Prometheus Operator" \
      io.k8s.description="This component manages the lifecycle and configuration of a Prometheus monitoring server as well as Prometheus Alertmanager clusters." \
      io.openshift.tags="prometheus" \
      maintainer="Frederic Branczyk <fbranczy@redhat.com>"
