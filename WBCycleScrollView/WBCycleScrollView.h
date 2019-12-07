//
//  WBCycleScrollView.h
//  Pods-WBCycleScrollView_Example
//
//  Created by 文波 on 2019/10/19.
//

#import <UIKit/UIKit.h>
@class WBCycleScrollView;

NS_ASSUME_NONNULL_BEGIN

@protocol WBCycleScrollViewDelegate <NSObject>

@optional
/**  */
/**
 点击图片回调

 @param cycleScrollView cycleScrollView description
 @param index 下标
 */
- (void)cycleScrollView:(WBCycleScrollView *)cycleScrollView
   didSelectItemAtIndex:(NSInteger)index;

/**
 图片滚动回调

 @param cycleScrollView cycleScrollView description
 @param index 下标
 */
- (void)cycleScrollView:(WBCycleScrollView *)cycleScrollView
       didScrollToIndex:(NSInteger)index;

/**
 自定义轮播cell

 @param view view description
 @return return value description
 */
- (Class)customCollectionViewCellClassForCycleScrollView:(WBCycleScrollView *)view;

/**
 自定义轮播cell Nib

 @param view view description
 @return return value description
 */
- (UINib *)customCollectionViewCellNibForCycleScrollView:(WBCycleScrollView *)view;

/**
 自定义cell配置数据源

 @param cell 自定义轮播cell
 @param index 下标
 @param view view description
 */
- (void)setupCustomCell:(UICollectionViewCell *)cell
               forIndex:(NSInteger)index
        cycleScrollView:(WBCycleScrollView *)view;

/// 滚动进度回调
/// @param realOffsetX 真实滚动x轴偏移量
/// @param scrollRate 滚动比例（0-1）
/// @param currentPage 当前页数
/// @param cycleScrollView 轮播视图
- (void)cycScrollViewScrollRealOffset:(NSInteger)realOffsetX
                           scrollRate:(CGFloat)scrollRate
                          currentPage:(NSInteger)currentPage
                      cycleScrollView:(WBCycleScrollView *)cycleScrollView;

@end


@interface WBCycleScrollView : UIView

// MARK: - 便利初始化
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
                                delegate:(id<WBCycleScrollViewDelegate>)delegate
                        placeholderImage:(UIImage *)placeholderImage;

// MARK: - 数据源设置API
/// 网络图片 url string 数组
@property (nonatomic, strong) NSArray <NSString *>*imageURLStringsGroup;
/// 本地图片数组
@property (nonatomic, strong) NSArray <NSString *>*localizationImageNamesGroup;

// MARK: - 滚动控制API
/// 自动滚动间隔时间,默认2s
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/// 是否无限循环,默认Yes
@property (nonatomic, assign) BOOL infiniteLoop;

/// 是否自动滚动,默认Yes
@property (nonatomic, assign) BOOL autoScroll;

/// 图片滚动方向，默认为水平滚动
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<WBCycleScrollViewDelegate> delegate;

/// 可以调用此方法手动控制滚动到哪一个index
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

/// 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法
- (void)adjustWhenControllerViewWillAppera;

// MARK: - 自定义样式API
/// 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;
/// 占位图，用于网络未加载到图片时
@property (nonatomic, strong) UIImage *placeholderImage;
/// 图片圆角大小 默认：0
@property (nonatomic, assign) CGFloat imageViewCornerRadius;
/// 是否缩放 默认：NO
@property (nonatomic, assign) BOOL isZoom;
/// 中间那张卡片基于初始大小的缩放倍数，默认为 1.0 isZoom为YES设置有效
@property(nonatomic, assign) CGFloat maximumScale;
/// 除了中间之外的其他卡片基于初始大小的缩放倍数，默认为 0.9 isZoom为YES设置有效
@property(nonatomic, assign) CGFloat minimumScale;
/// cell大小 默认：父视图大小
@property (nonatomic, assign) CGSize itemSize;
/// cell大小间距 默认：0
@property (nonatomic, assign) CGFloat itemSpacing;
/// 是否分页 默认：NO 非infiniteLoop设置有效
@property (nonatomic, assign) BOOL pagingEnabed;
/// 滚动时是否开启交互 default：NO
@property (nonatomic, assign) BOOL scrollUserInteractionEnabled;

/// 滚动手势禁用
- (void)disableScrollGesture;

/// 销毁定时器
- (void)invalidateTimer;

/// 开始定时器
- (void)setupTimer;

/// 清除图片缓存（此次升级后统一使用SDWebImage管理图片加载和缓存）
+ (void)clearImagesCache;

/// 清除图片缓存（兼容旧版本方法）
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
