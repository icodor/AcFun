//
//  ChannelView.m
//  AcFun
//
//  Created by caiiiac on 14-12-31.
//  Copyright (c) 2014年 caiiiac. All rights reserved.
//

#import "ChannelView.h"
#import "AcFun_API.h"
#import "AFNetworking.h"
#import "MainViewController.h"
#import "TopRankingViewController.h"
#import "ChannelCategoryViewController.h"
#import "BangumiViewController.h"

@interface ChannelView ()

//热门排行
@property (retain, nonatomic) UIControl *topRankingView;
//类别
@property (retain, nonatomic) UIView *categoryList;
//本季剧集
@property (retain, nonatomic) UIView *currentView;

//类别 更新统计
@property (retain, nonatomic) NSMutableDictionary *dicData;

//分类名称
@property (retain, nonatomic) NSArray *arrayCategoryName;

@end
@implementation ChannelView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //热门排行
    self.topRankingView = [[UIControl alloc] initWithFrame:CGRectMake(10, 20, rect.size.width-20, 40)];
    //点击事件.高亮.取消高亮
    [self.topRankingView addTarget:self action:@selector(showTopRanking:) forControlEvents:UIControlEventTouchUpInside];
    [self.topRankingView addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
    [self.topRankingView addTarget:self action:@selector(unhighlighted:) forControlEvents:UIControlEventTouchDragInside];
    //边缘颜色.宽度.边角弧度
    self.topRankingView.layer.cornerRadius = 4;
    self.topRankingView.backgroundColor = [UIColor whiteColor];
    self.topRankingView.layer.borderColor = [UIColor grayColor].CGColor;
    self.topRankingView.layer.borderWidth = 0.5;
    [self addSubview:self.topRankingView];
    
    //热门排行子视图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    imgView.image = [UIImage imageNamed:@"icon_rank"];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 80, 20)];
    title.text = @"热门排行";
    title.font = [UIFont systemFontOfSize:15];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.topRankingView.frame.size.width-20, 10, 14, 20)];
    arrow.image = [UIImage imageNamed:@"icon_arrow_right"];
    
    [self.topRankingView addSubview:imgView];
    [self.topRankingView addSubview:title];
    [self.topRankingView addSubview:arrow];
    
    
    //类别
    self.categoryList = [[UIView alloc] initWithFrame:CGRectMake(10, self.topRankingView.bounds.size.height+40, self.topRankingView.bounds.size.width, 180)];
    self.categoryList.backgroundColor = [UIColor whiteColor];
    //边缘颜色.宽度.边角弧度
    self.categoryList.layer.borderColor = [UIColor grayColor].CGColor;
    self.categoryList.layer.borderWidth = 0.5;
    self.categoryList.layer.cornerRadius = 4;
    
    [self addSubview:self.categoryList];
    
    //类别子视图
    self.arrayCategoryName = [NSArray arrayWithObjects:@"游戏",
                                  @"音乐",
                                  @"文章",
                                  @"科技",
                                  @"影视",
                                  @"动画",
                                  @"娱乐",
                                  @"体育", nil];
    NSArray *arrayCategoryIcon = [NSArray arrayWithObjects:@"icon_channel_game",
                                  @"icon_channel_music",
                                  @"icon_channel_article",
                                  @"icon_channel_tech",
                                  @"icon_channel_movie",
                                  @"icon_channel_animation",
                                  @"icon_channel_fun",
                                  @"icon_channel_sports", nil];
    
    NSArray *key = [NSArray arrayWithObjects:@"59",
                    @"58",
                    @"63",
                    @"70",
                    @"68",
                    @"1",
                    @"60",
                    @"69", nil];
    
    for (int i = 0 ; i < _arrayCategoryName.count; i++) {
        UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(75*(i%4), 90*(i/4), 75, 90)];
        view.layer.cornerRadius = 4;
        //点击事件
        [view addTarget:self action:@selector(showCategoryList:) forControlEvents:UIControlEventTouchUpInside];
        //按下事件 高亮显示
        [view addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
        //手势离开控件 取消高亮
        [view addTarget:self action:@selector(unhighlighted:) forControlEvents:UIControlEventTouchDragInside];
        view.tag = 1000 + i;
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 15, 40, 40)];
        img.image = [UIImage imageNamed:arrayCategoryIcon[i]];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, img.frame.size.height+20, 30, 20)];
        title.text = self.arrayCategoryName[i];
        title.font = [UIFont systemFontOfSize:12];
        title.textAlignment = NSTextAlignmentCenter;
        
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(48, img.frame.size.height+25, 22, 15)];
        number.textAlignment = NSTextAlignmentLeft;
        if ([_dicData objectForKey:key[i]] != nil) {
            number.text = [NSString stringWithFormat:@"+%@", [_dicData objectForKey:key[i]]];
        }
        else
        {
            number.text = @"+0";
        }
        
        number.textColor = [UIColor redColor];
        number.font = [UIFont systemFontOfSize:9];
        
        
        [view addSubview:number];
        [view addSubview:title];
        [view addSubview:img];
        
        [self.categoryList addSubview:view];
    }
 
    
    //本季剧集
    
    self.currentView = [[UIView alloc] initWithFrame:CGRectMake(10, self.categoryList.bounds.size.height+self.topRankingView.bounds.size.height+ 60, self.topRankingView.bounds.size.width, self.topRankingView.bounds.size.height)];
    self.currentView.layer.cornerRadius = 4.0;
    self.currentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.currentView.layer.borderWidth = 0.5;
    self.currentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.currentView];
    
    //本季子视图
    UIControl *leftControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.currentView.frame.size.width/2, self.currentView.frame.size.height)];
    leftControl.tag = 2000;
    leftControl.layer.cornerRadius = 4;
    //响应事件
    [leftControl addTarget:self action:@selector(showBangumi:) forControlEvents:UIControlEventTouchUpInside];
    [leftControl addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
    [leftControl addTarget:self action:@selector(unhighlighted:) forControlEvents:UIControlEventTouchDragInside];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 30, 30)];
    leftImg.image = [UIImage imageNamed:@"image_bangumi"];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImg.frame.size.width+leftImg.frame.origin.x+5, 10, 65, 20)];
    leftLabel.text = @"本季新番";
    leftLabel.font = [UIFont systemFontOfSize:15];

    [leftControl addSubview:leftImg];
    [leftControl addSubview:leftLabel];
    
    UIControl *rightControl = [[UIControl alloc] initWithFrame:CGRectMake(self.currentView.frame.size.width/2, 0, self.currentView.frame.size.width/2, self.currentView.frame.size.height)];
    rightControl.layer.cornerRadius = 4;
    rightControl.tag = 2001;
    //响应事件
    [rightControl addTarget:self action:@selector(showBangumi:) forControlEvents:UIControlEventTouchUpInside];
    [rightControl addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
    [rightControl addTarget:self action:@selector(unhighlighted:) forControlEvents:UIControlEventTouchDragInside];

    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 30, 30)];
    rightImg.image = [UIImage imageNamed:@"image_serial"];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightImg.frame.size.width+rightImg.frame.origin.x+5, 10, 65, 20)];
    rightLabel.text = @"本季剧集";
    rightLabel.font = [UIFont systemFontOfSize:15];
    
    [rightControl addSubview:rightImg];
    [rightControl addSubview:rightLabel];
    
    [self.currentView addSubview:leftControl];
    [self.currentView addSubview:rightControl];
}

- (void) loadData
{
    self.dicData = [[NSMutableDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:CHANNEL_COUNTS];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"数据统计下载出错");
        }
        else
        {
            _dicData = [NSMutableDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"list"]];
            [self setNeedsDisplay];
        }
    }];
    
    [dataTask resume];
}
#pragma mark - 热门排行事件响应
- (void) showTopRanking:(UIControl *) control
{
    TopRankingViewController *topRanking = [[TopRankingViewController alloc] init];
    [[MainViewController sharedInstance].navigationController pushViewController:topRanking animated:YES];
    
    control.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 分类事件响应
- (void) showCategoryList:(UIControl *) control
{
    ChannelCategoryViewController *categoryVC = [[ChannelCategoryViewController alloc] init];
    categoryVC.mTitle = self.arrayCategoryName[control.tag-1000];
    categoryVC.mChannelId = control.tag - 1000;
    
    [[MainViewController sharedInstance].navigationController pushViewController:categoryVC animated:YES];
    
    control.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 本季左右控件事件响应
- (void) showBangumi:(UIControl *) control
{

    BangumiViewController *bangumiVC = [[BangumiViewController alloc] init];
    bangumiVC.bangumiTypes = control.tag - 2000;
    [[MainViewController sharedInstance].navigationController pushViewController:bangumiVC animated:YES];
    control.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 高亮显示  取消高亮
- (void) highlighted:(UIControl *) control
{
    //control.highlighted = YES;
    control.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}
- (void) unhighlighted:(UIControl *) control
{
    //control.highlighted = NO;
    control.backgroundColor = [UIColor whiteColor];
}
@end
