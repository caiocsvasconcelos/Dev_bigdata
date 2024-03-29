
        CREATE EXTERNAL TABLE IF NOT EXISTS ${TARGET_DATABASE_STG}.${TARGET_TABLE_EXTERNAL}(
            id_pedido string,
            id_produto string,
            quantidade string,
            vr_unitario string
        )
        COMMENT 'Tabela de item_pedido'
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '|'
        STORED AS TEXTFILE
        location '${HDFS_DIR}'
        TBLPROPERTIES ('skip.header.line.count'='1');
        

        CREATE TABLE IF NOT EXISTS ${TARGET_DATABASE}.${TARGET_TABLE_GERENCIADA}(
             id_pedido string,
            id_produto string,
            quantidade string,
            vr_unitario string   
        )
        PARTITIONED BY (DT_FOTO STRING)
        ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
        STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
        OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
        TBLPROPERTIES ('orc.compress'='SNAPPY');

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE
    ${TARGET_DATABASE}.${TARGET_TABLE_GERENCIADA}
PARTITION(DT_FOTO)
SELECT 
    id_pedido string,
    id_produto string,
    quantidade string,
    vr_unitario string,
    ${PARTICAO} as DT_FOTO  
  FROM  ${TARGET_DATABASE_STG}.${TARGET_TABLE_EXTERNAL}
  ;