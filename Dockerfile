ARG CUDA_VER=9.1
ARG ETHMINER_VER=0.16.2

FROM nvidia/cuda:${CUDA_VER}-devel as build
ARG ETHMINER_VER
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update&&apt-get install -y git cmake
RUN git clone https://github.com/ethereum-mining/ethminer.git \
	&& cd ethminer \
	&& git checkout v${ETHMINER_VER} \
	&& git submodule update --init --recursive \
	&& cmake . -DETHASHCL=OFF -DETHASHCUDA=ON -DAPICORE=OFF \
	&& make install

FROM nvidia/cuda:${CUDA_VER}-base
LABEL maintainer="Alexander Gerasiov"
COPY --from=build /usr/local/bin/ethminer .
ENTRYPOINT ["/ethminer", "-U"]
