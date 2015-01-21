//
//  ChannelCategoryViewController.m
//  AcFun
//
//  Created by caiiiac on 15-1-9.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "ChannelCategoryViewController.h"
#import "DOPDropDownMenu.h"
#import "ContentListCollectionViewCell.h"
#import "AcFun_API.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ContentModel.h"
#import "ContentsViewController.h"


@interface ChannelCategoryViewController ()
<DOPDropDownMenuDataSource,
DOPDropDownMenuDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>


//下拉菜单
@property (retain, nonatomic) NSDictionary *dicMenu;
//分类
@property (retain, nonatomic) NSArray *arrayMenuCategor;
//排序
@property (retain, nonatomic) NSArray *arrayMenuOrderBy;
//范围
@property (retain, nonatomic) NSArray *arrayMenuRange;

//请求数据链接
//分类id
@property (retain, nonatomic) NSMutableArray *arrayMenuchannelIds;
//排序
@property (retain, nonatomic) NSArray *arrayMenuOrderById;
//范围
@property (retain, nonatomic) NSArray *arrayMenuRangeId;

//索引
//当前选择分类
@property (assign, nonatomic) int currCategory;
//当前排序
@property (assign, nonatomic) int currOrderBy;
//当前范围
@property (assign, nonatomic) int currRange;

//当前显示页
@property (assign, nonatomic) int currPage;

//下拉菜单视图
@property (retain, nonatomic) DOPDropDownMenu *DownMenu;
//内容列表视图
@property (retain, nonatomic) UICollectionView *contentListCV;
//数据
@property (retain, nonatomic) NSMutableArray *arrayData;

//下载管理
@property (retain, nonatomic) AFURLSessionManager *manager;
@end

@implementation ChannelCategoryViewController

- (void)loadViews
{
    _currCategory = 0;
    _currOrderBy = 0;
    _currRange = 0;
    _currPage = 1;
    self.arrayData = [[NSMutableArray alloc]  init];
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    self.dicMenu = [[NSDictionary dictionaryWithContentsOfFile:strPath] objectForKey:@"category"];
    
    self.arrayMenuCategor = [self.dicMenu objectForKey:@"menu"];
    self.arrayMenuOrderBy = [self.dicMenu objectForKey:@"orderBy"];
    self.arrayMenuRange = [self.dicMenu objectForKey:@"range"];
    
    
    NSString *menuIds = [self.dicMenu objectForKey:@"channelIds"][_mChannelId];
    
    self.arrayMenuchannelIds = [NSMutableArray arrayWithArray:[menuIds componentsSeparatedByString:@","]];
    [self.arrayMenuchannelIds insertObject:menuIds atIndex:0];
    self.arrayMenuOrderById = [self.dicMenu objectForKey:@"orderById"];
    self.arrayMenuRangeId = [self.dicMenu objectForKey:@"rangeId"];
    
    
    self.DownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:30];
    self.DownMenu.delegate = self;
    self.DownMenu.dataSource = self;
    self.DownMenu.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.DownMenu];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.contentListCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.DownMenu.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.DownMenu.bounds.size.height-64) collectionViewLayout:layout];
    self.contentListCV.delegate = self;
    self.contentListCV.dataSource = self;
    self.contentListCV.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.contentListCV];
    
    [self.contentListCV registerNib:[UINib nibWithNibName:@"ContentListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"contentList"];
}
#pragma mark - loadData
- (void) loadData
{
    //请求第一页数据
    NSMutableString *strURL ;
    if (self.currPage == 1) {
        strURL = [NSMutableString stringWithFormat:CATEGORY_PAGE1,self.arrayMenuchannelIds[_currCategory],_currPage,self.arrayMenuOrderById[_currOrderBy],self.arrayMenuRangeId[_currRange]];
    }
    else
    {
        strURL = [NSMutableString stringWithFormat:CATEGORY_PAGE2,self.arrayMenuchannelIds[_currCategory],_currPage,self.arrayMenuOrderById[_currOrderBy],self.arrayMenuRangeId[_currRange]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"分类内容列表数据下载失败");
        }
        else
        {
            NSArray *arrayRoot = [NSArray arrayWithObjects:[[[responseObject objectForKey:@"data"]objectForKey:@"recommendPage"] objectForKey:@"list"],
                                  [[[responseObject objectForKey:@"data"]objectForKey:@"page"] objectForKey:@"list"], nil];
            
            [arrayRoot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                for (NSDictionary *dicRoot in obj) {
                    
                    ContentModel *model = [[ContentModel alloc] init];
                    
                    model.mComments = [dicRoot objectForKey:@"comments"];
                    model.mContentId = [dicRoot objectForKey:@"contentId"];
                    model.mCover = [dicRoot objectForKey:@"cover"];
                    model.mDescription = [dicRoot objectForKey:@"description"];
                    model.mIsRecommend = [dicRoot objectForKey:@"isRecommend"];
                    model.mReleaseDate = [dicRoot objectForKey:@"releaseDate"];
                    model.mStows = [dicRoot objectForKey:@"stows"];
                    model.mTags = [dicRoot objectForKey:@"tags"];
                    model.mTitle = [dicRoot objectForKey:@"title"];
                    model.mUser = [dicRoot objectForKey:@"user"];
                    model.mViews = [dicRoot objectForKey:@"views"];
                    model.mIsArticle = [dicRoot objectForKey:@"isArticle"];
                    
                    [self.arrayData addObject:model];
                    [self.contentListCV reloadData];
                }

            }];
            
        }
    }];
    [dataTask resume];
    
}
#pragma mark - collectionView
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.arrayData[indexPath.row] != nil) {
        
        ContentModel *model = _arrayData[indexPath.row];
        if (![model.mIsArticle isEqualToNumber:@1]) {
           ContentListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentList" forIndexPath:indexPath];
            
            cell.title.text = model.mTitle;
            cell.stows.text = [model.mStows stringValue];
            cell.views.text = [model.mViews stringValue];
            [cell.cover setImageWithURL:[NSURL URLWithString:model.mCover] placeholderImage:[UIImage imageNamed:@"image_loading_2x1"]];
            if ([model.mIsRecommend isEqualToNumber:@1]) {
                cell.recommend.hidden = NO;
            }
            else
            {
                cell.recommend.hidden = YES;
            }
            
            
            
            return cell;
        }
        else
        {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentList" forIndexPath:indexPath];
            
            return cell;
        }
        
    }
    
    return nil;
}
#pragma mark 点击进入详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContentModel *model = _arrayData[indexPath.row];
    ContentsViewController *contentsVC = [[ContentsViewController alloc] init];
    contentsVC.contentID = [model.mContentId stringValue];
    
    [self.navigationController pushViewController:contentsVC animated:YES];
    
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mChannelId != 3) {
        CGFloat sizeWidth = ((self.contentListCV.bounds.size.width-20)/2)-5;
        CGFloat sizeHigth = 100.0/145 * sizeWidth;
        return CGSizeMake(sizeWidth, sizeHigth);
    }
    else
    {
        return CGSizeMake(145, 100);
    }
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
#pragma mark - 下拉菜单
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        
        _currOrderBy = 0;
        _currRange = 0;
        _currPage = 1;
        self.currCategory = (int)indexPath.row;
    }
    else if (indexPath.column == 1)
    {
        self.currOrderBy = (int)indexPath.row;
        
    }
    else if (indexPath.column == 2)
    {
        self.currRange = (int)indexPath.row;
    }

}
-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
            return self.arrayMenuCategor[self.mChannelId][indexPath.row] ;
            break;
        case 1:
            return self.arrayMenuOrderBy[indexPath.row];
            break;
            
        case 2:
            return self.arrayMenuRange[indexPath.row];
            break;
        default:
            return nil;
            break;

    }
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    switch (column) {
        case 0:
            return [self.arrayMenuCategor[self.mChannelId] count];
            break;
        case 1:
            return self.arrayMenuOrderBy.count;
            break;
            
        case 2:
            return self.arrayMenuRange.count;
            break;
        default:
            return 0;
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"❮%@",self.mTitle] style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    [self loadViews];
    [self loadData];
    
}
#pragma mark - 重写set方法
-(void)setCurrPage:(int)currPage
{
    _currPage = currPage;
    [self loadData];
}
-(void)setCurrCategory:(int)currCategory
{
    _currCategory = currCategory;
    [_arrayData removeAllObjects];
    [self.contentListCV reloadData];
    [self loadData];
}
-(void)setCurrOrderBy:(int)currOrderBy
{
    _currOrderBy = currOrderBy;
    [_arrayData removeAllObjects];
    [self.contentListCV reloadData];
    [self loadData];
}
-(void)setCurrRange:(int)currRange
{
    _currRange = currRange;
    [_arrayData removeAllObjects];
    [self.contentListCV reloadData];
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
