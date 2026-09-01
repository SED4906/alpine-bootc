FROM scratch as pctx
COPY prebuild_files /

FROM scratch as bctx
COPY build_files /

FROM docker.io/library/alpine:edge

RUN --mount=type=bind,from=pctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/bootc.sh

RUN --mount=type=bind,from=bctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

LABEL containers.bootc=1

RUN bootc container lint
