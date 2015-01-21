//
//  TopRankingArticleTableViewCell.m
//  AcFun
//
//  Created by caiiiac on 15-1-5.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "TopRankingArticleTableViewCell.h"

@implementation TopRankingArticleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.title.text = nil;
    self.descriptions.text = nil;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.commentsBackgroundImg.frame.size.width, self.commentsBackgroundImg.frame.size.height)];
    img.image = [UIImage imageNamed:@"bg_blue_color"];
    [self.commentsBackgroundImg insertSubview:img atIndex:0];
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)];
    backImg.image = [UIImage imageNamed:@"bg_clear_color"];
    backImg.layer.borderWidth = 0.3;
    backImg.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    [self.backgroundView insertSubview:backImg atIndex:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
