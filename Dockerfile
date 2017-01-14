FROM linuxserver/baseimage.python
MAINTAINER BS

# set python to use utf-8 rather than ascii, hopefully resolve special characters in movie names
ENV PYTHONIOENCODING="UTF-8"

RUN apt-get update \
    && apt-get install --no-install-recommends -y git-core python python-dev python3-lxml \
    && git clone --depth=1 \
           https://github.com/CouchPotato/CouchPotatoServer.git \
           /opt/couchpotato \
    && git clone --depth=1 \
       https://github.com/Snipees/couchpotato.providers.french.git \
       /opt/frenchproviders \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#copy couchpotato.providers.french files to couchpotato
RUN cp -r /opt/frenchproviders/t411 /config/custom_plugins/t411 \
	&& cp -r /opt/frenchproviders/cpasbien /config/custom_plugins/cpasbien \
	&& cp /opt/frenchproviders/namer_check.py /opt/couchpotato/couchpotato/core/helpers/namer_check.py \

# Monte le dossier "torrents" dans "downloads" afin de permettre le téléchargement personnalisé sur rTorrent 
RUN mkdir /torrents
RUN ln -s /torrents /downloads

VOLUME /config

EXPOSE 5050

CMD python /opt/couchpotato/CouchPotato.py --data_dir /config 
