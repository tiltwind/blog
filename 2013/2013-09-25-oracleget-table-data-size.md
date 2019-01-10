<!---
markmeta_author: wongoo
markmeta_date: 2013-09-25 03:41:39
excerpt: Oracle:Get Table Data Size
slug: oracleget-table-data-size
markmeta_title: Oracle:Get Table Data Size
wordpress_id: 508
markmeta_categories: Experience
markmeta_tags: oracle,segment,size,sql,table
-->

SQL Sample:

    
    SELECT segment_name
    	,sum(siz_M) AS siz_M
    FROM (
    	SELECT segment_name
    		,segment_type
    		,bytes / 1024 / 1024 AS siz_M
    	FROM user_segments
    	WHERE segment_type LIKE 'TABLE%'
    		AND segment_name = 'TABLE_NAME' --表名
    	)
    GROUP BY segment_name
    


