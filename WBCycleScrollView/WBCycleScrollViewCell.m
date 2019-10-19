//
//  WBCycleScrollViewCell.m
//  Pods-WBCycleScrollView_Example
//
//  Created by 文波 on 2019/10/19.
//

#import "WBCycleScrollViewCell.h"

@implementation WBCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end
