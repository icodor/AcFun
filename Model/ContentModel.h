//
//  ContentModel.h
//  AcFun
//
//  Created by caiiiac on 15-1-4.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property (retain, nonatomic) NSDictionary *mChannel;
@property (retain, nonatomic) NSNumber *mChannelId;
@property (retain, nonatomic) NSNumber *mComments;
@property (retain, nonatomic) NSNumber *mContentId;
@property (retain, nonatomic) NSString *mCover;
@property (retain, nonatomic) NSString *mDescription;
@property (retain, nonatomic) NSNumber *mIsRecommend;
@property (retain, nonatomic) NSNumber *mReleaseDate;
@property (retain, nonatomic) NSNumber *mStows;
@property (retain, nonatomic) NSArray *mTags;
@property (retain, nonatomic) NSString *mTitle;
@property (retain, nonatomic) NSNumber *mToplevel;
@property (retain, nonatomic) NSDictionary *mUser;
@property (retain, nonatomic) NSArray *mVideos;
@property (retain, nonatomic) NSNumber *mViewOnly;
@property (retain, nonatomic) NSNumber *mViews;

//文章专用
@property (retain, nonatomic) NSNumber *mIsArticle;

@end
