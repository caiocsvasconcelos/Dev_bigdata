CREATE TABLE IF NOT EXISTS ${TARGET_DATABASE_GOLD}.${TARGET_TABLE}(
         DW_CLIENTES string
        ,DW_LOCALIDADE string
        ,DW_TEMPO string
        ,valor_venda double 
        ,custo_venda double
        ,preco_unid double
        ,qtd_unid int
        ,magem_venda double
        )
        ROW FORMAT DELIMITED FIELDS TERMINATED BY ';'
        TBLPROPERTIES("skip.header.line.count"="1");


 LOAD DATA INPATH '/datalake/gold/${TARGET_TABLE}/part-00000-a3749519-c9d4-475a-8c43-91b0e01e23a6-c000.csv' OVERWRITE INTO TABLE ${TARGET_DATABASE_GOLD}.${TARGET_TABLE};