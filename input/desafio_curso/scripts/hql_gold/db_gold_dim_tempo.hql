CREATE TABLE IF NOT EXISTS ${TARGET_DATABASE_GOLD}.${TARGET_TABLE}(
            DW_TEMPO string 
           ,invoice_date date
           ,Ano string
           ,Mes string
           ,Dia string
           ,Trimestre string
        )
        ROW FORMAT DELIMITED FIELDS TERMINATED BY ';'
        TBLPROPERTIES("skip.header.line.count"="1");


 LOAD DATA INPATH '/datalake/gold/${TARGET_TABLE}/part-00000-b8145a6a-5541-440a-a718-9779f03e4f15-c000.csv' OVERWRITE INTO TABLE ${TARGET_DATABASE_GOLD}.${TARGET_TABLE};