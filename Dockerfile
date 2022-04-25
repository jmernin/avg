FROM rocker/r-base:latest

COPY pptx2ari.sh /usr/local/bin
COPY gs2ari.sh /usr/local/bin

RUN apt-get update \
  && apt-get install -y \
       libpoppler-cpp-dev \
       ffmpeg \
       libavfilter-dev \
       libtesseract-dev \
       libleptonica-dev \
       tesseract-ocr-eng \
       libwebp-dev \
       libgdal-dev \
       imagemagick \
       r-cran-httr \
       libssl-dev \
       libmagick++-dev \
       libfontconfig-dev \
       libxml2-dev \
       libsodium-dev \
       cargo \
       default-jre \
       libreoffice-java-common \
       libreoffice \
       wget && \
       rm -rf /var/lib/apt/lists/*

RUN install2.r --error --deps TRUE \
       magick googledrive tuber pdftools aws.polly usethis docxtractr

RUN installGithub.r --deps TRUE \
       jhudsl/ariExtra jhudsl/ari jhudsl/text2speech jhudsl/didactr

RUN echo "/usr/lib/libreoffice/program/" > /etc/ld.so.conf.d/openoffice.conf && \
       ldconfig && \
       chmod +x /usr/local/bin/pptx2ari.sh && \
       chmod +x /usr/local/bin/gs2ari.sh && \
       rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
       rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/RedHatOfficial/RedHatFont/archive/4.0.2.tar.gz -O /root/RedHatFont.tar.gz
RUN mkdir -pv /root/RedHatFont
RUN tar zxvf /root/RedHatFont.tar.gz --directory /root/RedHatFont
RUN ls -al /root/RedHatFont*
RUN cp -v /root/RedHatFont*/fonts/*/*.ttf /usr/share/fonts
RUN fc-cache -f -v
RUN rm -fr /root/RedHatFont.tar.gz /root/RedHatFont*

RUN useradd avg \
  && echo "avg:avg" | chpasswd \
       && mkdir /home/avg \
       && chown avg:avg /home/avg \
       && addgroup avg staff

CMD ["bash"]
