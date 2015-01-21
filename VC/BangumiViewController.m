//
//  BangumiViewController.m
//  AcFun
//
//  Created by caiiiac on 15-1-11.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "BangumiViewController.h"
#import "AcFun_API.h"
#import "BangumiContentCollectionViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "BangumiModel.h"
#import "BangumiHeadCollectionReusableView.h"


@interface BangumiViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
//标题
@property (retain, nonatomic) NSArray *arraybackBarTitle;
//TYPES
@property (retain, nonatomic) NSArray *arrayTypes;
//星期
@property (retain, nonatomic) NSArray *arrayWeek;

@property (retain, nonatomic) UICollectionView *collectionView;

@property (retain, nonatomic) NSMutableArray *arrayData;
@end

@implementation BangumiViewController

-(void)loadViews
{
    self.arrayTypes = [NSArray arrayWithObjects:@"1",@"2,3,4", nil];
    self.arrayWeek = [NSArray arrayWithObjects:
                      @"星期一",
                      @"星期二",
                      @"星期三",
                      @"星期四",
                      @"星期五",
                      @"星期六",
                      @"星期日",nil];
    self.arrayData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.arrayData addObject:array];
    }
   
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BangumiContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BangumiContent"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BangumiHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BangumiHead"];
    
}
- (void) loadData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:BANGUMI_TYPES,_arrayTypes[_bangumiTypes]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"番剧数据下载失败");
        }
        else
        {
            NSArray *arrayRoot = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            [arrayRoot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                BangumiModel *model = [[BangumiModel alloc] init];
                
                NSRange range =[[obj objectForKey:@"title"] rangeOfString:@"】"];
                if (range.location != NSNotFound) {
                    model.title = [[obj objectForKey:@"title"] substringWithRange:NSMakeRange(range.location+1, [[obj objectForKey:@"title"] length]-range.location-1)];
                }
                else
                {
                    model.title = [obj objectForKey:@"title"] ;
                }
                
                model.cover = [obj objectForKey:@"cover"];
                model.lastVideoName = [NSString stringWithFormat:@"更新至%@",[obj objectForKey:@"lastVideoName"]];
                model.ID = [obj objectForKey:@"id"];
                model.week = [obj objectForKey:@"week"];
                
                [_arrayData[[model.week intValue]-1] addObject:model];
                
               // [_arrayData[model.week] addObject:model];
                [self.collectionView reloadData];
            }];
            
        }
    }];
    
    [dataTask resume];
    
}
#pragma mark - UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrayData.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_arrayData[section] count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BangumiContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BangumiContent" forIndexPath:indexPath];
    
    if (self.arrayData[indexPath.section][indexPath.row]) {
        
        BangumiModel *model = _arrayData[indexPath.section][indexPath.row];
        
        cell.title.text = model.title;
        cell.lastVideoName.text = model.lastVideoName;
        [cell.cover setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"image_loading_3x4"]];
        
    }
    
    return cell;
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BangumiHeadCollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BangumiHead" forIndexPath:indexPath];
    
    head.week.text = self.arrayWeek[indexPath.section];
    return head;
}
//页头大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.arrayWeek[section] != nil) {
        return CGSizeMake(self.collectionView.frame.size.width-20, 45);
    }
    
    return CGSizeMake(self.collectionView.frame.size.width-20, 0.1);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat sizeWidth = (self.collectionView.bounds.size.width-20)/3-6;
    CGFloat sizeHeight = 146.0/96*sizeWidth;
    
    return CGSizeMake(sizeWidth, sizeHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 9, 5, 9);
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    self.arraybackBarTitle = [NSArray arrayWithObjects:@"本季新番",@"本季剧集", nil];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"❮%@",_arraybackBarTitle[_bangumiTypes]] style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
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
