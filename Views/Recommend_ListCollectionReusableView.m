//
//  Recommend_ListCollectionReusableView.m
//  AcFun
//
//  Created by caiiiac on 15-1-2.
//  Copyright (c) 2015年 caiiiac. All rights reserved.
//

#import "Recommend_ListCollectionReusableView.h"
#import "RecommendModel.h"
#import "UIImageView+AFNetworking.h"
#import "ContentsViewController.h"
#import "MainViewController.h"

@interface Recommend_ListCollectionReusableView ()
<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *imgList;
@property (strong, nonatomic) IBOutlet UILabel *subTitle;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIPageControl *currentPage;

@property (retain, nonatomic) NSTimer * timer;
//当前轮播图片索引
@property (assign, nonatomic) int currentIndex;

- (IBAction)ChangedCurrentPage:(UIPageControl *)sender;

@end
@implementation Recommend_ListCollectionReusableView


- (void)awakeFromNib {
    // Initialization code
    CGRect frame = self.frame;
    self.imgList.frame = CGRectMake(10, 0, frame.size.width-20, (frame.size.width-20)/2);
    self.imgList.contentSize = CGSizeMake((frame.size.width-20)*4, frame.size.height);
    
    for (int i = 0; i < 4; i++) {
        CGRect newFrame = self.imgList.frame;
        newFrame.origin.x = i * newFrame.size.width;
        //图片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:newFrame];
        imgView.image = [UIImage imageNamed:@"image_loading_2x1"];
        imgView.tag = 200 + i;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContent:)]];
        [self.imgList addSubview:imgView];
        
    }
    [self timerON];
    
}

- (void)setArrayData:(NSMutableArray *)arrayData
{
    _arrayData = [NSMutableArray arrayWithArray:arrayData];
    

    self.currentIndex = 0;
    for (int i = 0; i < _arrayData.count; i++) {
        RecommendModel *model = _arrayData[i];
        CGRect newFrame = self.imgList.frame;
        newFrame.origin.x = i * newFrame.size.width;
        //图片
        UIImageView *imgView = (UIImageView *)[self.imgList viewWithTag:200+i];
        [imgView setImageWithURL:[NSURL URLWithString:model.mCover]];
        
    }
}
//重写CurrentIndex set方法
-(void)setCurrentIndex:(int)currentIndex
{
    _currentIndex = currentIndex;
    
    RecommendModel *model = self.arrayData[currentIndex];
    //标题
    self.title.text = model.mTitle;
    CGRect titleframe = self.title.frame;
    CGSize newSize = [self.title sizeThatFits:CGSizeMake(300, 300)];
    titleframe.size.width = newSize.width;
    self.title.frame = titleframe;

    CGRect subTitleFrame = self.subTitle.frame;
    subTitleFrame.origin.x = self.title.frame.origin.x + self.title.frame.size.width + 5;
    self.subTitle.frame = subTitleFrame;

    self.subTitle.text = model.mSubtitle;
    titleframe = self.subTitle.frame;
    newSize = [self.subTitle sizeThatFits:CGSizeMake(300, 300)];
    titleframe.size.width = newSize.width;
    self.subTitle.frame = titleframe;
    
    
}

#pragma mark - 自动轮播
-(void) timerON
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changedCurrentX) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void) timerOFF
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void) changedCurrentX
{
    static int add = 1;
    
    if (self.currentIndex == 0) {
        add = 1;
    }
    else if (self.currentIndex == 3)
    {
        add = -1;
    }
    self.currentIndex += add;
    self.currentPage.currentPage = self.currentIndex;
    [self.imgList setContentOffset:CGPointMake(_currentIndex * self.imgList.frame.size.width, 0) animated:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self timerOFF];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self timerON];
}
#pragma mrak - 滚动视图点击事件
- (void) showContent:(UITapGestureRecognizer *) tap
{
    RecommendModel *model = self.arrayData[tap.view.tag-200];
    

    ContentsViewController *contentVC = [[ContentsViewController alloc] init];
    contentVC.contentID = [NSMutableString stringWithString:model.mSpecialId];
    [[MainViewController sharedInstance].navigationController pushViewController:contentVC animated:YES];
    
}
//图片滚动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.currentPage.currentPage = self.currentIndex;
}

//page值发生改变
- (IBAction)ChangedCurrentPage:(UIPageControl *)sender {
    self.currentIndex = (int)sender.currentPage;
    [self.imgList setContentOffset:CGPointMake(sender.currentPage * self.imgList.frame.size.width, 0) animated:YES];
    
}

@end
