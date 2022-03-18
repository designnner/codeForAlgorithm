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
select videoId,views,category
from gulivideo_orc lateral view explode(category) orc as category

--统计视频观看数Top20所属类别


--统计视频观看数Top50所关联视频的所属类别Rank


--统计每个类别中的视频热度Top10


--统计每个类别中视频流量Top10


--统计上传视频最多的用户Top10以及他们上传的视频


--统计每个类别视频观看数Top10








