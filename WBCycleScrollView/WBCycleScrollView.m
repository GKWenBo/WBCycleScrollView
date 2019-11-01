//
//  WBCycleScrollView.m
//  Pods-WBCycleScrollView_Example
//
//  Created by 文波 on 2019/10/19.
//

#import "WBCycleScrollView.h"
#import "WBCycleScrollViewFlowLayout.h"
#import "WBCycleScrollViewCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *kIdentifier = @"WBCycleScrollViewCell";

@interface WBCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView;
@property (nonatomic, weak) WBCycleScrollViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图
///记录上次offset
@property (nonatomic, assign) CGPoint lastOffset;
//记录拖动方向
@property (nonatomic, assign) NSInteger dragDirection;

@end

@implementation WBCycleScrollView

- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
                                delegate:(id<WBCycleScrollViewDelegate>)delegate
                        placeholderImage:(UIImage *)placeholderImage {
    WBCycleScrollView *cycScrollView = [[self alloc]initWithFrame:frame];
    cycScrollView.delegate = delegate;
    cycScrollView.placeholderImage = placeholderImage;
    return cycScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)initialization {
    _autoScrollTimeInterval = 2.0;
    _imageViewCornerRadius = 0;
    _isZoom = NO;
    _itemSize = self.bounds.size;
    _itemSpacing = 0;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _pagingEnabed = NO;
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = [UIColor lightGrayColor];
}

// 设置显示图片的collectionView
- (void)setupMainView {
    WBCycleScrollViewFlowLayout *flowLayout = [[WBCycleScrollViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = _pagingEnabed;;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[WBCycleScrollViewCell class] forCellWithReuseIdentifier:kIdentifier];
    
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _flowLayout.minimumLineSpacing = self.itemSpacing;
    _flowLayout.itemSize = _itemSize;
    if (CGSizeEqualToSize(CGSizeZero, _flowLayout.itemSize)) {
        _flowLayout.itemSize = self.bounds.size;
    }
    
    _mainView.frame = self.bounds;
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
    
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]
                          atScrollPosition:[self scrollPostion]
                                  animated:NO];
        
        
        _lastOffset = self.mainView.contentOffset;
//        self.mainView.userInteractionEnabled = YES;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

// MARK: setter
- (void)setDelegate:(id<WBCycleScrollViewDelegate>)delegate {
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(customCollectionViewCellClassForCycleScrollView:)] && [self.delegate customCollectionViewCellClassForCycleScrollView:self]) {
        [self.mainView registerClass:[self.delegate customCollectionViewCellClassForCycleScrollView:self]
          forCellWithReuseIdentifier:kIdentifier];
    }else if ([self.delegate respondsToSelector:@selector(customCollectionViewCellNibForCycleScrollView:)] && [self.delegate customCollectionViewCellNibForCycleScrollView:self]) {
        [self.mainView registerNib:[self.delegate customCollectionViewCellNibForCycleScrollView:self]
        forCellWithReuseIdentifier:kIdentifier];
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    if (!placeholderImage) return;
    _placeholderImage = placeholderImage;
    if (!self.backgroundImageView) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:imageView belowSubview:self.mainView];
        self.backgroundImageView = imageView;
    }
    self.backgroundImageView.image = placeholderImage;
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup {
    [self invalidateTimer];
    
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? imagePathsGroup.count * 100 : imagePathsGroup.count;
    
    //图片张数大于0，隐藏背景视图
    self.backgroundImageView.hidden = imagePathsGroup.count > 0 ? YES : NO;
    
    if (imagePathsGroup.count > 1) {
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }else {
        self.mainView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    
    [self.mainView reloadData];
}

- (void)setImageURLStringsGroup:(NSArray<NSString *> *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = @[].mutableCopy;
    [imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:obj];
    }];
    self.imagePathsGroup = temp.copy;
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

- (void)disableScrollGesture {
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    
    self.flowLayout.minimumLineSpacing = itemSpacing;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    self.flowLayout.itemSize = itemSize;
}

- (void)setIsZoom:(BOOL)isZoom {
    _isZoom = isZoom;
    
    self.flowLayout.isZoom = isZoom;
}

- (void)setPagingEnabed:(BOOL)pageEnabed {
    _pagingEnabed = pageEnabed;
    if (!self.infiniteLoop) {
        self.mainView.pagingEnabled = pageEnabed;
    }
}

// MARK: Private Method
- (UICollectionViewScrollPosition)scrollPostion {
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return UICollectionViewScrollPositionCenteredHorizontally;
    }
    return UICollectionViewScrollPositionCenteredVertically;
}

- (void)invalidateTimer {
    if (!self.autoScroll) return;
    
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer {
    //// 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    [self invalidateTimer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval
                                                      target:self
                                                    selector:@selector(automaticScroll)
                                                    userInfo:nil
                                                     repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer
                              forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll {
    if (_totalItemsCount == 0) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (int)currentIndex {
    if (_mainView.frame.size.width == 0 || _mainView.frame.size.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.mainView.contentOffset.x + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.minimumLineSpacing + self.flowLayout.itemSize.width);
    } else {
        index = (self.mainView.contentOffset.y + (self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.minimumLineSpacing + self.flowLayout.itemSize.height);
    }
    
    return MAX(0, index);
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            //滚动无动画
            [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0]
                                  atScrollPosition:[self scrollPostion]
                                          animated:NO];
        }
        return;
    }
    
    //滚动带有动画
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0]
                          atScrollPosition:[self scrollPostion]
                                  animated:YES];
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.imagePathsGroup.count;
}

// MRAK: Public Method
- (void)clearCache {
    [[self class] clearImagesCache];
}

+ (void)clearImagesCache {
    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeDisk
                                                            completion:nil];
}

- (void)adjustWhenControllerViewWillAppera {
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]
                          atScrollPosition:[self scrollPostion]
                                  animated:NO];
    }
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index {
    [self invalidateTimer];
    
    if (0 == _totalItemsCount) return;
    
    [self scrollToIndex:(int)(_totalItemsCount * 0.5 + index)];
    
    if (self.autoScroll) {
        [self setupTimer];
    }
}

// MARK: UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WBCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)] &&
        [self.delegate respondsToSelector:@selector(customCollectionViewCellClassForCycleScrollView:)] && [self.delegate customCollectionViewCellClassForCycleScrollView:self]) {
        [self.delegate setupCustomCell:cell forIndex:itemIndex cycleScrollView:self];
        return cell;
    }else if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)] &&
              [self.delegate respondsToSelector:@selector(customCollectionViewCellNibForCycleScrollView:)] && [self.delegate customCollectionViewCellNibForCycleScrollView:self]) {
        [self.delegate setupCustomCell:cell forIndex:itemIndex cycleScrollView:self];
        return cell;
    }
    
     NSString *imagePath = self.imagePathsGroup[itemIndex];
    if ([imagePath isKindOfClass:[NSString class]]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]
                          placeholderImage:self.placeholderImage];
    }else {
        UIImage *image = [UIImage imageNamed:imagePath];
        if (!image) {
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
        cell.imageView.image = image;
    }
    
    cell.imageView.contentMode = self.bannerImageViewContentMode;
    cell.imageView.layer.cornerRadius = self.imageViewCornerRadius;
    cell.imageView.layer.masksToBounds = YES;
    cell.clipsToBounds = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self
                  didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}

// MARK: UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //解决清除timer时偶尔会出现的问题
    if (!self.imagePathsGroup.count) return;
    
//    self.mainView.userInteractionEnabled = NO;
    
    //滚动偏移量
    CGFloat totalImagewidth = (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * self.imagePathsGroup.count;
    CGFloat currentOffset = _mainView.contentOffset.x - (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * 50 * self.imagePathsGroup.count + self.flowLayout.minimumLineSpacing;
    CGFloat realOffset;
    if (currentOffset > 0) {
        realOffset = (int)currentOffset % (int)totalImagewidth;
    } else {
        realOffset = (int)currentOffset % (int)totalImagewidth + totalImagewidth;
    }
    ///步距
    CGFloat OneStepW = (int)(self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
    NSInteger offsetCurrent = (int)realOffset % (int)OneStepW;
    ///滑动进度
    CGFloat scrollRate = offsetCurrent / OneStepW;
    ///当前页
    NSInteger currentPage = realOffset / (int)OneStepW;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycScrollViewScrollRealOffset:scrollRate:currentPage:cycleScrollView:)]) {
        [self.delegate cycScrollViewScrollRealOffset:realOffset
                                          scrollRate:scrollRate
                                         currentPage:currentPage
                                     cycleScrollView:self];
    }
    
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastOffset = scrollView.contentOffset;
    
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    self.mainView.userInteractionEnabled = YES;
    //解决清除timer时偶尔会出现的问题
    if (!self.imagePathsGroup.count) return;
    
//    int itemIndex = [self currentIndex];
//    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
//
//    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
//        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //如果不是无限轮播，则返回
    if (!self.infiniteLoop) return;
    //横向滚动
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        ////如果是向右滑或者滑动距离大于item的一半，则像右移动一个item + space的距离，反之向左
        CGFloat currentPointX = scrollView.contentOffset.x;
        CGFloat moveWidth = currentPointX - _lastOffset.x;
        NSInteger shouldPage = moveWidth / (self.flowLayout.itemSize.width / 2);
        if (velocity.x > 0 || shouldPage > 0) {
            //左滑
            _dragDirection = 1;
        }else if (velocity.x < 0 || shouldPage < 0) {
            //右滑
            _dragDirection = -1;
        }else {
            _dragDirection = 0;
        }
//        self.mainView.userInteractionEnabled = NO;
        
        NSInteger currentIndex = (_lastOffset.x + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * 0.5) / (self.itemSpacing + self.itemSize.width);
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + _dragDirection inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                      animated:YES];
    }else {
        ////如果是向右滑或者滑动距离大于item的一半，则像右移动一个item + space的距离，反之向左
        CGFloat currentPointY = scrollView.contentOffset.y;
        CGFloat moveHeight = currentPointY - _lastOffset.y;
        NSInteger shouldPage = moveHeight / (self.flowLayout.itemSize.height / 2);
        if (velocity.y > 0 || shouldPage > 0) {
            //上滑
            _dragDirection = 1;
        }else if (velocity.y < 0 || shouldPage < 0) {
            //下滑
            _dragDirection = -1;
        }else {
            _dragDirection = 0;
        }
        
//        self.mainView.userInteractionEnabled = NO;
        
        NSInteger currentIndex = (_lastOffset.y + (self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.minimumLineSpacing + self.flowLayout.itemSize.height);
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + _dragDirection inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                      animated:YES];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //如果不是无限轮播，则返回
    if (!self.infiniteLoop) return;
    
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        NSInteger currentIndex = (_lastOffset.x + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.minimumLineSpacing + self.flowLayout.itemSize.width);
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + _dragDirection inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                      animated:YES];
    }else {
        NSInteger currentIndex = (_lastOffset.y + (self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.minimumLineSpacing + self.flowLayout.itemSize.height);
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + _dragDirection inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                      animated:YES];
    }
    
}

@end
