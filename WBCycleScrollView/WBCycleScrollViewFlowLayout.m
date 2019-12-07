//
//  WBCycleScrollViewFlowLayout.m
//  Pods-WBCycleScrollView_Example
//
//  Created by 文波 on 2019/10/19.
//

#import "WBCycleScrollViewFlowLayout.h"

@implementation WBCycleScrollViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isZoom = NO;
        _maximumScale = 1.f;
        _minimumScale = .9f;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.isZoom) return [super layoutAttributesForElementsInRect:rect];
    
    NSArray <UICollectionViewLayoutAttributes *>*attributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        //计算整体的中心点的x值
        CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
        CGFloat distanceForMinimumScale = self.itemSize.width + self.minimumLineSpacing;
        CGFloat distanceForMaximumScale = 0.0;
        for (UICollectionViewLayoutAttributes *attribute in attributes) {
            CGFloat scale = 0;
            //计算每个cell的中心点距离
            CGFloat distance = ABS(attribute.center.x - centerX);
            if (distance >= distanceForMinimumScale) {
                scale = self.minimumScale;
            } else if (distance == distanceForMaximumScale) {
                scale = self.maximumScale;
            } else {
                scale = self.minimumScale + (distanceForMinimumScale - distance) * (self.maximumScale - self.minimumScale) / (distanceForMinimumScale - distanceForMaximumScale);
            }
            //距离越大，缩放比越小，距离越小，缩放比越大
            attribute.transform3D = CATransform3DMakeScale(scale, scale, 1);
            attribute.zIndex = 1;
        }
    }else {
        CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.bounds.size.height * 0.5;
        CGFloat distanceForMinimumScale = self.itemSize.height + self.minimumLineSpacing;
        CGFloat distanceForMaximumScale = 0.0;
        
        for (UICollectionViewLayoutAttributes *attribute in attributes) {
            CGFloat scale = 0;
            //计算每个cell的中心点距离
            CGFloat distance = ABS(attribute.center.y - centerY);
            //距离越大，缩放比越小，距离越小，缩放比越大
            if (distance >= distanceForMinimumScale) {
                scale = self.minimumScale;
            } else if (distance == distanceForMaximumScale) {
                scale = self.maximumScale;
            } else {
                scale = self.minimumScale + (distanceForMinimumScale - distance) * (self.maximumScale - self.minimumScale) / (distanceForMinimumScale - distanceForMaximumScale);
            }
            //距离越大，缩放比越小，距离越小，缩放比越大
            attribute.transform3D = CATransform3DMakeScale(scale, scale, 1);
            attribute.zIndex = 1;
        }
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
