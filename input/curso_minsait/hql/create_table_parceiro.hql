
        CREATE EXTERNAL TABLE IF NOT EXISTS aula_hive.parceiro(
            id_categoria string,
            ds_categoria string,
            perc_parceiro string
        )
        COMMENT 'Tabela de parceiro'
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '|'
        STORED AS TEXTFILE
        location '/datalake/raw/parceiro/'
        TBLPROPERTIES ('skip.header.line.count'='1');
        

        CREATE TABLE IF NOT EXISTS aula_hive.tb_parceiro(
                    id_categoria string,
                    ds_categoria string,
                    perc_parceiro string
                )
        PARTITIONED BY (DT_FOTO STRING)
        ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
        STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
        OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
        TBLPROPERTIES ('orc.compress'='SNAPPY');
