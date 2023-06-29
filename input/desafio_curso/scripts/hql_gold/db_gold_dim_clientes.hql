CREATE TABLE IF NOT EXISTS ${TARGET_DATABASE_GOLD}.${TARGET_TABLE}(
         DW_CLIENTES string
        ,business_family string
        ,cliente string
        ,customerkey string
        ,grp_cliente string
        ,line_of_business string
        ,phone string
        ,regional_sales_mgr string
        ,search_type string
        )
        ROW FORMAT DELIMITED FIELDS TERMINATED BY ';'
        TBLPROPERTIES("skip.header.line.count"="1");


 LOAD DATA INPATH '/datalake/gold/${TARGET_TABLE}/part-*.csv' OVERWRITE INTO TABLE ${TARGET_DATABASE_GOLD}.${TARGET_TABLE};