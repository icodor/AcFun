//
//  BangumiModel.h
//  AcFun
//
//  Created by caiiiac on 15-1-11.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BangumiModel : NSObject

@property (retain, nonatomic) NSNumber *allowDanmaku;
@property (retain, nonatomic) NSNumber *avgScore;
@property (retain, nonatomic) NSNumber *comments;
@property (retain, nonatomic) NSNumber *displayIos;
@property (retain, nonatomic) NSNumber *displayMobile;
@property (retain, nonatomic) NSNumber *displayNew;
@property (retain, nonatomic) NSNumber *displayWeb;
@property (retain, nonatomic) NSNumber *heat;
@property (retain, nonatomic) NSNumber *ID;
@property (retain, nonatomic) NSNumber *lastUpdateTime;
@property (retain, nonatomic) NSNumber *lastVideoId;
@property (retain, nonatomic) NSNumber *month;
@property (retain, nonatomic) NSNumber *status;
@property (retain, nonatomic) NSNumber *stows;
@property (retain, nonatomic) NSNumber *type;
@property (retain, nonatomic) NSNumber *views;
@property (retain, nonatomic) NSNumber *week;
@property (retain, nonatomic) NSNumber *year;



@property (retain, nonatomic) NSString *cover;
@property (retain, nonatomic) NSString *intro;
@property (retain, nonatomic) NSString *lastVideoName;
@property (retain, nonatomic) NSString *searchInfo;
@property (retain, nonatomic) NSString *title;


@property (retain, nonatomic) NSArray *tagNames;
@end
