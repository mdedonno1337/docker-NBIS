################################################################################
#
#   Build environnement
#
################################################################################

FROM debian as builder
MAINTAINER Marco De Donno <Marco.DeDonno@unil.ch>

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y unzip build-essential cmake

COPY ./nbis_v5_0_0.zip /

RUN unzip ./nbis_v5_0_0.zip

RUN mkdir /nbis

RUN cd /Rel_5.0.0 && \
	./setup.sh /nbis/ --without-X11 --64 && \
	make config && \
	make it && \
	make install

################################################################################
#
#   Running environnement
#
################################################################################

FROM debian
MAINTAINER Marco De Donno <Marco.DeDonno@unil.ch>

COPY --from=builder /nbis /nbis
