//
//  ProductedByAcTableViewCell.h
//  AcFun
//
//  Created by caiiiac on 15-1-3.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductedByAcTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *tagImg;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *subtitle;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *weekday;

@end
