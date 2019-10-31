//
//  WBViewController.m
//  WBCycleScrollView
//
//  Created by wenmobo on 10/19/2019.
//  Copyright (c) 2019 wenmobo. All rights reserved.
//

#import "WBViewController.h"
#import <WBCycleScrollView.h>
#import "UIColor+MyExtension.h"

@interface WBViewController () <WBCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *changeColors;

@property (nonatomic, strong) UIView *colorView;

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
    cycleScrollView2.autoScrollTimeInterval = 5;
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView2.isZoom = NO;
    
    [self.view addSubview:cycleScrollView2];
    
    _colorView = [UIView new];
    _colorView.frame = CGRectMake(0, 0, w, 200);
    _colorView.backgroundColor = self.changeColors[0];
    [self.view addSubview:_colorView];
}

- (void)cycleScrollView:(WBCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    NSLog(@"%ld", index);
}

- (void)cycScrollViewScrollOffset:(NSInteger)offsetX cycleScrollView:(WBCycleScrollView *)view {
    [self handelBannerBgColorWithOffset:offsetX];
}

//根据偏移量计算设置banner背景颜色
- (void)handelBannerBgColorWithOffset:(NSInteger )offset {
    if (1 == self.changeColors.count) return;
    NSInteger offsetCurrent = offset % (int)(self.view.bounds.size.width - 20);
    float rate = offsetCurrent / (int)(self.view.bounds.size.width - 20);
    NSLog(@"rate  = %f", rate);
    NSInteger currentPage = offset / (int)(self.view.bounds.size.width - 20);
    UIColor *startPageColor;
    UIColor *endPageColor;
    if (currentPage == self.changeColors.count - 1) {
        startPageColor = self.changeColors[currentPage];
        endPageColor = self.changeColors[0];
    } else {
        if (currentPage  == self.changeColors.count) {
            return;
        }
        startPageColor = self.changeColors[currentPage];
        endPageColor = self.changeColors[currentPage + 1];
    }
    UIColor *currentToLastColor = [UIColor getColorWithColor:startPageColor andCoe:rate andEndColor:endPageColor];
    self.colorView.backgroundColor = currentToLastColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)changeColors {
    if (!_changeColors) {
        UIColor *oneColor   = [UIColor colorWithHexString:@"#FDC0BC" alpha:1.0];
        UIColor *twoColor   = [UIColor colorWithHexString:@"#CBC1FF" alpha:1.0];
        UIColor *threeColor = [UIColor colorWithHexString:@"#C8CFA2" alpha:1.0];
//        UIColor *fourColor  = [UIColor colorWithHexString:@"#CBC1FF" alpha:1.0];
//        UIColor *fiveColor  = [UIColor colorWithHexString:@"#C8CFA2" alpha:1.0];
        _changeColors = [[NSMutableArray alloc]initWithArray:@[oneColor,twoColor,threeColor]];
    }
    return _changeColors;
}

@end
