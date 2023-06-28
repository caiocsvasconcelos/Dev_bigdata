from pyspark.sql import SparkSession, dataframe
from pyspark.sql.types import StructType, StructField
from pyspark.sql.types import DoubleType, IntegerType, StringType
from pyspark.sql import HiveContext
from pyspark.sql.functions import *
from pyspark.sql import functions as f
import os
import re  

spark=SparkSession.builder.master("local[*]")\
    .enableHiveSupport()\
    .getOrCreate()

#spark = SparkSession.builder.master("local[*]")\
#    .enableHiveSupport()\
#    .getOrCreate()


df_clientes = spark.sql("select * from desafio_curso_silver.tb_clientes")
df_divisao = spark.sql("select * from desafio_curso_silver.tb_divisao")
df_endereco = spark.sql("select * from desafio_curso_silver.tb_endereco")
df_regiao = spark.sql("select * from desafio_curso_silver.tb_regiao")
df_vendas = spark.sql("select * from desafio_curso_silver.tb_vendas")   

df_clientes.createOrReplaceTempView('vw_clientes')
df_divisao.createOrReplaceTempView('vw_divisao')
df_endereco.createOrReplaceTempView('vw_endereco')
df_regiao.createOrReplaceTempView('vw_regiao')
df_vendas.createOrReplaceTempView('vw_vendas')


query = ''' 
select  address_number
       , business_family
       , business_unit
       , customer
       , customerkey
       , customer_type
       , division
       , line_of_business
       , phone
       , region_code
       , regional_sales_mgr
       , search_type
       , city
       , country
       , customer_address_1
       , customer_address_2
       , state
       , zip_code
       , region_name
       , division_name
       , invoice_date
       , item_class 
       , item_number
       , item
       ,CASE WHEN x.sales_price IS NOT NULL THEN x.sales_price ELSE 0 END AS sales_price
       ,CASE WHEN x.sales_amount IS NOT NULL THEN x.sales_amount ELSE 0 END AS sales_amount
       ,CASE WHEN x.sales_cost_amount IS NOT NULL THEN x.sales_cost_amount ELSE 0 END AS sales_cost_amount
       ,CASE WHEN x.sales_margin_amount IS NOT NULL THEN x.sales_margin_amount ELSE 0 END AS sales_margin_amount 
       , sales_quantity 
       , um
  from (
SELECT   c.address_number
       , c.business_family
       , c.business_unit
       , c.customer
       , c.customerkey
       , c.customer_type
       , c.division
       , CASE 
             WHEN c.line_of_business <> '   ' THEN c.line_of_business 
             ELSE 'Não informado'
          END line_of_business
       , phone
       , c.region_code
       , c.regional_sales_mgr
       , c.search_type
        , CASE 
              WHEN e.city <> '                         ' THEN e.city
              ELSE 'Não informado'
           END city
        , e.country
        , CASE 
              WHEN e.customer_address_1 <> '                                        ' THEN e.customer_address_1
              ELSE 'Não informado'
           END customer_address_1
        , CASE 
              WHEN e.customer_address_2 <> '                                        ' THEN e.customer_address_2
              ELSE 'Não informado'
           END customer_address_2
        , CASE 
              WHEN e.state <> '' THEN e.state
              ELSE 'Não informado'
           END state
        , CASE 
              WHEN e.zip_code <> '            ' THEN e.zip_code
              ELSE 'Não informado'
           END zip_code
        , r.region_name
        , d.division_name
       , from_unixtime(unix_timestamp(v.invoice_date , 'dd/MM/yyyy')) AS invoice_date
       , v.item_class 
       , v.item_number
       , v.item
       , abs(Replace (v.sales_amount, "," , "." )) AS sales_amount
       , abs(Replace (v.sales_cost_amount, "," , "." )) AS sales_cost_amount
       , abs(Replace (v.sales_margin_amount, "," , "." )) AS sales_margin_amount
       , abs(Replace (v.sales_price, "," , "." )) AS sales_price
       , v.sales_quantity 
       , v.um
  FROM vw_vendas v
  LEFT JOIN vw_clientes c
    ON c.customerkey = v.customerkey
  LEFT JOIN vw_endereco e
    ON e.address_number = c.address_number 
  LEFT JOIN vw_regiao r
    ON r.region_code = c.region_code 
  LEFT JOIN vw_divisao d
    ON d.division = c.division
WHERE 1=1
   AND v.customerkey <> ''
   ) x
'''

df_stage = spark.sql(query)


df_stage = (df_stage
            .withColumn('Ano', year(df_stage.invoice_date))
            .withColumn('Mes', month(df_stage.invoice_date))
            .withColumn('Dia', dayofmonth(df_stage.invoice_date))
            .withColumn('Trimestre', quarter(df_stage.invoice_date))
           )


df_stage = df_stage.withColumn("DW_CLIENTES", sha2(concat_ws("", df_stage.customerkey), 256))
df_stage = df_stage.withColumn("DW_TEMPO", sha2(concat_ws("", df_stage.invoice_date, df_stage.Ano, df_stage.Mes, df_stage.Dia), 256))
df_stage = df_stage.withColumn("DW_LOCALIDADE", sha2(concat_ws("", df_stage.division, df_stage.region_code, df_stage.address_number), 256))

df_stage.createOrReplaceTempView('stage')

#Criando a dimensão Clientes
dim_clientes = spark.sql('''
    SELECT DISTINCT DW_CLIENTES
        ,business_family
        ,customer as cliente
        ,cast(customerkey as string) as customerkey
        ,customer_type as grp_cliente
        ,line_of_business
        ,phone
        ,regional_sales_mgr
        ,search_type
    FROM stage    
''')


#Criando a dimensão Tempo
dim_tempo = spark.sql('''
    SELECT DISTINCT DW_TEMPO
           ,invoice_date
           ,Ano
           ,Mes
           ,Dia
           ,Trimestre
    FROM stage    
''')


#Criando a dimensão Localidade
dim_localidade = spark.sql('''
    SELECT DISTINCT DW_LOCALIDADE
          ,cast(region_code as int) as region_code
          ,region_name
          ,cast(division as int) as division
          ,division_name as tp_cliente
          ,cast(address_number as int) as address_number
          ,city
          ,country
          ,customer_address_1
          ,customer_address_2
          ,state
          ,zip_code
    FROM stage    
''')


#Criando a Fato Pedidios
ft_vendas = spark.sql('''
    SELECT cast(DW_CLIENTES as string) as DW_CLIENTES
        , cast(DW_LOCALIDADE as string) as DW_LOCALIDADE
        , cast(DW_TEMPO as string) as DW_TEMPO
        ,sum(sales_amount) as valor_venda
        ,sum(sales_cost_amount) as custo_venda
        ,sum(sales_price) as preco_unid
        ,count(sales_quantity) as qtd_unid
        ,sum(sales_margin_amount) as magem_venda 
    FROM stage
    group by DW_CLIENTES
            ,DW_LOCALIDADE
            ,DW_TEMPO
''')


# função para salvar os dados
def salvar_df(df, file):
    output = "/input/desafio_curso/gold/" + file
    erase = "hdfs dfs -rm " + output + "/*"
    local = "rm /input/desafio_curso/gold/"+ file+".csv"
    rename = "hdfs dfs -get /datalake/gold/"+file+"/part-* /input/desafio_curso/gold/"+file+".csv"
    print(rename)
    
    df.coalesce(1).write\
        .format("csv")\
        .option("header", True)\
        .option("delimiter", ";")\
        .mode("overwrite")\
        .save("/datalake/gold/"+file+"/")  
    os.system(erase)
    os.system(local)
    os.system(rename)


salvar_df(ft_vendas, 'ft_vendas')
salvar_df(dim_clientes, 'dim_clientes')
salvar_df(dim_tempo, 'dim_tempo')
salvar_df(dim_localidade, 'dim_localidade')


from pyspark.sql import SparkSession, dataframe
from pyspark.sql.types import StructType, StructField
from pyspark.sql.types import DoubleType, IntegerType, StringType
from pyspark.sql import HiveContext
from pyspark.sql.functions import *
from pyspark.sql import functions as f
import os
import re
#
#spark = SparkSession.builder.master("local[*]")\
#    .enableHiveSupport()\
#    .getOrCreate()
#
## Criando dataframes diretamente do Hive
#df_clientes = spark.sql("SELECT * FROM DESAFIO_CURSO.TBL_CLIENTES")
#
## Espaço para tratar e juntar os campos e a criação do modelo dimensional
#
## criando o fato
#ft_vendas = []
#
##criando as dimensões
#dim_clientes = []
#
## função para salvar os dados
#def salvar_df(df, file):
#    output = "/input/desafio_hive/gold/" + file
#    erase = "hdfs dfs -rm " + output + "/*"
#    rename = "hdfs dfs -get /datalake/gold/"+file+"/part-* /input/desafio_hive/gold/"+file+".csv"
#    print(rename)
#    
#    
#    df.coalesce(1).write\
#        .format("csv")\
#        .option("header", True)\
#        .option("delimiter", ";")\
#        .mode("overwrite")\
#        .save("/datalake/gold/"+file+"/")
#
#    os.system(erase)
#    os.system(rename)
#
#salvar_df(dim_clientes, 'dimclientes')