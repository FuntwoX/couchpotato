#!/bin/sh

couch_api_key=`grep -m 1 api_key /config/settings.conf | cut -d ' ' -f 3`;
couch_port=`grep -m 1 port /config/settings.conf | cut -d ' ' -f 3`;
wget -q --delete-after http://localhost:${couch_port}/couchpotato/api/${couch_api_key}/renamer.scan