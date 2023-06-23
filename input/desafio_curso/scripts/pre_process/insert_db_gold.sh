BASEDIR="$( cd "$(dirname "${BASE_SOURCE[0]}")" && pwd)"
CONFIG="${BASEDIR}/../../config/config.sh"
source "${CONFIG}"

TABLES=("ft_vendas")

for table in "${TABLES[@]}"
do
    TARGET_DATABASE_GOLD="desafio_curso_gold"
    HDFS_DIR="/datalake/gold/$table"
    TARGET_TABLE_PRONTA="$table"

    beeline -u jdbc:hive2://localhost:10000\
    --hivevar TARGET_DATABASE_GOLD="${TARGET_DATABASE_GOLD}"\
    --hivevar TARGET_TABLE_PRONTA="${TARGET_TABLE_PRONTA}"\
    -f ../hql_gold/db_gold_$table.hql
done
    