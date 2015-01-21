//
//  RecommendCollectionViewCell.h
//  AcFun
//
//  Created by caiiiac on 14-12-30.
//  Copyright (c) 2014年 caiiiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *coverImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
