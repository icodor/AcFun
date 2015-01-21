//
//  TopRankingHisplayTableViewCell.h
//  AcFun
//
//  Created by caiiiac on 15-1-5.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopRankingHisplayTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *lastVideoName;

@property (strong, nonatomic) IBOutlet UIImageView *avgScore;
@end
