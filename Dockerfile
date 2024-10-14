FROM brew.registry.redhat.io/rh-osbs/openshift-golang-builder:v1.22.7-202410111609.gc451559.el9 AS builder

# Start Konflux-specific steps
RUN mkdir -p /tmp/yum_temp; mv /etc/yum.repos.d/*.repo /tmp/yum_temp/ || true
COPY .oit/unsigned.repo /etc/yum.repos.d/
ADD https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem /tmp
# End Konflux-specific steps
ENV __doozer=update BUILD_RELEASE=202410141917.p0.g4620235.assembly.test.el9 BUILD_VERSION=v4.18.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=18 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.18.0-202410141917.p0.g4620235.assembly.test.el9 SOURCE_GIT_TREE_STATE=clean __doozer_group=openshift-4.18 __doozer_key=cloud-event-proxy __doozer_uuid_tag=ose-cloud-event-proxy-rhel9-v4.18.0-20241014.191751 __doozer_version=v4.18.0 
ENV __doozer=merge OS_GIT_COMMIT=4620235 OS_GIT_VERSION=4.18.0-202410141917.p0.g4620235.assembly.test.el9-4620235 SOURCE_DATE_EPOCH=1728675826 SOURCE_GIT_COMMIT=4620235ad1155fd8d8c6fafd522c5c85c466ad88 SOURCE_GIT_TAG=4620235 SOURCE_GIT_URL=https://github.com/redhat-cne/cloud-event-proxy 
ENV GO111MODULE=off
ENV CGO_ENABLED=1
ENV COMMON_GO_ARGS=-race
ENV GOOS=linux
ENV GOPATH=/go

WORKDIR /go/src/github.com/redhat-cne/cloud-event-proxy
COPY . .

RUN hack/build-go.sh

FROM quay.io/openshift-release-dev/ocp-v4.0-art-dev-test:openshift-enterprise-base-rhel9-v4.18.0-20241014.191751 AS bin

# Start Konflux-specific steps
RUN mkdir -p /tmp/yum_temp; mv /etc/yum.repos.d/*.repo /tmp/yum_temp/ || true
COPY .oit/unsigned.repo /etc/yum.repos.d/
ADD https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem /tmp
# End Konflux-specific steps
ENV __doozer=update BUILD_RELEASE=202410141917.p0.g4620235.assembly.test.el9 BUILD_VERSION=v4.18.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=18 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.18.0-202410141917.p0.g4620235.assembly.test.el9 SOURCE_GIT_TREE_STATE=clean __doozer_group=openshift-4.18 __doozer_key=cloud-event-proxy __doozer_uuid_tag=ose-cloud-event-proxy-rhel9-v4.18.0-20241014.191751 __doozer_version=v4.18.0 
ENV __doozer=merge OS_GIT_COMMIT=4620235 OS_GIT_VERSION=4.18.0-202410141917.p0.g4620235.assembly.test.el9-4620235 SOURCE_DATE_EPOCH=1728675826 SOURCE_GIT_COMMIT=4620235ad1155fd8d8c6fafd522c5c85c466ad88 SOURCE_GIT_TAG=4620235 SOURCE_GIT_URL=https://github.com/redhat-cne/cloud-event-proxy 
COPY --from=builder /go/src/github.com/redhat-cne/cloud-event-proxy/build/cloud-event-proxy /
COPY --from=builder /go/src/github.com/redhat-cne/cloud-event-proxy/plugins/*.so /plugins/


ENTRYPOINT ["./cloud-event-proxy"]

# Start Konflux-specific steps
RUN cp /tmp/yum_temp/* /etc/yum.repos.d/ || true
# End Konflux-specific steps

LABEL \
        io.k8s.display-name="Cloud Event Proxy" \
        io.k8s.description="This is a component of OpenShift Container Platform and provides a side car to handle cloud events." \
        io.openshift.tags="openshift" \
        maintainer="Aneesh Puttur <aputtur@redhat.com>" \
        name="openshift/ose-cloud-event-proxy-rhel9" \
        com.redhat.component="cloud-event-proxy-container" \
        io.openshift.maintainer.project="OCPBUGS" \
        io.openshift.maintainer.component="Cloud Native Events / Cloud Event Proxy" \
        version="v4.18.0" \
        release="202410141917.p0.g4620235.assembly.test.el9" \
        io.openshift.build.commit.id="4620235ad1155fd8d8c6fafd522c5c85c466ad88" \
        io.openshift.build.source-location="https://github.com/redhat-cne/cloud-event-proxy" \
        io.openshift.build.commit.url="https://github.com/redhat-cne/cloud-event-proxy/commit/4620235ad1155fd8d8c6fafd522c5c85c466ad88"

