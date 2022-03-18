视频统计业务

视频表
字段	备注	详细描述
video id	视频唯一id	11位字符串
uploader	视频上传者	上传视频的用户名String
age	视频年龄	视频在平台上的整数天
category	视频类别	上传视频指定的视频分类
length	视频长度	整形数字标识的视频长度
views	观看次数	视频被浏览的次数
rate	视频评分	满分5分
ratings	流量	视频的流量，整型数字
conments	评论数	一个视频的整数评论数
related ids	相关视频id	相关视频的id，最多20个

用户表
字段	备注	字段类型
uploader	上传者用户名	string
videos	上传视频数	int
friends	朋友数量	int


建表：
create table gulivideo_ori(
    videoId string, 
    uploader string, 
    age int, 
    category array<string>, 
    length int, 
    views int, 
    rate float, 
    ratings int, 
    comments int,
    relatedId array<string>)
row format delimited 
fields terminated by "\t"
collection items terminated by "&"
stored as textfile;

create table gulivideo_user_ori(
    uploader string,
    videos int,
    friends int)
row format delimited 
fields terminated by "\t" 
stored as textfile;

create table gulivideo_orc(
    videoId string, 
    uploader string, 
    age int, 
    category array<string>, 
    length int, 
    views int, 
    rate float, 
    ratings int, 
    comments int,
    relatedId array<string>)
clustered by (uploader) into 8 buckets 
row format delimited fields terminated by "\t" 
collection items terminated by "&" 
stored as orc;
create table gulivideo_user_orc(
    uploader string,
    videos int,
    friends int)
row format delimited 
fields terminated by "\t" 
stored as orc;

需求
统计硅谷影音视频网站的常规指标，各种TopN指标：
--统计视频观看数Top10
select 
    videoId, 
    uploader, 
    age, 
    category, 
    length, 
    views, 
    rate, 
    ratings, 
    comments 
from 
    gulivideo_orc 
order by 
    views 
desc limit 
    10;

--统计视频类别热度Top10

select category1,sum(views) hot
from (select videoId,
       views,
       category1
from gulivideo_orc lateral view explode(category) orc as category1)orc
group by category1
order by hot desc
limit 10;

--统计视频观看数Top20所属类别
//找前20视频
select videoId,category,views
from gulivideo_orc
order by views desc
limit 20;tmp

select videoId,cat
from (select videoId,category,views
from gulivideo_orc
order by views desc
limit 20)tmp lateral view explode(category) t as cat;t

select cat,count(videoId) num
from (select videoId,cat
from (select videoId,category,views
from gulivideo_orc
order by views desc
limit 20)tmp lateral view explode(category) t as cat)t
group by cat
order by num desc;

--统计视频观看数Top50所关联视频的所属类别Rank

select views,relatedId
from gulivideo_orc
order by views desc
limit 50;tmp

select distinct relaId
from (select views,relatedId
from gulivideo_orc
order by views desc
limit 50)tmp lateral view explode(relatedId) tp as relaId;

select videoId,rel
from gulivideo_orc lateral view explode(relatedId) t as rel;

select t2.rel, count(*) num
from (select distinct relaId
from (select views,relatedId
from gulivideo_orc
order by views desc
limit 50)tmp lateral view explode(relatedId) tp as relaId) as t1 left join (select videoId,rel
from gulivideo_orc lateral view explode(relatedId) t as rel) as t2 on t1.relaId=t2.rel
group by t2.rel
order by num;
--统计每个类别中的视频热度Top10
select 
    videoId, 
    views
from 
    gulivideo_category 
where 
    categoryId = "Music" 
order by 
    views 
desc limit
    10;

--统计每个类别中视频流量Top10
select 
    videoId,
    views,
    ratings 
from 
    gulivideo_category 
where 
    categoryId = "Music" 
order by 
    ratings 
desc limit 
    10;

--统计上传视频最多的用户Top10以及他们上传的视频

select 
    t2.videoId, 
    t2.views,
    t2.ratings,
    t1.videos,
    t1.friends 
from (
    select 
        * 
    from 
        gulivideo_user_orc 
    order by 
        videos desc 
    limit 
        10) t1 
join 
    gulivideo_orc t2
on 
    t1.uploader = t2.uploader 
order by 
    views desc 
limit 
    20;
--统计每个类别视频观看数Top10
select 
    t1.* 
from (
    select 
        videoId,
        categoryId,
        views,
        row_number() over(partition by categoryId order by views desc) rank from gulivideo_category) t1 
where 
    rank <= 10;







