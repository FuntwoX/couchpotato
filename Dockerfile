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

COPY customPlugins.sh /

VOLUME /config

RUN chmod +x customPlugins.sh
CMD /customPlugins.sh

EXPOSE 5050

CMD python /opt/couchpotato/CouchPotato.py --data_dir /config 