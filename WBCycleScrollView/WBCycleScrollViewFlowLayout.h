//
//  WBCycleScrollViewFlowLayout.h
//  Pods-WBCycleScrollView_Example
//
//  Created by 文波 on 2019/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBCycleScrollViewFlowLayout : UICollectionViewFlowLayout

/**
 是否缩放
 */
@property (nonatomic, assign) BOOL isZoom;

/**
 *  中间那张卡片基于初始大小的缩放倍数，默认为 1.0 isZoom为YES设置有效
 */
@property(nonatomic, assign) CGFloat maximumScale;

/**
 *  除了中间之外的其他卡片基于初始大小的缩放倍数，默认为 0.9 isZoom为YES设置有效
 */
@property(nonatomic, assign) CGFloat minimumScale;

@end

NS_ASSUME_NONNULL_END
