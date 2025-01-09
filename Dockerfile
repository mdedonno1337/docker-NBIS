################################################################################
#
#   Build environnement
#
################################################################################

FROM debian:12 as builder
MAINTAINER Marco De Donno <Marco.DeDonno@unil.ch>

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y unzip build-essential cmake

COPY ./nbis_v5_0_0.zip /

RUN unzip ./nbis_v5_0_0.zip

COPY ./patches/ /nbis/Rel_5.0.0/patches

RUN cd /Rel_5.0.0 && \
    ./setup.sh /nbis/ --without-X11 --64 && \
    make config && \
    find /nbis/Rel_5.0.0/patches/ -type f -name '*.patch' -print0 | sort -z | xargs -0 -n 1 patch -p1 -i && \
    make it && \
    make install

################################################################################
#
#   Running environnement
#
################################################################################

FROM debian:12
MAINTAINER Marco De Donno <Marco.DeDonno@unil.ch>

COPY --from=builder /nbis/bin /nbis
