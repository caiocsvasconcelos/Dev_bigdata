#!/bin/bash

BASEDIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" 
CONFIG="${BASEDIR}/../../config/config.sh"
source "${CONFIG}"

TABLES=("cidade" "estado" "filial" "parceiro" "cliente" "subcategoria" "categoria" "item_pedido" "produto" "pedido")

for table in "${TABLES[@]}"
do

    TARGET_DATABASE="aula_hive" 
    HDFS_DIR="/datalake/raw/$table"
    TARGET_TABLE_EXTERNAL="$table"
    TARGET_TABLE_GERENCIADA="tb_$table"


    beeline -u jdbc:hive2://localhost:10000 \
    --hivevar TARGET_DATABASE="${TARGET_DATABASE}"\
    --hivevar HDFS_DIR="${HDFS_DIR}"\
    --hivevar TARGET_TABLE_EXTERNAL="${TARGET_TABLE_EXTERNAL}"\
    --hivevar TARGET_TABLE_GERENCIADA="${TARGET_TABLE_GERENCIADA}"\
    --hivevar PARTICAO="${PARTICAO}"\
    -f ../../hql/create_table_$table.hql
 done