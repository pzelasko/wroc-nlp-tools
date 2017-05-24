FROM ubuntu:12.04
LABEL maintainer "<pzelasko@agh.edu.pl>"

RUN apt-get update -qq -y && apt-get install -qq -y wget

ADD *.sh /
ENV TOOLS_SET_VERSION_NUMBER=5
RUN bash /dependencies.sh
RUN bash /maca.sh
RUN bash /wcrft.sh

# Install wcrft2
RUN rm -rf /wcrft2
RUN git clone http://nlp.pwr.wroc.pl/wcrft2.git /wcrft2
WORKDIR /wcrft2
RUN mkdir bin && cd bin && cmake .. && make -j && make install
RUN ldconfig
WORKDIR /
