CREATE TABLE IF NOT EXISTS ${TARGET_DATABASE_GOLD}.${TARGET_TABLE_PRONTA}(
         dw_clientes string
        ,dw_localidade string
        ,dw_tempo string
        ,discount_amount double
        ,sales_amount double
        ,sales_amount_based_on_list_price double
        ,sales_cost_amount double
        ,sales_margin_amount double
        ,sales_price double
        ,sales_quantity double
        )
        ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
        STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
        OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
        TBLPROPERTIES ('orc.compress'='SNAPPY');

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

 LOAD DATA INPATH '/datalake/gold/ft_vendas/part-00000-4d512f7e-21ed-46d6-b21a-32abd8a3305d-c000.csv' INTO TABLE desafio_curso_gold.ft_vendas;