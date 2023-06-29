**DESAFIO BIG DATA/MODELAGEM**

📌 **ESCOPO DO DESAFIO**
Neste desafio serão feitas as ingestões dos dados que estão na pasta /raw onde vamos ter alguns arquivos .csv de um banco relacional de vendas.
s
 - VENDAS.CSV
 - CLIENTES.CSV
 - ENDERECO.CSV
 - REGIAO.CSV
 - DIVISAO.CSV

Seu trabalho como engenheiro de dados/arquiteto de BI é prover dados em uma pasta desafio_curso/gold em .csv para ser consumido por um relatório em PowerBI que deverá ser construído dentro da pasta 'app' (já tem o template).

📑 **ETAPAS**
**Etapa 1 -** Enviar os arquivos para o HDFS
    - nesta etapa lembre de criar um shell script para fazer o trabalho repetitivo (não é obrigatório)

**Etapa 2 -** Criar o banco DEASFIO_CURSO e dentro tabelas no Hive usando o HQL e executando um script shell dentro do hive server na pasta scripts/pre_process.

    - DESAFIO_CURSO (nome do banco)
        - TBL_VENDAS
        - TBL_CLIENTES
        - TBL_ENDERECO
        - TBL_REGIAO
        - TBL_DIVISAO

**Etapa 3 -** Processar os dados no Spark Efetuando suas devidas transformações criando os arquivos com a modelagem de BI.
OBS. o desenvolvimento pode ser feito no jupyter porem no final o codigo deve estar no arquivo desafio_curso/scripts/process/process.py

**Etapa 4 -** Gravar as informações em tabelas dimensionais em formato cvs delimitado por ';'.

        - FT_VENDAS
        - DIM_CLIENTES
        - DIM_TEMPO
        - DIM_LOCALIDADE

**Etapa 5 -** Exportar os dados para a pasta desafio_curso/gold

**Etapa 6 -** Criar e editar o PowerBI com os dados que você trabalhou.

No PowerBI criar gráficos de vendas.
**Etapa 7 -** Criar uma documentação com os testes e etapas do projeto.

**REGRAS**
Campos strings vazios deverão ser preenchidos com 'Não informado'.
Campos decimais ou inteiros nulos ou vazios, deversão ser preenchidos por 0.
Atentem-se a modelagem de dados da tabela FATO e Dimensão.
Na tabela FATO, pelo menos a métrica <b>valor de venda</b> é um requisito obrigatório.
Nas dimensões deverá conter valores únicos, não deverá conter valores repetidos.
para a dimensão tempo considerar o campo da TBL_VENDAS <b>Invoice Date</b>

## ✔️ ESTRUTURA E RESOLUTIVA

1. Para esse projeto foi criado no Github um fork no link a baixo, pegando todas as branchs em:  https://github.com/caiuafranca/bigdata_docker/tree/ambiente-curso

2. Criado um clone do ambiente-curso 

3. No gitpod, logado e apontando para seu projeto no github.

4. No gitpod, liberar todas as permissões em:

5. Conta >  Gitpod: Open Acesson Control > Github > (...) > Marcar todos

6. Ao executar o docker-compose up –d dentro do diretório bibdata_docker será foi criado o diretório "input"

7. Realizar uploud da estrutura **desafio_curso**

8. **desafio_curso** tem a seguinte estrutura de diretórios \n
   **app:** Diretório do arquivo de execução do **app/Projeto Vendas.pbix**.
   **config:** Diretório de do .sh de configurações gerais do projeto
   **gold:** Diretório dos arquivos dimensionais
   **raw:** Diretório dos arquivos fonte de dados em .csv
   **run:** Diretório do PowerShell process que executará o processo process.py
   **scripts:** 
     **/hql:**  Diretório que conterá os arquivos .hql. Cada arquivo tem três estruturas:
        - Criação das estruturas de banco Externa no Hive, fazendo uso dos dados do HDFS; 
        - Criação das tabelas Internas ou gerenciadas, também dentro do Hive; 
        - Carga de dados nas tabelas gerenciadas a partir dos dados do HDFS, adicionando na carga um campo de versionamento da carga (dt_foto)
     **/hql:** Temos também um .hql exclusivo para a criação dos bancos de dados que serão utilizados   
     **/pre_process:** Diretório para armazenar os Powershell que:
        - **create_env_all.sh** - Cria estruturas no HDFS com base no nome dos arquivos contidos no diretório "raw"
                                - Aplica permissões de manipulação
                                - Copia os arquivos locais do diretório "raw" para o datalake\raw
        - **create_databases.sh** - Cria banco de dados
        - **create_env_charg_tables.sh** - Tem por finalidade, através do comando "beeline" executar os .hql. É por meio desse PowerShell que se passa todos os parâmetros utilizados nos arquivos .hql devidamente sincronizados por arquivo/tabela. 
        - **insert_db_gold.sh** - Para esse powerShell será usado as tabelas dimencionais que foram armazenadas no **/datalake/gold/** e será criado as tabelas do banco dimencional e carregado os dados contidos no arquivo. Vale se atentar que ao realizar esse processo o hive move o arquivo que está na estrutura **/datalake/gold/**/ .csv para dentro do diretório raiz do banco **/user/hive/warehouse/desafio_curso_gold.db**
     **/process:** Nesse diretório encontra-se o arquivo process.py 
        - **process.py** - nesse arquivo encontra-se toda a estrutura spark e pyspark utilizada para o devido tratamento dos dados contidos no banco gerenciado. Após todo o tratamento, é realizado o processo de exportar os dados dimensionais gerados
     para o HDFS "datalake/gold" assim como é armazenado de forma local no diretório "desafio_curso/gold".

**Ordem e local para executar os devidos comandos:**

0. dentro de \bigdata_docker executar ``docker-compose up -d`` para baixar e iniciar os container ou simplesmente ``docker-compose start`` para apenas iniciar os container
1. ``$ docker exec -it hive-server bash`` para acessar o container via bash 
2. root@hive_server:/input/desafio_curso/scripts/pre_process# ``./create_env_all.sh``
3. root@hive_server:/input/desafio_curso/scripts/pre_process# ``./create_databases.sh``   
4. root@hive_server:/input/desafio_curso/scripts/pre_process# ``./create_env_charg_tables.sh``
5. Em um novo terminal, ou fora do hive-server acessar o **jupyter-spark**  ``$ docker exec -it jupyter-spark bash``
6. root@jupyter-spark:/input/desafio_curso/run#  ``./process.sh``
7. root@hive_server:/input/desafio_curso/scripts/pre_process# ``./insert_db_gold.sh``
7. Abrir o app/Projeto Vendas.pbix

