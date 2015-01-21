//
//  BangumiHeadCollectionReusableView.m
//  AcFun
//
//  Created by caiiiac on 15-1-12.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "BangumiHeadCollectionReusableView.h"

@implementation BangumiHeadCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    
    self.week.text = nil;
    self.week.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]];
}

@end
