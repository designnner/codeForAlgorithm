以下表记录了用户每天的蚂蚁森林低碳生活领取的记录流水。
table_name:user_low_carbon
user_id data_dt low_carbon
用户     日期     减少碳排放

蚂蚁森林植物换购表，用于记录申领环保植物所需要的碳排放量
table_name: plant_carbon
plant_id plant_name low_carbon
植物编号   植物名。     换购植物所需要的碳

create table user_low_carbon(
    user_id string,
    data_dt string,
    low_carbon int)
    row format delimited fields terminated by'\t';
create table plant_carbon(
     plant_id string,
     plant_name string,
     low_carbon int)
     row format delimited fields terminated by '\t';
     
     -------题目
     1.蚂蚁森林植物申领统计
     假设2017年1月1日开始记录低碳数据（user_low_carbon），假设2017年10月1日之前满足申领条件的用户都申领了一棵p004杨剩余的能量全部用来领取“p002-沙柳”。
     统计在10月1日累计申领“p002-沙柳”排名前10的用户信息；以及他比后一名多领了几颗沙柳。
     统计结果：
     user_id plant_count less_count
     u_101  1000  100
     u_088  900 400
     u_103  500 ...
     
     //查询碳和
     select user_id,sum(low_carbon) as low_carbon
     from user_low_carbon
     where date_format(regexp_replace(data_dt,'/','-'),'yyyy-MM')<'2017-10'
     group by user_id;t1
     //查询树所需碳
     select low_carbon from plant_carbon where plant_id='p004';t2
     
     select low_carbon from plant_carbon where plant_id='p002';t3
     
     select user_id,floor((t1.low_carbon-t2.low_carbon)/t3.low_carbon) as num
     from (select user_id,sum(low_carbon) as low_carbon
     from user_low_carbon
     where date_format(regexp_replace(data_dt,'/','-'),'yyyy-MM')<'2017-10'
     group by user_id)t1,
          (select low_carbon from plant_carbon where plant_id='p004')t2,
          (select low_carbon from plant_carbon where plant_id='p002')t3;t4
          
     select user_id,plant_count,row_number() over(order by plant_count desc),plant_count-lead(plant_count,1) over(order by plant_count desc)
     from (select user_id,floor((t1.low_carbon-t2.low_carbon)/t3.low_carbon) as plant_count
     from (select user_id,sum(low_carbon) as low_carbon
     from user_low_carbon
     where date_format(regexp_replace(data_dt,'/','-'),'yyyy-MM')<'2017-10'
     group by user_id)t1,
          (select low_carbon from plant_carbon where plant_id='p004')t2,
          (select low_carbon from plant_carbon where plant_id='p002')t3)t4
     order by plant_count desc
     limit 10;
          
     2.蚂蚁森林低碳用户排名分析
     问题：查询user_low_carbon表中每日流水记录，条件为：
     用户在2017年，连续三天或以上的天数里，每天减少碳排放，都超过100g的用户低碳流水。
     需要查询返回满足以上条件的user_low_carbon表中的记录流水。
     例如用户u_002符合条件的记录如下，因为2017/1/2～2017/1/5连续四天的碳排放量之和都大于等于100g：
     seq  user_id data_dt low_carbon
     xxxxx10  u_002 2017/1/2  150
     xxxxx11  u_002 2017/1/2  70
     xxxxx12  u_002 2017/1/3  30
     
     //查询2017年的每个用户每天碳排放和>100
     select user_id,data_dt
     from user_low_carbon
     where substring(data_dt,1,4)='2017'
     group by user_id,data_dt
     having sum(low_carbon)>100;t1
     
     
     
     select user_id,data_dt,lead(data_dt) over(distribute by user_id sort by data_dt) lead,lag(data_dt) over(distribute by user_id sort by data_dt) lag
     from user_low_carbon
     where substring(data_dt,1,4)='2017'
     group by user_id,data_dt
     having sum_low_carbon>100;
     
     
     
     select user_id,regexp_replace(substring(t1.data_dt,8,1),'/','') day
     from (select user_id,data_dt
     from user_low_carbon
     where substring(data_dt,1,4)='2017'
     group by user_id,data_dt
     having sum(low_carbon)>100)t1;
     
     
     select user_id,day,lead(day,1) over(distribute by user_id sort by day) lead,lag(day,1) over(distribute by user_id sort by day) lag
     from (select user_id,regexp_replace(substring(t1.data_dt,8,1),'/','') day
     from (select user_id,data_dt
     from user_low_carbon
     where substring(data_dt,1,4)='2017'
     group by user_id,data_dt
     having sum(low_carbon)>100)t1)t2;
          
          
     select user_id,day
     from (select user_id,day,lead(day,1) over(distribute by user_id sort by day) lead1,lead(day,2) over(distribute by user_id sort by day) lead2,lag(day,1) over(distribute by user_id sort by day) lag1,
           lag(day,2) over(distribute by user_id sort by day) lag2
     from (select user_id,regexp_replace(substring(t1.data_dt,8,1),'/','') day
     from (select user_id,data_dt
     from user_low_carbon
     where substring(data_dt,1,4)='2017'
     group by user_id,data_dt
     having sum(low_carbon)>100)t1)t2)t3
     where (day-lag1=1 and lead1-day=1)or(day-lag2=2 and day-lag1=1) or(lead1-day=1 and lead2-day=2);
          
          
          
          
          
          
          
          
