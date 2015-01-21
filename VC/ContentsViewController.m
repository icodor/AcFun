//
//  ContentsViewController.m
//  AcFun
//
//  Created by caiiiac on 15-1-6.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "ContentsViewController.h"
#import "AcFun_API.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ContentModel.h"
#import "PPLabel.h"
#import "UserInfoViewController.h"
#import "UserModel.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>


@protocol VideoPartDelegate <NSObject>

- (void)videoPartUpInside:(UIControl *) control;

@end
@interface VideoPart ()

@property (retain, nonatomic) UIImageView *icon;

@property (retain, nonatomic) UILabel *name;

@property (copy, nonatomic) NSString *partName;

@property (assign, nonatomic) id<VideoPartDelegate> delegate;
@end
@implementation VideoPart

-(void)drawRect:(CGRect)rect
{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 18, 18)];
    self.icon.image = [UIImage imageNamed:@"week_play_1"];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 150, 21)];
    self.name.font = [UIFont systemFontOfSize:10];
    self.name.text = self.partName;
    
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, rect.size.height-1, rect.size.width, 1)];
    lineImg.image = [UIImage imageNamed:@"channel_line"];
    
    [self addSubview:self.icon];
    [self addSubview:self.name];
    [self addSubview:lineImg];
    
    [self addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(unhighlighted:) forControlEvents:UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(videoPartUpInside:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 高亮显示  取消高亮
- (void) highlighted:(VideoPart *) control
{
    control.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}
- (void) unhighlighted:(VideoPart *) control
{
    control.backgroundColor = [UIColor whiteColor];
}
- (void) videoPartUpInside:(VideoPart *) control
{
    control.backgroundColor = [UIColor whiteColor];
    [control.delegate videoPartUpInside:control];
}
@end


@interface ContentsViewController ()
<PPLabelDelegate,
VideoPartDelegate>

//底部滚动视图
@property (retain, nonatomic) UIScrollView *bottomSV;
//视频相关视图
@property (retain, nonatomic) UIView *videoView;
//图标
@property (retain, nonatomic) UIImageView *videoImg;
//标题
@property (retain, nonatomic) UILabel *videotitle;
//观看数
@property (retain, nonatomic) UILabel *videoViews;
//收藏数
@property (retain, nonatomic) UILabel *videoStows;
//简介
@property (retain, nonatomic) UILabel *videoDescription;
//标签
@property (retain, nonatomic) PPLabel *videoTags;

//up主视图
@property (retain, nonatomic) UIControl *userView;
//up头像
@property (retain, nonatomic) UIImageView *userImg;
//up妮称
@property (retain, nonatomic) UILabel *username;
//当前经验值
@property (retain, nonatomic) UIImageView *currExp;
//用户等级
@property (retain, nonatomic) UILabel *userLevel;

//视频列表视图
@property (retain, nonatomic) UIView *videoContent;
//视频源数值
@property (retain, nonatomic) UILabel *videoContentCount;


//视频内容数据
@property (retain, nonatomic) ContentModel *videoModel;
//用户内容
@property (retain, nonatomic) UserModel *userModel;


//播放视频控件
@property (retain, nonatomic) MPMoviePlayerViewController *moviePlay;
@end

@implementation ContentsViewController

- (void)loadViews
{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat bottomHight = 10.0;
    self.bottomSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-104)];
    
    
    //第一格 视频详情
    
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 0)];
    CGRect videoViewFrame = self.videoView.frame;
    self.videoView.backgroundColor = [UIColor whiteColor];
    self.videoView.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    self.videoView.layer.borderWidth = 0.3;
    //缩略图
    //112:300 宽度与屏幕比例
    //63:112  自身高宽比例
    CGFloat videoWidth = (112.0/300)*self.videoView.frame.size.width;
    CGFloat videoHeight = (63.0/112)*videoWidth;
    self.videoImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2,videoWidth, videoHeight)];
    self.videoImg.contentMode = UIViewContentModeScaleAspectFit;
    //self.videoImg.image = [UIImage imageNamed:@"image_loading_2x1"];
    videoViewFrame.size.height += videoHeight + 10;
    //标题
    self.videotitle = [[UILabel alloc] initWithFrame:CGRectMake(_videoImg.frame.size.width + 10, 5, self.videoView.frame.size.width - _videoImg.frame.size.width-20, 35)];
    self.videotitle.numberOfLines = 2;
    self.videotitle.font = [UIFont systemFontOfSize:14];
    
    //收藏 观看数
    UIImageView *videoviewsImg = [[UIImageView alloc] initWithFrame:CGRectMake(_videoImg.frame.size.width + 10, _videoImg.frame.size.height-10, 15, 10)];
    videoviewsImg.image = [UIImage imageNamed:@"video_view_icon"];
    self.videoViews = [[UILabel alloc] initWithFrame:CGRectMake(videoviewsImg.frame.size.width+videoviewsImg.frame.origin.x + 5, videoviewsImg.frame.origin.y, 50, 10)];
    self.videoViews.font = [UIFont systemFontOfSize:11];
    self.videoViews.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    
    UIImageView *videoStowsImg = [[UIImageView alloc] initWithFrame:CGRectMake(videoviewsImg.frame.origin.x+80, videoviewsImg.frame.origin.y, videoviewsImg.frame.size.height, videoviewsImg.frame.size.height)];
    videoStowsImg.image = [UIImage imageNamed:@"video_collect_icon"];
    
    self.videoStows = [[UILabel alloc] initWithFrame:CGRectMake(videoStowsImg.frame.origin.x + videoStowsImg.frame.size.width + 5, videoStowsImg.frame.origin.y, 50, videoStowsImg.frame.size.height)];
    self.videoStows.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.videoStows.font = [UIFont systemFontOfSize:11];
    
    
    //简介
    self.videoDescription = [[UILabel alloc] initWithFrame:CGRectMake( 8, _videoImg.frame.size.height + 8, self.videoView.frame.size.width - 16, 15)];
    self.videoDescription.font = [UIFont systemFontOfSize:11];
    self.videoDescription.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.videoDescription.numberOfLines = 0;
    
    
    //内容赋值
    [self.videoImg setImageWithURL:[NSURL URLWithString:self.videoModel.mCover] placeholderImage:[UIImage imageNamed:@"image_loading_2x1"]];
    self.videotitle.text = self.videoModel.mTitle;
    self.videoViews.text = [self.videoModel.mViews stringValue];
    self.videoStows.text = [self.videoModel.mStows stringValue];
    self.videoDescription.text = self.videoModel.mDescription;
    
    [self.videoDescription sizeToFit];
    videoViewFrame.size.height += self.videoDescription.frame.size.height;
    
    UIImageView *linesImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, videoViewFrame.size.height+4, self.videoView.frame.size.width, 1)];
    linesImg.image = [UIImage imageNamed:@"channel_line"];
    
    //视频标签
    self.videoTags = [[PPLabel alloc] initWithFrame:CGRectMake(8, videoViewFrame.size.height+8, self.videoView.frame.size.width-20, 16)];
    self.videoTags.delegate = self;
    self.videoTags.numberOfLines = 0;
    self.videoTags.textColor = [UIColor colorWithRed:92.0/255 green:172.0/255 blue:238.0/255 alpha:1.0f];
    self.videoTags.font = [UIFont systemFontOfSize:11];
    NSMutableString *strTags = [[NSMutableString alloc] init];
    for (NSString *tags in self.videoModel.mTags) {
        [strTags appendFormat:@"%@  ",tags];
    }
    self.videoTags.text = strTags;
    [self.videoTags sizeToFit];
    videoViewFrame.size.height += self.videoTags.frame.size.height + 10;
    
    
    self.videoView.frame = videoViewFrame;
    
    [self.videoView addSubview:self.videoImg];
    [self.videoView addSubview:self.videotitle];
    [self.videoView addSubview:videoviewsImg];
    [self.videoView addSubview:self.videoViews];
    [self.videoView addSubview:videoStowsImg];
    [self.videoView addSubview:self.videoStows];
    [self.videoView addSubview:self.videoDescription];
    [self.videoView addSubview:linesImg];
    [self.videoView addSubview:self.videoTags];
    
    bottomHight += self.videoView.frame.size.height;
    
    //第二格----用户信息
    self.userView = [[UIControl alloc] initWithFrame:CGRectMake(10, bottomHight+10, self.videoView.frame.size.width, 44)];
    self.userView.layer.borderWidth = 0.3;
    self.userView.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    self.userView.backgroundColor = [UIColor whiteColor];
    [self.userView addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
    [self.userView addTarget:self action:@selector(unhighlighted:) forControlEvents:UIControlEventTouchDragInside];
    [self.userView addTarget:self action:@selector(showUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 36, 36)];
    [self.userImg.layer setCornerRadius:self.userImg.bounds.size.width/2];
    self.userImg.layer.masksToBounds = YES;
    

    [self.userImg setImageWithURL:[NSURL URLWithString:[self.videoModel.mUser objectForKey:@"userImg"]] placeholderImage:[UIImage imageNamed:@"image_loading_1x1"]];

    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userImg.frame.origin.x + self.userImg.frame.size.width + 10, 8, 30, 15)];
    upLabel.text = @"UP主:";
    upLabel.font = [UIFont boldSystemFontOfSize:10];
    
    self.username = [[UILabel alloc] initWithFrame:CGRectMake(upLabel.frame.size.width + upLabel.frame.origin.x + 5, upLabel.frame.origin.y, 150, 15)];
    self.username.text = [self.videoModel.mUser objectForKey:@"username"];
    self.username.font = [UIFont systemFontOfSize:10];
    self.username.textColor = [UIColor colorWithRed:92.0/255 green:172.0/255 blue:238.0/255 alpha:1.0f];
    
    UIImageView *exp = [[UIImageView alloc] initWithFrame:CGRectMake(self.userImg.frame.origin.x + self.userImg.frame.size.width + 10, self.username.frame.origin.y + self.username.frame.size.height + 8, 100, 3)];
    exp.backgroundColor = [UIColor grayColor];
    
    CGRect currExpFram = exp.frame;
    currExpFram.size.width =(([self.userModel.exp floatValue]-[self.userModel.currExp floatValue])/([self.userModel.nextLevelNeed floatValue]-[self.userModel.currExp floatValue]))*100;
    
    self.currExp = [[UIImageView alloc] initWithFrame:currExpFram];
    self.currExp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]];
    
    self.userLevel = [[UILabel alloc] initWithFrame:CGRectMake(exp.frame.origin.x+exp.frame.size.width+8, self.username.frame.size.height + 10, 80, 15)];
    self.userLevel.text = [NSString stringWithFormat:@"Lv%@",self.userModel.level];
    self.userLevel.font = [UIFont systemFontOfSize:10];
    self.userLevel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.userView.frame.size.width-20, 12, 14, 20)];
    arrow.image = [UIImage imageNamed:@"icon_arrow_right"];
    
    [self.userView addSubview:self.userImg];
    [self.userView addSubview:upLabel];
    [self.userView addSubview:self.username];
    [self.userView addSubview:exp];
    [self.userView addSubview:self.currExp];
    [self.userView addSubview:self.userLevel];
    [self.userView addSubview:arrow];
    bottomHight += self.userView.frame.size.height+10;
    
    //第三格视频列表
    self.videoContent = [[UIView alloc] initWithFrame:CGRectMake(10, bottomHight + 10, self.userView.frame.size.width, 0)];
    CGRect contentFrame = self.videoContent.frame;
    self.videoContent.backgroundColor = [UIColor whiteColor];
    self.videoContent.layer.borderWidth = 0.3;
    self.videoContent.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    
    self.videoContentCount = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, 80, 15)];
    self.videoContentCount.text = [NSString stringWithFormat:@"共有%d段视频",(int)[self.videoModel.mVideos count]];
    self.videoContentCount.font = [UIFont systemFontOfSize:11];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.videoContentCount.frame.size.height+10, self.videoContent.frame.size.width-10, 1)];
    lineImg.image = [UIImage imageNamed:@"channel_line"];
    
    contentFrame.size.height += self.videoContentCount.frame.size.height+11;
    
    for (NSDictionary *dic in self.videoModel.mVideos) {
        
        VideoPart *part = [[VideoPart alloc] initWithFrame:CGRectMake(0, contentFrame.size.height, contentFrame.size.width, 32)];
        part.backgroundColor = [UIColor whiteColor];
        part.partName = [dic objectForKey:@"name"];
        part.tag = 100 + [self.videoModel.mVideos indexOfObject:dic];
        part.delegate = self;
        [self.videoContent addSubview:part];
        contentFrame.size.height += part.frame.size.height;
    }
    
    self.videoContent.frame = contentFrame;
    [self.videoContent addSubview:self.videoContentCount];
    [self.videoContent addSubview:lineImg];
    
    
    bottomHight += self.videoContent.frame.size.height + 10;
    
    //视图内容超出屏幕范围
    if (bottomHight > self.bottomSV.frame.size.height) {
        
        self.bottomSV.contentSize = CGSizeMake(self.bottomSV.frame.size.width, bottomHight);

    }
    
    self.bottomSV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    [self.bottomSV addSubview:self.videoView];
    [self.bottomSV addSubview:self.userView];
    [self.bottomSV addSubview:self.videoContent];
    [self.view addSubview:self.bottomSV];
    
}


- (void) loadData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CONTENT_ID,self.contentID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *confi = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:confi];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"视频详情下载失败");
        }
        else
        {
            NSDictionary *dicRoot = [[responseObject objectForKey:@"data"] objectForKey:@"fullContent"];
            
            self.videoModel = [[ContentModel alloc] init];
            
            self.videoModel.mChannelId = [dicRoot objectForKey:@"channelId"];
            self.videoModel.mComments = [dicRoot objectForKey:@"comments"];
            self.videoModel.mContentId = [dicRoot objectForKey:@"contentId"];
            self.videoModel.mCover = [dicRoot objectForKey:@"cover"];
            self.videoModel.mDescription = [dicRoot objectForKey:@"description"];
            self.videoModel.mIsRecommend = [dicRoot objectForKey:@"isRecommend"];
            self.videoModel.mReleaseDate = [dicRoot objectForKey:@"releaseDate"];
            self.videoModel.mStows = [dicRoot objectForKey:@"stows"];
            self.videoModel.mTags = [dicRoot objectForKey:@"tags"];
            self.videoModel.mTitle = [dicRoot objectForKey:@"title"];
            self.videoModel.mUser = [dicRoot objectForKey:@"user"];
            self.videoModel.mViews = [dicRoot objectForKey:@"views"];
            self.videoModel.mVideos = [dicRoot objectForKey:@"videos"];
            
            
            [self loadUserData];
            

        }
    }];
    [dataTask resume];
}
//下载up主数据
- (void) loadUserData
{
    NSNumber *userID = [self.videoModel.mUser objectForKey:@"userId"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:USER_ID,userID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userModel = [[UserModel alloc] init];
        NSDictionary *dicRoot = [[responseObject objectForKey:@"data"] objectForKey:@"fullUser"];
        self.userModel.currExp = [dicRoot objectForKey:@"currExp"];
        self.userModel.exp = [dicRoot objectForKey:@"exp"];
        self.userModel.gender = [dicRoot objectForKey:@"gender"];
        self.userModel.level = [dicRoot objectForKey:@"level"];
        self.userModel.nextLevelNeed = [dicRoot objectForKey:@"nextLeveNeed"];
        self.userModel.signature = [dicRoot objectForKey:@"signature"];
        self.userModel.userId = [dicRoot objectForKey:@"userId"];
        self.userModel.userImg = [dicRoot objectForKey:@"userImg"];
        self.userModel.username = [dicRoot objectForKey:@"username"];
        
        [self loadViews];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用户信息下载失败");
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
}
#pragma mark - 视频列表点击事件
- (void)videoPartUpInside:(UIControl *)control
{
    
    NSString *moviePath = [NSString stringWithFormat:VIDEO_ID,[self.videoModel.mVideos[control.tag-100] objectForKey:@"videoId"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:moviePath]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicRoot = [responseObject objectForKey:@"result"];
        NSString *videoPath = [[[dicRoot objectForKey:@"C00"] objectForKey:@"files"][0] objectForKey:@"url"];
        self.moviePlay = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoPath]];
        self.moviePlay.view.frame = self.view.bounds;
        
        [self.moviePlay.moviePlayer prepareToPlay];
        self.moviePlay.moviePlayer.shouldAutoplay = YES;
        self.moviePlay.moviePlayer.fullscreen = YES;
        
        
//        [self.view addSubview:self.moviePlay.view];
        [self presentViewController:self.moviePlay animated:YES completion:nil];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"视频地址解析失败");
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}
#pragma mark - 视频标签点击事件
-(void)label:(PPLabel *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex
{
    if (charIndex == NSNotFound) {
        return ;
    }
    
    NSRange end = [label.text rangeOfString:@" " options:0 range:NSMakeRange(charIndex, label.text.length - charIndex)];
    NSRange front = [label.text rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, charIndex)];
    
    if (front.location == NSNotFound) {
        front.location = 0; //first word was selected
    }
    
    if (end.location == NSNotFound) {
        end.location = label.text.length-1; //last word was selected
    }
    
    NSRange wordRange = NSMakeRange(front.location, end.location-front.location);
    
    if (front.location!=0) { //fix trimming
        wordRange.location += 1;
        wordRange.length -= 1;
    }

    NSLog(@"%@",[label.text substringWithRange:wordRange]);
}
-(void)label:(PPLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex
{
    
}
-(void)label:(PPLabel *)label didCancelTouch:(UITouch *)touch
{
}
-(void)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"❮ac%@",self.contentID] style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_blue_color"]];
    
    [self loadData];
}
#pragma mark - 返回上级视图
- (void) popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - user响应
- (void) showUserInfo:(UIControl *) control
{
    UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
    userInfo.userModel = self.userModel;
    [self.navigationController pushViewController:userInfo animated:YES];
    control.backgroundColor = [UIColor whiteColor];
}
- (void) highlighted:(UIControl *) control
{
    control.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}
- (void) unhighlighted:(UIControl *) control
{
    control.backgroundColor = [UIColor whiteColor];
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
