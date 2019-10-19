//
//  WBCycleScrollViewCell.h
//  Pods-WBCycleScrollView_Example
//
//  Created by 文波 on 2019/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBCycleScrollViewCell : UICollectionViewCell

/**
 图片视图
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 是否配置
 */
@property (nonatomic, assign) BOOL hasConfigured;

@end

NS_ASSUME_NONNULL_END
