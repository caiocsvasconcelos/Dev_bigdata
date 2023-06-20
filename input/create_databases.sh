#!/bin/bash

BASEDIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" 
CONFIG="${BASEDIR}/../../config/config.sh"
source "${CONFIG}"

TABLES=("desafio_curso")

for table in "${TABLES[@]}"
do
    TARGET_CREATE_DATABASE="$table"

    beeline -u jdbc:hive2://localhost:10000\
    --hivevar TARGET_CREATE_DATABASE="${TARGET_CREATE_DATABASE}"\
    -f ../../hql/create_database.hql
 done