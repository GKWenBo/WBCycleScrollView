## WBCycleScrollView
- 无限轮播视图，可设置cell左右间距，参考SDCycleScrollView实现原理.

## How to use WBCycleScrollView

### Installation

- CocoaPods

  `pod 'WBCycleScrollView'`

- 手动导入

  直接拖WBCycleScrollView到工程，导入'WBCycleScrollView.h'

### Usage

```objective-c
 WBCycleScrollView *cycleScrollView2 = [WBCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, w, 180)
                                                                             delegate:self
                                                                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView2.backgroundColor = [UIColor orangeColor];
		//设置cell大小
    cycleScrollView2.itemSize = CGSizeMake(w - 20, 180);
		//设置cell左右间距10
    cycleScrollView2.itemSpacing = 10;
		//设置图片圆角
    cycleScrollView2.imageViewCornerRadius = 6;
		//设置滚动方向
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		//是否需要缩放
    cycleScrollView2.isZoom = NO;
    
    [self.view addSubview:cycleScrollView2];
```

## Remind

- ARC
- iOS>=8.0
- iPhone
- Xcode 8+

## Author

author：wenbo
email：[wenmobo2018@gmail.com](mailto:wenmobo2018@gmail.com)
掘金：https://juejin.im/user/5a371ae551882512d0607108
简书：https://www.jianshu.com/u/63445e24e8bf

