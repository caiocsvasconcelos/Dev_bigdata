
BASEDIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" 
CONFIG="${BASEDIR}/../../config/config.sh"
source "${CONFIG}"

echo "Iniciando a criação em ${DATA}"

for table in "${TABLES[@]}"
do

    cd ../../hql/
    touch create_table_$table.hql
    chmod 777 create_table_$table.hql
    
   # echo "
   #     CREATE EXTERNAL TABLE IF NOT EXISTS aula_hive.$table(
   #         
   #     )
   #     COMMENT 'Tabela de $table'
   #     ROW FORMAT DELIMITED
   #     FIELDS TERMINATED BY '|'
   #     STORED AS TEXTFILE
   #     location '/datalake/raw/$table/'
   #     TBLPROPERTIES ('skip.header.line.count'='1');
   #     
#
   #     CREATE TABLE IF NOT EXISTS aula_hive.tb_$table(
   #                 
   #             )
   #     PARTITIONED BY (DT_FOTO STRING)
   #     ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
   #     STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
   #     OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
   #     TBLPROPERTIES ('orc.compress'='SNAPPY');" > create_table_$table.hql

    #beeline -u jdbc:hive2://localhost:10000 -f create_table_$table.hql
    
done
echo "Finalizando a criacao em ${DATE}"