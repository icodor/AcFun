//
//  AcFun_API.h
//  AcFun
//
//  Created by caiiiac on 14-12-30.
//  Copyright (c) 2014年 caiiiac. All rights reserved.
//

#ifndef AcFun_AcFun_API_h
#define AcFun_AcFun_API_h

//精选
//轮播图片
#define RECOMMEND_LIST @"http://api.acfun.tv/apiserver/recommend/list"
//推荐列表
#define RECOMMEND_PRODUCTEDBYAC @"http://api.acfun.tv/apiserver/recommend/productedByAc"
//视频数据
#define RECOMMEND_PAGE @"http://api.acfun.tv/apiserver/recommend/page?pageSize=10&pageNo=%d"
//频道类别新数据统计
#define CHANNEL_COUNTS @"http://api.acfun.tv/apiserver/home/getUpdateCounts?channelIds=68,69,1,70,59,58,63,60"
/*
 1- 动画
 68 - 影视
 69 - 体育
 70 - 科技
 58 - 音乐
 59 - 游戏
 60 - 娱乐
 63 - 文章
 */

//视频详情
#define CONTENT_ID @"http://api.acfun.tv/apiserver/content/info?contentId=%@&version=2"
//解析视频
#define VIDEO_ID @"http://jiexi.acfun.info/index.php?type=mobileclient&vid=%@"


//用户详情
#define USER_ID @"http://api.acfun.tv/apiserver/profile?userId=%@"


//频道
//热门排行
#define TOPRANKING_PAGE @"http://api.acfun.tv/apiserver/content/rank?pageSize=20&pageNo=%d&channelIds=96,97,98,99,100,93,94,95,106,107,108,109,67,120,90,91,92,122,83,84,85,82,101,102,103,104,105,86,87,88,89,121"
//分类
#define CATEGORY_PAGE1 @"http://api.acfun.tv/apiserver/content/channel?channelIds=%@&pageNo=%d&orderBy=%@&range=%@&recommendSize=4"
#define CATEGORY_PAGE2 @"http://api.acfun.tv/apiserver/content/channel?channelIds=%@&pageNo=%d&orderBy=%@&range=%@"

//本季新番.剧集
#define BANGUMI_TYPES @"http://icao.acfun.tv/bangumi/week?bangumiTypes=%@"

#endif
