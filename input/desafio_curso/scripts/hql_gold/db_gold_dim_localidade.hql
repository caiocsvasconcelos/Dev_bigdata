CREATE TABLE IF NOT EXISTS ${TARGET_DATABASE_GOLD}.${TARGET_TABLE}(
           DW_LOCALIDADE string
          ,region_code int
          ,region_name string
          ,division int
          ,tp_cliente string
          ,address_number int
          ,city string
          ,country string
          ,customer_address_1 string
          ,customer_address_2 string
          ,state string
          ,zip_code string
        )
        ROW FORMAT DELIMITED FIELDS TERMINATED BY ';'
        TBLPROPERTIES("skip.header.line.count"="1");


 LOAD DATA INPATH '/datalake/gold/${TARGET_TABLE}/part-00000-49aa1a95-c122-4fc3-afed-67b324da02a8-c000.csv' OVERWRITE INTO TABLE ${TARGET_DATABASE_GOLD}.${TARGET_TABLE};