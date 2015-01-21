//
//  TopRankingVideoTableViewCell.h
//  AcFun
//
//  Created by caiiiac on 15-1-5.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopRankingVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *coverImg;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *comments;
@property (strong, nonatomic) IBOutlet UILabel *stows;

@end
