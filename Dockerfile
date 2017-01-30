FROM lsiobase/alpine.python
MAINTAINER BS

# set python to use utf-8 rather than ascii, hopefully resolve special characters in movie names
ENV PYTHONIOENCODING="UTF-8"

RUN apk update \
    && git clone --depth=1 \
           https://github.com/CouchPotato/CouchPotatoServer.git \
           /opt/couchpotato \
	&& rm -rf /var/lib/apt/lists/*

# Monte le dossier "torrents" dans "downloads" afin de permettre le téléchargement personnalisé sur rTorrent 
RUN mkdir /torrents
RUN ln -s /torrents /downloads

VOLUME /config

EXPOSE 5050

ENV POSTP_TIME=5

RUN mkdir -p /etc/periodic/${POSTP_TIME}min
COPY post_couchpotato.sh /etc/periodic/${POSTP_TIME}min/post_couchpotato
RUN chmod -R +x /etc/periodic/

RUN crontab -l | { cat; echo "*/${POSTP_TIME}     *       *       *       *       run-parts /etc/periodic/${POSTP_TIME}min"; } | crontab -

CMD python /opt/couchpotato/CouchPotato.py --data_dir /config
CMD ["crond", "-f", "-d", "8"]