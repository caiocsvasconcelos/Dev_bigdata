#! /bin/bash

DATA="$(date --date="-0 day" "+%Y%m$d")"

TABLES=("cidade" "estado" "filial" "parceiro" "cliente" "subcategoria" "categoria" "item_pedido" "produto" "pedido")
TABELA_CLIENTE="TBL_CLIENTE"

TARGET_DATABASE="aula_hive" 
HDFS_DIR="/datalake/raw/categoria/"
TARGET_TABLE_EXTERNAL="categoria"
TARGET_TABLE_GERENCIADA="tb_categoria"

PARTICAO="$(date --date="-0 day" "+%Y%m$d")"