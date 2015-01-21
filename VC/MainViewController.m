//
//  RecommendViewController.m
//  AcFun
//
//  Created by caiiiac on 14-12-30.
//  Copyright (c) 2014年 caiiiac. All rights reserved.
//

#import "MainViewController.h"
#import "ChannelView.h"
#import "RecommendView.h"
#import "AcFun_API.h"
#import "AFNetworking.h"
#import "MoreView.h"

#define TITLEHEIGHT 30

@interface MainViewController ()
//滚动视图
@property (retain, nonatomic) UIScrollView *bottomSV;
//精选视图
@property (retain, nonatomic) RecommendView *recommendView;
//频道视图
@property (retain, nonatomic) ChannelView *channelView;
//更多视图
@property (retain, nonatomic) MoreView *moreView;


//顶部标题视图
@property (retain, nonatomic) UIScrollView *topTitleSV;
//内容视图
@property (retain, nonatomic) UIScrollView *contentSV;
//当前视图
@property (assign, nonatomic) int currentIndex;
//顶部标题数组
@property (retain, nonatomic) NSArray *arrayTitle;



@end

@implementation MainViewController

static NSString * const reuseIdentifier = @"recommend";

+ (MainViewController *)sharedInstance
{
    static MainViewController *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    return __singletion;
}
- (void)loadViews
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }

    CGRect frame = self.view.bounds;
    frame.origin.y = TITLEHEIGHT;
    frame.size.height -= (64 + TITLEHEIGHT);
    

    //顶部标题
    self.arrayTitle = [NSArray arrayWithObjects:@"精选",@"频道",@"更多", nil];
    self.topTitleSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TITLEHEIGHT)];
    
    
    for (int i = 0; i < self.arrayTitle.count ; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40+i*((frame.size.width-80)/self.arrayTitle.count), 0, ((frame.size.width-80)/self.arrayTitle.count), TITLEHEIGHT)];
        label.tag = 100 + i;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.arrayTitle[i];
        label.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCurrentIndex:)];
        tap.numberOfTapsRequired = 1;
        [label addGestureRecognizer:tap];
        
        [self.topTitleSV addSubview:label];
    }
    //当前标题底部标识
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.tag = 99;
    imgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]];
    [self.topTitleSV addSubview:imgView];
    
    [self.view addSubview:self.topTitleSV];
    
    //滚动视图
    self.bottomSV = [[UIScrollView alloc] initWithFrame:frame];
    self.bottomSV.delegate = self;
    [self.bottomSV setContentSize:CGSizeMake(frame.size.width*self.arrayTitle.count, frame.size.height)];
    self.bottomSV.bounces = NO;
    self.bottomSV.pagingEnabled = YES;
    self.bottomSV.showsHorizontalScrollIndicator = NO;
    self.bottomSV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.bottomSV];
    
    //精选视图
    self.recommendView = [[RecommendView alloc] initWithFrame:self.bottomSV.bounds];
    [self.bottomSV addSubview:self.recommendView];
    
    //频道视图
    CGRect channelFrame = frame;
    channelFrame.origin.x = frame.size.width;
    channelFrame.origin.y = 0;
    self.channelView = [[ChannelView alloc] initWithFrame:channelFrame];
    self.channelView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.channelView loadData];
    [self.bottomSV addSubview:self.channelView];
    
    
    //更多视图
    CGRect moreFrame = frame;
    moreFrame.origin.x = 2 * frame.size.width;
    moreFrame.origin.y = 0;
    self.moreView = [[[NSBundle mainBundle] loadNibNamed:@"MoreView" owner:self options:nil] lastObject];
    self.moreView.frame = moreFrame;
    self.moreView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.bottomSV addSubview:self.moreView];
    
    //当前选择的标题
    self.currentIndex = 0;
}
#pragma mark - 标题点击事件
- (void) changeCurrentIndex:(UITapGestureRecognizer *) tap
{
    self.currentIndex = (int)tap.view.tag - 100;
}
- (void)setCurrentIndex:(int)currentIndex
{
    _currentIndex = currentIndex;
    
    for (int i = 0; i < _arrayTitle.count; i++) {
        UILabel *label = (UILabel *)[_topTitleSV viewWithTag:100+i];
        label.textColor = [UIColor blackColor];
    }
    
    UILabel *currentLabel = (UILabel *)[_topTitleSV viewWithTag:100+_currentIndex];
    currentLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]];
    CGRect frame = currentLabel.frame;
    
    UIImageView *imgView = (UIImageView *)[_topTitleSV viewWithTag:99];
    imgView.frame = CGRectMake(frame.origin.x, frame.size.height-3, frame.size.width, 3);
    
    [self.bottomSV setContentOffset:CGPointMake(self.view.bounds.size.width*_currentIndex, 0) animated:YES];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x/self.view.bounds.size.width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 77, 20)];
    img.image = [UIImage imageNamed:@"icon_actionbar"];
    
    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc] initWithCustomView:img];
    self.navigationItem.leftBarButtonItem = leftBarbtn;

    [self loadViews];
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

@end
