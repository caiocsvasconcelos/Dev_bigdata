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

    hdfs dfs -mkdir /datalake/raw/$tabela
    hdfs dfs -chmod 777 /datalake/raw/$tabela
    hdfs dfs -copyFromLocal $tabela.csv /datalake/raw/$tabela

done

echo "Finalizando a criacao em ${DATE}"