TABLES=("desafio_curso" "desafio_curso_silver" "desafio_curso_gold")

for table in "${TABLES[@]}"
do
    TARGET_DATABASE="$table"

    beeline -u jdbc:hive2://localhost:10000\
    --hivevar TARGET_DATABASE="${TARGET_DATABASE}"\
    -f ../hql/create_db.hql
done
    