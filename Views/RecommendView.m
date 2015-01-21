//
//  Recommendview.m
//  AcFun
//
//  Created by caiiiac on 14-12-31.
//  Copyright (c) 2014年 caiiiac. All rights reserved.
//

#import "RecommendView.h"
#import "RecommendCollectionViewCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AcFun_API.h"
#import "Recommend_ListCollectionReusableView.h"
#import "RecommendModel.h"
#import "ProductedByAcCollectionViewCell.h"
#import "MainViewController.h"
#import "ContentsViewController.h"


@interface RecommendView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
//视频列表
@property (retain, nonatomic) UICollectionView * recommendCV;
//视频列表数据
@property (retain, nonatomic) NSMutableArray *arrayData;
//推荐列表数据
@property (retain, nonatomic) NSMutableArray *arrayProductedByAc;
//轮播图片数据
@property (retain, nonatomic) NSMutableArray *arrayList;
//视频数据当前页数
@property (assign, nonatomic) int currentPage;

//推荐列表是否下载成功
@property (assign, nonatomic) BOOL Finish;
//推荐数据数量
@property (assign, nonatomic) int counts;
@end

@implementation RecommendView

static NSString * const reuseIdentifier = @"recommend";


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //self.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.bounds;
    
    self.currentPage = 1;
    self.Finish = NO;
    self.arrayData = [[NSMutableArray alloc] init];
    self.arrayList = [[NSMutableArray alloc] init];
    self.arrayProductedByAc = [[NSMutableArray alloc] init];
    
    /*
     精选视图控件
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.recommendCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    self.recommendCV.delegate = self;
    self.recommendCV.dataSource = self;
    //self.recommendCV.bounces = NO;
    
    self.recommendCV.backgroundColor = [UIColor whiteColor];
    [self.recommendCV registerNib:[UINib nibWithNibName:@"RecommendCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    [self.recommendCV registerNib:[UINib nibWithNibName:@"ProductedByAcCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductedByAc"];
    [self.recommendCV registerNib:[UINib nibWithNibName:@"Recommend_ListCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"img_list"];
    
    [self addSubview:self.recommendCV];
    
    [self.recommendCV addHeaderWithTarget:self action:@selector(refreshData)];
    [self.recommendCV headerBeginRefreshing];
    
    [self.recommendCV addFooterWithTarget:self action:@selector(loadMoreData)];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(isLoading:) name:@"isLoading" object:nil];
    
}
#pragma mark - 数据加载
- (void) loadListData
{
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];
    
    //轮播图片数据
    NSURLRequest *request_list = [NSURLRequest requestWithURL:[NSURL URLWithString:RECOMMEND_LIST]];
    NSURLSessionDataTask *listTask = [manager dataTaskWithRequest:request_list completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"轮播图片下载失败");
            [self.recommendCV headerEndRefreshing];
            [self.recommendCV footerEndRefreshing];
        }
        else
        {
            if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                
                for (NSDictionary *dicRoot in [[responseObject objectForKey:@"data"] objectForKey:@"list"]) {
                    
                    RecommendModel *model = [[RecommendModel alloc] init];
                    model.mConfig = [dicRoot objectForKey:@"config"];
                    model.mCover = [dicRoot objectForKey:@"cover"];
                    model.mDescription = [dicRoot objectForKey:@"description"];
                    model.mReleaseDate = [dicRoot objectForKey:@"releaseDate"];
                    model.mSlideId = [dicRoot objectForKey:@"slideId"];
                    model.mSpecialId = [dicRoot objectForKey:@"specialId"];
                    model.mSubtitle = [dicRoot objectForKey:@"subtitle"];
                    model.mTitle = [dicRoot objectForKey:@"title"];
                    model.mType = [dicRoot objectForKey:@"type"];
                    
                    
                    [self.arrayList addObject:model];
                    
                    [self.recommendCV reloadData];
                    [self.recommendCV headerEndRefreshing];
                    [self.recommendCV footerEndRefreshing];
                }
            }
        }
    }];
    
    [listTask resume];
    
}
- (void) loadPageData
{
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];

    //cell数据
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:RECOMMEND_PAGE,self.currentPage]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"数据下载出错");
            [self.recommendCV headerEndRefreshing];
            [self.recommendCV footerEndRefreshing];
        }
        else
        {
            if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                
                for (NSDictionary *dicRoot in [[[responseObject objectForKey:@"data"] objectForKey:@"page"] objectForKey:@"list"]) {
                    
                    RecommendModel *model = [[RecommendModel alloc] init];
                    model.mConfig = [dicRoot objectForKey:@"config"];
                    model.mCover = [dicRoot objectForKey:@"cover"];
                    model.mDescription = [dicRoot objectForKey:@"description"];
                    model.mReleaseDate = [dicRoot objectForKey:@"releaseDate"];
                    model.mSlideId = [dicRoot objectForKey:@"slideId"];
                    model.mSpecialId = [dicRoot objectForKey:@"specialId"];
                    model.mSubtitle = [dicRoot objectForKey:@"subtitle"];
                    model.mTitle = [dicRoot objectForKey:@"title"];
                    model.mType = [dicRoot objectForKey:@"type"];
                    
                    
                    [self.arrayData addObject:model];
                    
                    [self.recommendCV reloadData];
                    [self.recommendCV headerEndRefreshing];
                    [self.recommendCV footerEndRefreshing];
                }
            }
        }
    }];
    [dataTask resume];
    
}
//重新加载数据
- (void) refreshData
{
    self.currentPage = 1;
    [self.arrayData removeAllObjects];
    [self.arrayList removeAllObjects];
    [self.recommendCV reloadData];
    [self loadListData];
    [self loadPageData];
    
    //通知推荐列表重新加载数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
}
//加载更多数据
- (void) loadMoreData
{
    self.currentPage += 1;
    [self loadPageData];
}
#pragma mark - 通知中心事件
- (void) isLoading:(NSNotification *) noti
{
    NSNumber *msg = (NSNumber *)noti.object;
   
    if (![msg isEqualToNumber:@0]) {
        self.Finish = YES;
        self.counts = [msg intValue];
        [self.recommendCV reloadData];
    }
}
#pragma mark - collectionView
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayData.count+1;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strID = @"recommend";
    
    //第一格显示推荐列表
    if (indexPath.row == 0) {
        
        ProductedByAcCollectionViewCell *proCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductedByAc" forIndexPath:indexPath];
        //proCell.highlighted = NO;
        return proCell;
    }
    else
    {
        RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:strID forIndexPath:indexPath];
        
        if (self.arrayData[indexPath.row-1] != nil) {
            RecommendModel *model = _arrayData[indexPath.row-1];
            cell.titleLabel.text = model.mTitle;
            cell.subtitleLabel.text = model.mSubtitle;
            [cell.coverImgView setImageWithURL:[NSURL URLWithString:model.mCover] placeholderImage:[UIImage imageNamed:@"image_loading_1x1"]];
        }
        
        return cell;
    }
    
    return nil;
}
#pragma mark  collectionView点击推出内容详情视图
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendModel *model = _arrayData[indexPath.row-1];
    ContentsViewController *contentVC = [[ContentsViewController alloc] init];
    contentVC.contentID = [NSMutableString stringWithString:model.mSpecialId];
    [[MainViewController sharedInstance].navigationController pushViewController:contentVC animated:YES];
    
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_Finish == NO) {
            return CGSizeMake(self.recommendCV.bounds.size.width-20, 0.1);
        }

        return CGSizeMake(self.recommendCV.bounds.size.width-20, 40*self.counts);
    }
    CGFloat sizeWidth = ((self.recommendCV.bounds.size.width-20)/2)-5;
    CGFloat sizeHigth = 110.0/145 * sizeWidth;
    return CGSizeMake(sizeWidth, sizeHigth);
}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
//页头
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    Recommend_ListCollectionReusableView *list ;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        list = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"img_list" forIndexPath:indexPath];
        
        if (_arrayList.count != 0) {
            list.arrayData = _arrayList;
        }
        
    }
    
    return list;
}
//页头大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_arrayList.count == 0) {
        return CGSizeMake(self.frame.size.width, 0.1);
    }
    return CGSizeMake(self.frame.size.width, (self.frame.size.width-20)/2);
}

//点击cell时 高亮与取消高亮
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCollectionViewCell *cell = (RecommendCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor lightGrayColor]];
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCollectionViewCell *cell = (RecommendCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
