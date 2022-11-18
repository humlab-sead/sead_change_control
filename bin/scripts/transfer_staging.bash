#!/bin/bash

pg_dumpall -h 130.239.57.124 -U humlab_admin --globals-only --file globals.sql
pg_dump -C -c --if-exists -d sead_master_9 --schema public -h 130.239.57.124 -F p -U humlab_admin -f sead_master_9_public.sql
psql -h localhost -U humlab_admin -f sead_master_9_public.sql postgres

