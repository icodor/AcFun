//
//  MoreView.m
//  AcFun
//
//  Created by caiiiac on 15-1-12.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "MoreView.h"
#import "MainViewController.h"
#import "LoadingViewController.h"

@interface MoreView ()

@property (strong, nonatomic) IBOutlet UIImageView *bkImg;
@property (strong, nonatomic) IBOutlet UIButton *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *loadLabel;


@property (assign, nonatomic) BOOL isLoading;

@end

@implementation MoreView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.iconImg.layer.cornerRadius = self.iconImg.frame.size.width/2;
    self.iconImg.layer.borderWidth = 3;
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]].CGColor;
    [self.iconImg addTarget:self action:@selector(gotoLoading) forControlEvents:UIControlEventTouchUpInside];
    
    self.isLoading = NO;
    
    NSArray *arrayTitle = [NSArray arrayWithObjects:
                           @"资料",
                           @"设置",
                           @"反馈",
                           @"更新",
                           @"关于", nil];
    
    CGRect frame = CGRectMake(10, self.bkImg.frame.size.height+10, self.frame.size.width-20, 40);
    
    for (int i = 0 ; i < arrayTitle.count ; i++) {
       
        UIControl *control = [[UIControl alloc] initWithFrame:frame];
        control.tag = 1000 + i;
        control.layer.borderWidth = 0.3;
        control.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        
         frame.origin.y += 40;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        label.text = arrayTitle[i];
        label.font = [UIFont systemFontOfSize:14];
        [control addSubview:label];
        
        
        [control addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
        [control addTarget:self action:@selector(unhighlighted:) forControlEvents:UIControlEventTouchDragInside];
        [control addTarget:self action:@selector(showMoreSetp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
    }
    
}
- (void) gotoLoading
{
    if (self.isLoading == NO) {
        LoadingViewController *loadVC = [[LoadingViewController alloc] init];
        [[MainViewController sharedInstance].navigationController pushViewController:loadVC animated:YES];
    }
    
}
- (void) showMoreSetp:(UIControl *) control
{
    NSLog(@"%ld",control.tag);
    control.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 高亮显示  取消高亮
- (void) highlighted:(UIControl *) control
{
    control.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}
- (void) unhighlighted:(UIControl *) control
{
    control.backgroundColor = [UIColor whiteColor];
}

@end
