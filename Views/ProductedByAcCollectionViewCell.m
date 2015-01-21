//
//  ProductedByAcCollectionViewCell.m
//  AcFun
//
//  Created by caiiiac on 15-1-3.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "ProductedByAcCollectionViewCell.h"
#import "ProductedByAcTableViewCell.h"
#import "AFNetworking.h"
#import "RecommendModel.h"
#import "AcFun_API.h"
#import "ContentsViewController.h"
#import "MainViewController.h"


@interface ProductedByAcCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *arrayData;

@property (retain, nonatomic) NSDictionary *dicWeekday;
@end

@implementation ProductedByAcCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.arrayData = [[NSMutableArray alloc] init];
    self.tableView.layer.borderWidth = 0.3;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.dicWeekday = @{@"Monday":@"星期一",
                        @"Tuesday":@"星期二",
                        @"Wednesday":@"星期三",
                        @"Thursday":@"星期四",
                        @"Friday":@"星期五",
                        @"Saturday":@"星期六",
                        @"Sunday":@"星期天"};
    [self loadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"refreshData" object:nil];
}
#pragma mark - 数据加载
- (void) loadData
{
    [self.arrayData removeAllObjects];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];
    
    
    //推荐列表数据下载
    
    NSURLRequest *request_productedByAc = [NSURLRequest requestWithURL:[NSURL URLWithString:RECOMMEND_PRODUCTEDBYAC]];
    NSURLSessionDataTask *productedByAcTask = [manager dataTaskWithRequest:request_productedByAc completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"推荐列表数据下载失败");
        }
        else
        {
            if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                
                for (NSDictionary *dicRoot in [[responseObject objectForKey:@"data"] objectForKey:@"productedByAc"]) {
                    
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
                    model.mTime = [dicRoot objectForKey:@"time"];
                    model.mWeekDay = [dicRoot objectForKey:@"weekday"];
                    
                    [self.arrayData addObject:model];
                    
                    [self.tableView reloadData];
                    
                    //通知上层视图 数据下载成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoading" object:[NSNumber numberWithInteger:self.arrayData.count]];
                }
            }
        }
    }];
    [productedByAcTask resume];
    
    
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strID = @"Producted";
    ProductedByAcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
    
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductedByAcTableViewCell" owner:self options:nil] lastObject];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.arrayData[indexPath.row] != nil) {
            
            RecommendModel *model = self.arrayData[indexPath.row];
            
            cell.title.text = model.mTitle;
            cell.subtitle.text = model.mSubtitle;
            cell.time.text = model.mTime;
            cell.weekday.text = [self.dicWeekday objectForKey:model.mWeekDay];
        }
        if (indexPath.row < 2) {
            cell.tagImg.hidden = NO;
            cell.time.textColor = [UIColor whiteColor];
            cell.weekday.textColor = [UIColor whiteColor];
        }
        
    }
    
    return cell;
}
#pragma mark - 推荐列表cell点击响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendModel *model = self.arrayData[indexPath.row];
    ContentsViewController *contentVC = [[ContentsViewController alloc] init];
    contentVC.contentID = [NSMutableString stringWithString:model.mSpecialId];
    [[MainViewController sharedInstance].navigationController pushViewController:contentVC animated:YES];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
