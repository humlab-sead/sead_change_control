#!/bin/bash

SHELL=/bin/bash

g_host=
g_user=
g_port=5433
g_database=sead_staging
g_password=

if [ -f ~/vault/.default.sead.server ]; then
    g_host=`cat ~/vault/.default.sead.server`
fi

if [ -f ~/vault/.default.sead.username ]; then
    g_user=`cat  ~/vault/.default.sead.username`
fi

# if [ -f ~/vault/.default.sead.password ]; then
#     g_password=$(cat  ~/vault/.default.sead.password)
# fi

# g_uri=postgres://${g_user}:${g_password}@${g_host}:${g_port}/${g_database}?sslmode=disable
g_uri=postgres://${g_user}@${g_host}:${g_port}/${g_database}?sslmode=disable


docker run --rm -u "$(id -u):$(id -g)" -v $(pwd)/.pgpass:/root/.pgpass -v $PWD:/work -w /work ghcr.io/k1low/tbls doc $g_uri $@
