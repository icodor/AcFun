//
//  TopRankingHisplayTableViewCell.m
//  AcFun
//
//  Created by caiiiac on 15-1-5.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "TopRankingHisplayTableViewCell.h"

@implementation TopRankingHisplayTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.title.text = nil;
    self.lastVideoName.text = @"更新至";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
