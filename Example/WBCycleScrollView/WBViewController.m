//
//  WBViewController.m
//  WBCycleScrollView
//
//  Created by wenmobo on 10/19/2019.
//  Copyright (c) 2019 wenmobo. All rights reserved.
//

#import "WBViewController.h"
#import <WBCycleScrollView.h>

@interface WBViewController () <WBCycleScrollViewDelegate>

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
     CGFloat w = self.view.bounds.size.width;
    
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 网络加载 --- 创建带标题的图片轮播器
    WBCycleScrollView *cycleScrollView2 = [WBCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, w, 180)
                                                                             delegate:self
                                                                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView2.backgroundColor = [UIColor orangeColor];
    cycleScrollView2.itemSize = CGSizeMake(w - 20, 180);
    cycleScrollView2.itemSpacing = 10;
    cycleScrollView2.imageViewCornerRadius = 6;
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView2.isZoom = NO;
    
    [self.view addSubview:cycleScrollView2];
}

- (void)cycleScrollView:(WBCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    NSLog(@"%ld", index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
