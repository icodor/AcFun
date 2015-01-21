//
//  ContentListCollectionViewCell.m
//  AcFun
//
//  Created by caiiiac on 15-1-10.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "ContentListCollectionViewCell.h"

@implementation ContentListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.title.text = nil;
    self.stows.text = nil;
    self.views.text = nil;
}

@end
