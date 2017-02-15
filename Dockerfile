FROM lsiobase/alpine.python
MAINTAINER BS

# set python to use utf-8 rather than ascii, hopefully resolve special characters in movie names
ENV PYTHONIOENCODING="UTF-8"

RUN apk update \
    && git clone --depth=1 \
           https://github.com/CouchPotato/CouchPotatoServer.git \
           /opt/couchpotato \
	&& rm -rf /var/lib/apt/lists/*

# Mount folder "torrents" on "downloads" to allow custom download on rTorrent 
RUN mkdir /torrents
RUN ln -s /torrents /downloads

VOLUME /config

EXPOSE 5050

#postprocessing force timing
ENV POSTP_TIME=5

#cronjob creation
RUN mkdir -p /etc/periodic/${POSTP_TIME}min
COPY post_couchpotato.sh /etc/periodic/${POSTP_TIME}min/post_couchpotato
RUN chmod -R +x /etc/periodic/
RUN crontab -l | { cat; echo "*/${POSTP_TIME}     *       *       *       *       run-parts /etc/periodic/${POSTP_TIME}min"; } | crontab -

#supervisord install and conf
ENV SUPERVISOR_VERSION=3.3.1
RUN pip install supervisor==$SUPERVISOR_VERSION
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/cron.ini /etc/supervisord.d/cron.ini
COPY config/couchpotato.ini /etc/supervisord.d/couchpotato.ini

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]