#! /bin/bash

DATA="$(date --date="-0 day" "+%Y%m$d")"

TABLES=("cidade" "estado" "filial" "parceiro" "cliente" "subcategoria" "categoria" "item_pedido" "produto" "pedido")
TABELA_CLIENTE="TBL_CLIENTE"

PARTICAO=""