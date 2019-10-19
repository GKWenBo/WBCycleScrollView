//
//  WBCycleScrollViewFlowLayout.m
//  Pods-WBCycleScrollView_Example
//
//  Created by 文波 on 2019/10/19.
//

#import "WBCycleScrollViewFlowLayout.h"

@implementation WBCycleScrollViewFlowLayout


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.isZoom) return [super layoutAttributesForElementsInRect:rect];
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        //计算整体的中心点的x值
        CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
        for (UICollectionViewLayoutAttributes *attribute in attributes) {
            //计算每个cell的中心点距离
            CGFloat distance = ABS(attribute.center.x - centerX);
            //距离越大，缩放比越小，距离越小，缩放比越大
            CGFloat factor = 0.001;
            CGFloat scale = 1 / (1 + distance * factor);
            attribute.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }else {
        CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.bounds.size.height * 0.5;
        for (UICollectionViewLayoutAttributes *attribute in attributes) {
            //计算每个cell的中心点距离
            CGFloat distance = ABS(attribute.center.y - centerY);
            //距离越大，缩放比越小，距离越小，缩放比越大
            CGFloat factor = 0.001;
            CGFloat scale = 1 / (1 + distance * factor);
            attribute.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
