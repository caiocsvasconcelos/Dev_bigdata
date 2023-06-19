DADOS=("clientes" "divisao" "endereco" "regiao" "vendas")

for table in "${DADOS[@]}"
do
    echo "$table"
    cd ../../raw/
    hdfs dfs -mkdir /datalake/raw/$table
    hdfs dfs -chmod 777 /datalake/raw/$table
    hdfs dfs -copyFromLocal $table.csv /datalake/raw/$table
done