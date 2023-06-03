#cd ../../raw
#mkdir categoria
#cd categoria
#curl -O https://raw.githubusercontent.com/caiuafranca/dados_curso/main/categoria.csv

BASEDIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" 
CONFIG="${BASEDIR}/../../config/config.sh"
source "${CONFIG}"

echo "Iniciando a criação em ${DATA}"

for table in "${TABLES[@]}"
do
    echo "tabela $table"
    cd ../../raw/
    mkdir $table
    chmod 777 $table
    cd $table
    curl -O https://raw.githubusercontent.com/caiuafranca/dados_curso/main/$table.csv

    hdfs dfs -mkdir /datalake/raw/$table
    hdfs dfs -chmod 777 /datalake/raw/$table
    hdfs dfs -copyFromLocal $table.csv /datalake/raw/$table
    
done

for table in "${TABLES[@]}"
do

    cd ../../hql/
    touch create_table_$table.hql
    #chmod 777 $table
    
    echo "
        CREATE EXTERNAL TABLE IF NOT EXISTS aula_hive.$table(
            id_categoria string,
            ds_categoria string,
            perc_parceiro string
        )
        COMMENT 'Tabela de $table'
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '|'
        STORED AS TEXTFILE
        location '/datalake/raw/$table/'
        TBLPROPERTIES ('skip.header.line.count'='1');
        

        CREATE TABLE IF NOT EXISTS aula_hive.tb_$table(
                    id_categoria string,
                    ds_categoria string,
                    perc_parceiro string
                )
        PARTITIONED BY (DT_FOTO STRING)
        ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
        STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
        OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
        TBLPROPERTIES ('orc.compress'='SNAPPY');" > create_table_$table.hql

    beeline -u jdbc:hive2://localhost:10000 -f create_table_$table.hql
    
done
echo "Finalizando a criacao em ${DATE}"