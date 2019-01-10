<!---
markmeta_author: wongoo
markmeta_date: 2013-09-04 06:24:27
excerpt: Oracle:Rebuild all unusable indexes
slug: oraclerebuilding-all-unusable-indexes
markmeta_title: Oracle:Rebuild all unusable indexes
wordpress_id: 493
markmeta_categories: Experience
markmeta_tags: index,oracle,sql
-->

1. unusable a index:

    alter index GROUPS_PK unusable;


2. find all unusable indexs:

    select * from  user_indexes where status='UNUSABLE';


3. rebuild a unusable index:

    alter index table_owner.index_name rebuild online nologging;


4. rebuild all unusable indexs:

    
    declare 
       cursor cur is select 'alter index '||table_owner || '.' ||index_name ||' rebuild online nologging' as sql_string from user_indexes where status='UNUSABLE';
    begin 
      for item in cur loop
        EXECUTE IMMEDIATE item.sql_string;
      end loop;
    end;
    

