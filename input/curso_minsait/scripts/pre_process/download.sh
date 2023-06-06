
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

echo "Finalizando a criacao em ${DATE}"