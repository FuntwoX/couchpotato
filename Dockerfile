FROM lsiobase/alpine.python
MAINTAINER BS

# set python to use utf-8 rather than ascii, hopefully resolve special characters in movie names
ENV PYTHONIOENCODING="UTF-8"

RUN apk update \
    && git clone --depth=1 \
           https://github.com/CouchPotato/CouchPotatoServer.git \
           /opt/couchpotato \
    && git clone --depth=1 \
       https://github.com/Snipees/couchpotato.providers.french.git \
       /opt/frenchproviders \
	&& rm -rf /var/lib/apt/lists/*

# Monte le dossier "torrents" dans "downloads" afin de permettre le téléchargement personnalisé sur rTorrent 
RUN mkdir /torrents
RUN ln -s /torrents /downloads

VOLUME /config

#copy couchpotato.providers.french files to couchpotato
RUN mkdir -p /config/custom_plugins/t411 /config/custom_plugins/cpasbien

COPY /opt/frenchproviders/t411 /config/custom_plugins/t411
COPY /opt/frenchproviders/cpasbien /config/custom_plugins/cpasbien
COPY /opt/frenchproviders/namer_check.py /opt/couchpotato/couchpotato/core/helpers/namer_check.py

EXPOSE 5050

CMD python /opt/couchpotato/CouchPotato.py --data_dir /config 