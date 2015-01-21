//
//  ContentListCollectionViewCell.h
//  AcFun
//
//  Created by caiiiac on 15-1-10.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentListCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (strong, nonatomic) IBOutlet UILabel *views;
@property (strong, nonatomic) IBOutlet UILabel *stows;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *recommend;

@end
