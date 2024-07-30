FROM ubuntu:22.04

# Odin needs llvm and clang for building itself as well as building .odin files on *Nix systems
RUN apt-get update -qq \
    && apt-get install -y llvm clang git build-essential

WORKDIR /Odin-install
# checkout specific commit so we have a tested version, since we're on the master branch
RUN git clone https://github.com/odin-lang/Odin.git /Odin-install \
    && git checkout dev-2024-02 \
    && make

RUN mkdir /opt/Odin \
    && cp -R ./base ./core ./shared ./vendor ./odin /opt/Odin/
WORKDIR /
RUN rm -rf /Odin-install

ENV PATH="/opt/Odin:${PATH}"