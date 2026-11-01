FROM ubuntu:24.04 AS build

ARG ODIN_VERSION=dev-2025-12
ARG ODIN_COMMIT=b277d66e008e15d640208f3e11515b047f78be48

# Odin needs llvm and clang for building itself. Ubuntu 24.04 ships LLVM 18, which this Odin version supports.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git make clang llvm-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the tag rather than download a source archive: the build takes the version it reports from git.
# The commit check pins the tag to the tested version.
RUN git clone --depth 1 --branch "${ODIN_VERSION}" https://github.com/odin-lang/Odin.git /Odin-install \
    && test "$(git -C /Odin-install rev-parse HEAD)" = "${ODIN_COMMIT}" \
    && make -C /Odin-install release \
    && mkdir /opt/Odin \
    && cp -R /Odin-install/base /Odin-install/core /Odin-install/shared /Odin-install/vendor /Odin-install/odin /opt/Odin/

FROM ubuntu:24.04

# Odin uses clang to link the programs it builds. The odin binary itself links to the LLVM library that comes with clang.
RUN apt-get update \
    && apt-get install -y --no-install-recommends clang \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/Odin /opt/Odin

ENV PATH="/opt/Odin:${PATH}"
