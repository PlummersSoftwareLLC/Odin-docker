FROM ubuntu:20.04

# Odin needs llvm and clang for building itself as well as building .odin files on *Nix systems
RUN apt-get update -qq \
    && apt-get install -y llvm-11 clang git build-essential

WORKDIR /opt/Odin
# checkout specific commit so we have a tested version, since we're on the master branch
RUN git clone https://github.com/odin-lang/Odin.git /opt/Odin \
    && git checkout 481fc8a5b60cf15d \
    && make