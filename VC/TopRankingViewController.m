//
//  TopRankingViewController.m
//  AcFun
//
//  Created by caiiiac on 15-1-5.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "TopRankingViewController.h"
#import "AcFun_API.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "DOPDropDownMenu.h"
#import "ContentModel.h"
#import "TopRankingVideoTableViewCell.h"
#import "TopRankingArticleTableViewCell.h"
#import "TopRankingHisplayTableViewCell.h"
#import "BangumiModel.h"
#import "ContentsViewController.h"
#import "MJRefresh.h"

@interface TopRankingViewController ()
<DOPDropDownMenuDataSource,
DOPDropDownMenuDelegate,
UITableViewDataSource,
UITableViewDelegate>
//下拉菜单信息
@property (retain, nonatomic) NSDictionary *dicRoot;
@property (retain, nonatomic) NSMutableArray *arrayMenuLeft;
@property (retain, nonatomic) NSMutableArray *arrayMenuRight;
//当前下拉菜单索引
@property (assign, nonatomic) int currentIndex;
//当前类别
@property (assign, nonatomic) int currentCategory;

//下拉菜单视图
@property (retain, nonatomic) DOPDropDownMenu *downMenu;
//数据视图
@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *arrayData;

//数据当前页数
@property (assign, nonatomic) int currentPage;
//数据链接头部
@property (retain, nonatomic) NSMutableArray *arrayURLHead;
//请求的数据类别
@property (retain, nonatomic) NSMutableArray *arrayURLChannelIds;
@end

@implementation TopRankingViewController

-(void)loadViews
{
    _currentPage = 1;
    _currentIndex = 0;
    _currentCategory = 0;
    
    self.arrayData = [[NSMutableArray alloc] init];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
     self.dicRoot = [[[NSDictionary alloc] initWithContentsOfFile:strPath] objectForKey:@"TopRanking"];
    self.arrayMenuLeft = [self.dicRoot objectForKey:@"left"];
    self.arrayMenuRight = [self.dicRoot objectForKey:@"right"][self.currentIndex];
    self.arrayURLHead = [self.dicRoot objectForKey:@"url"];
    self.arrayURLChannelIds = [self.dicRoot objectForKey:@"channelIds"];

    self.downMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:30];
    self.downMenu.delegate = self;
    self.downMenu.dataSource = self;
    self.downMenu.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];

    [self.view addSubview:self.downMenu];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, self.downMenu.frame.size.height, self.view.bounds.size.width-10, self.view.bounds.size.height-64-self.downMenu.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.bounces = YES;
    self.tableView.alwaysBounceHorizontal = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}
- (void) loadData
{
    NSString *strURLHead = [NSString stringWithFormat:self.arrayURLHead[self.currentIndex],self.currentPage];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",strURLHead,self.arrayURLChannelIds[self.currentIndex][self.currentCategory]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *confi = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:confi];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"热门排行数据下载失败");
        }
        else
        {
    
            for (NSDictionary *dicRoot in [[[responseObject objectForKey:@"data"] objectForKey:@"page"] objectForKey:@"list"]) {
                
                //视频与文章数据
                if (self.currentIndex != 2) {
                    ContentModel *model = [[ContentModel alloc] init];
                    
                    //model.mChannelId = [dicRoot objectForKey:@"channelId"];
                    model.mComments = [dicRoot objectForKey:@"comments"];
                    model.mContentId = [dicRoot objectForKey:@"contentId"];
                    model.mCover = [dicRoot objectForKey:@"cover"];
                    model.mDescription = [dicRoot objectForKey:@"description"];
                    //model.mIsRecommend = [dicRoot objectForKey:@"isRecommend"];
                    model.mReleaseDate = [dicRoot objectForKey:@"releaseDate"];
                    model.mStows = [dicRoot objectForKey:@"stows"];
                    //model.mTags = [dicRoot objectForKey:@"tags"];
                    model.mTitle = [dicRoot objectForKey:@"title"];
                    //model.mToplevel = [dicRoot objectForKey:@"toplevel"];
                    model.mUser = [dicRoot objectForKey:@"user"];
                    model.mViews = [dicRoot objectForKey:@"views"];
                    
                    
//                    //视频数据
//                    if (self.currentIndex == 0) {
//                        model.mChannel = [dicRoot objectForKey:@"channel"];
//                    }
//                    //文章数据
//                    {
//                        model.mIsArticle = [dicRoot objectForKey:@"isArticle"];
//                    }

                    [self.arrayData addObject:model];
                }
                //番剧
                else
                {
                    BangumiModel *model = [[BangumiModel alloc] init];
                    model.avgScore = [dicRoot objectForKey:@"avgScore"];
                    model.cover = [dicRoot objectForKey:@"cover"];
                    model.ID = [dicRoot objectForKey:@"id"];
                    model.lastVideoName = [dicRoot objectForKey:@"lastVideoName"];
                    model.title = [dicRoot objectForKey:@"title"];
                    [self.arrayData addObject:model];
                }
                
                
                [self.tableView reloadData];
            }
                
            

        }
    }];
    [dataTask resume];
}
- (void) loadMoreData
{
    self.currentPage += 1;
    [self loadData];
}
#pragma mark - tableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *strID;
    //视频
    if (self.currentIndex == 0) {
        strID = [NSMutableString stringWithString:@"TopRankingVideo"];
        TopRankingVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopRankingVideoTableViewCell" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        }
        
        if (_arrayData[indexPath.row] != nil) {
            
            ContentModel *model = _arrayData[indexPath.section];
            
            cell.title.text = model.mTitle;
            cell.username.text = [model.mUser objectForKey:@"username"];
            cell.comments.text = [model.mComments stringValue];
            cell.stows.text = [model.mViews stringValue];
            [cell.coverImg setImageWithURL:[NSURL URLWithString:model.mCover] placeholderImage:[UIImage imageNamed:@"image_loading_2x1"]];
        }
        
        return cell;
    }
    //文章
    else if (self.currentIndex == 1)
    {
        strID = [NSMutableString stringWithString:@"TopRankingArticle"];
        TopRankingArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopRankingArticleTableViewCell" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if (_arrayData[indexPath.row] != nil) {
            
            ContentModel *model = _arrayData[indexPath.section];
            
            cell.title.text = model.mTitle;
            cell.comments.text = [model.mComments stringValue];
            cell.stows.text = [model.mViews stringValue];
            cell.descriptions.text = model.mDescription;
        }
        

        return cell;
    }
    //番剧
    else if (self.currentIndex == 2)
    {
        strID = [NSMutableString stringWithString:@"TopRankingHisplay"];
        TopRankingHisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopRankingHisplayTableViewCell" owner:self options:nil] lastObject];
        }
        if (_arrayData[indexPath.row] != nil) {
            
            BangumiModel *model = _arrayData[indexPath.section];
            
            cell.title.text = model.title;
            cell.avgScore.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_rank_%@",model.avgScore]];
            cell.lastVideoName.text = [NSString stringWithFormat:@"更新至%@",model.lastVideoName];
            [cell.cover setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"image_loading_3x4"]];
            
        }
        return cell;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击视频cell
    if (self.currentIndex == 0) {
        
        ContentsViewController *contentsVC = [[ContentsViewController alloc] init];
        
        contentsVC.contentID = [[self.arrayData[indexPath.section] mContentId] stringValue];
    
        [self.navigationController pushViewController:contentsVC animated:YES];
    }
    //文章
    else if (self.currentIndex == 1)
    {
        
    }
    //番剧
    else if (self.currentIndex == 2)
    {
        
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //视频cell高度
    if (self.currentIndex == 0) {
        return 81;
    }
    //文章cell高度
    else if(self.currentIndex == 1 || self.currentIndex == 2)
    {
        return 64;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.currentIndex == 0) {
        return 1;
    }
    
    return 4;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.currentIndex == 0) {
        return 1;
    }
    
    return 4;
}
#pragma mark - 下拉菜单
- (NSInteger) numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}
-(NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 1) {
        return self.arrayMenuRight.count;
    }
    return self.arrayMenuLeft.count;
}
- (NSString *) menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
            return self.arrayMenuLeft[indexPath.row];
            break;
        case 1:
            return self.arrayMenuRight[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //选择了左侧的菜单
    if (indexPath.column == 0) {
        self.currentIndex = (int)indexPath.row;
    }
    //选择了右侧子菜单
    else if (indexPath.column == 1)
    {
        //文章没有分类 不进行操作
        if (self.currentIndex != 1) {
            self.currentCategory = (int)indexPath.row;
        }
    }
    
}
-(void)setCurrentIndex:(int)currentIndex
{
    _currentIndex = currentIndex;
    self.arrayMenuRight = [self.dicRoot objectForKey:@"right"][self.currentIndex];
    //[self.downMenu setNeedsDisplay];
    
    //每次改变数据类型.都对其分类索引进行置0
    self.currentCategory = 0;
    self.currentPage = 1;
    
}
- (void)setCurrentCategory:(int)currentCategory
{
    _currentCategory = currentCategory;
    
    [self refreshData];
}
- (void) refreshData
{
    [self.arrayData removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"❮热门排行" style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self loadViews];
    [self loadData];
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

@end
