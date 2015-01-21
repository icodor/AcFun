//
//  TopRankingArticleTableViewCell.h
//  AcFun
//
//  Created by caiiiac on 15-1-5.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopRankingArticleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *comments;
@property (strong, nonatomic) IBOutlet UILabel *stows;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *descriptions;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *commentsBackgroundImg;

@end
