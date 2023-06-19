
#BASEDIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" 
#CONFIG="${BASEDIR}/../../config/config.sh"
#source "${CONFIG}"

# Criação das pastas
#TABLES=("CLIENTE" "DIVISAO" "ENDERECO" "REGIAO" "VENDAS")

 echo "Iniciando a criação em ${DATA}"

for table in "${TABLES[@]}"
do
    #echo "$table"
    #cd ../../raw/
    hdfs dfs -mkdir /datalake/raw/$table
    hdfs dfs -chmod 777 /datalake/raw/$table
    hdfs dfs -copyFromLocal $table.csv /datalake/raw/$table
    #beeline -u jdbc:hive2://localhost:10000 -f ../../scripts/hql/create_table_$i.hql 

done

#echo "Finalizando a criacao em ${DATE}"