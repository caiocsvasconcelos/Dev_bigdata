CREATE EXTERNAL TABLE IF NOT EXISTS ${TARGET_DATABASE}.${TARGET_TABLE_EXTERNAL}(
          string,
          string,
          string  
        )
        COMMENT 'Tabela de vendas'
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '|'
        STORED AS TEXTFILE
        location '${HDFS_DIR}'
        TBLPROPERTIES ("skip.header.line.count"="1");
        

        CREATE TABLE IF NOT EXISTS ${TARGET_DATABASE_SILVER}.${TARGET_TABLE_GERENCIADA}(
          string,
          string,
          string  
        )
        PARTITIONED BY (DT_FOTO STRING)
        ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
        STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
        OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
        TBLPROPERTIES ('orc.compress'='SNAPPY');

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE
    ${TARGET_DATABASE_SILVER}.${TARGET_TABLE_GERENCIADA}
PARTITION(DT_FOTO)
SELECT 
     string,
      string,
      string,
      ${PARTICAO} as DT_FOTO  
  FROM  ${TARGET_DATABASE}.${TARGET_TABLE_EXTERNAL}
  ;