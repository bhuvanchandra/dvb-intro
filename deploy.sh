#!/bin/bash

HUGO=/usr/bin/hugo
RSYNC=/usr/bin/rsync

USER=dvb
HOST=www.bhuvanchandradv.com
DEPLOY_DIR=/srv/http/
THEME=hugo-theme-introduction

${HUGO} -t ${THEME} -v && ${RSYNC} -avz --delete public/ ${USER}@${HOST}:${DEPLOY_DIR}

exit 0
