## WBCycleScrollView
- 无限轮播视图，可设置cell左右间距，参考SDCycleScrollView实现原理。可实现轮播背景渐变过渡效果。

## How to use WBCycleScrollView

### 特性
- 无限轮播
- 可设置左右间距
- 滚动进度、下标回调
- 支持cell缩放比例设置

### Installation

- CocoaPods

  `pod 'WBCycleScrollView'`

- 手动导入

  直接拖WBCycleScrollView到工程，导入'WBCycleScrollView.h'

### Usage

- 初始化

```
// 网络加载 --- 创建带标题的图片轮播器
    WBCycleScrollView *cycleScrollView2 = [WBCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, w, 200)
                                                                             delegate:self
                                                                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    ///cell size
    cycleScrollView2.itemSize = CGSizeMake(w - 20, 180);
    ///左右间距
    cycleScrollView2.itemSpacing = 10;
    cycleScrollView2.imageViewCornerRadius = 6;
    ///轮播时间间隔
    cycleScrollView2.autoScrollTimeInterval = 5;
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    ///是否缩放
    cycleScrollView2.isZoom = YES;
    [self.view addSubview:cycleScrollView2];
```

- 代理方法

  ```
  ///滚动进度回调，可在此设置背景颜色渐变效果(具体实现可查看demo)
  - (void)cycScrollViewScrollRealOffset:(NSInteger)realOffsetX scrollRate:(CGFloat)scrollRate currentPage:(NSInteger)currentPage cycleScrollView:(WBCycleScrollView *)cycleScrollView {}
  ```

  

## Remind

- ARC
- iOS>=8.0
- iPhone
- Xcode 8+

## 更新日志：
2025-04.22：Swift Package

2019-12-08：新增滑动关闭交互属性，添加缩放比例设置属性，代码风格优化

## Author

author：wenmobo	

email：[wenmobo2018@gmail.com](mailto:wenmobo2018@gmail.com)


掘金：https://juejin.im/user/5a371ae551882512d0607108		

简书：https://www.jianshu.com/u/63445e24e8bf		

