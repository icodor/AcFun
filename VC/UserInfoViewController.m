//
//  UserInfoViewController.m
//  AcFun
//
//  Created by caiiiac on 15-1-8.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserInfoViewController ()

@property (strong, nonatomic) IBOutlet UIView *iconBackground;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
//头像
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;

@property (strong, nonatomic) IBOutlet UIView *userBottomView;
//妮称
@property (strong, nonatomic) IBOutlet UILabel *userName;
//性别
@property (strong, nonatomic) IBOutlet UILabel *userGender;
//签名
@property (strong, nonatomic) IBOutlet UILabel *userSignature;





//查看投稿
- (IBAction)showUserContribution:(UIButton *)sender;

@end

@implementation UserInfoViewController

-(void)loadViews
{
    [self.iconBackground.layer setCornerRadius:self.userIcon.bounds.size.width/2];
    self.iconBackground.layer.borderWidth = 2;
    self.iconBackground.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]].CGColor;
    self.iconBackground.layer.masksToBounds = YES;
    [self.userIcon setImageWithURL:[NSURL URLWithString:self.userModel.userImg] placeholderImage:[UIImage imageNamed:@"image_loading_1x1"]];
    
    self.userName.text = [NSString stringWithFormat:@"用户名:  %@",self.userModel.username];
    
    if ([self.userModel.gender isEqualToNumber:@1]) {
        
        self.userGender.text = @"性别:  男👦";
    }
    else if([self.userModel.gender isEqualToNumber:@0])
    {
        self.userGender.text = @"性别:  未知";
    }
    else
    {
        self.userGender.text = @"性别:  女👧";
    }

    if (self.userModel.signature != nil) {
        self.userSignature.text = [NSString stringWithFormat:@"签名:  %@",self.userModel.signature];
    }
    else
    {
        self.userSignature.text = @"签名:  这个人很懒.什么都没有写...";
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"❮用户" style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self loadViews];
}
- (void) popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mrak - 查看投稿
- (IBAction)showUserContribution:(UIButton *)sender {
}
@end
