//
//  LPCarouselViewCell.m
//  HeartSlowIOS
//
//  Created by eileenjiang(姜楠) on 2020/10/14.
//  Copyright © 2020 Eileenjiang. All rights reserved.
//


#import "JHSImageSliderCell.h"

@implementation JHSImageSliderCell
{
    __weak UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor {
    _titleLabelBackgroundColor  = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
    _titleLabelTextColor  = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont {
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font    = titleLabelTextFont;
}

- (void)setupImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView             = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel         = titleLabel;
    _titleLabel.hidden  = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title           = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"%@", title];
}

- (CGFloat)titleLabelHeight {
    return _titleLabelHeight ? : 15;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame    = self.bounds;
    CGFloat titleLabelW = self.frame.size.width;
    CGFloat titleLabelH = self.titleLabelHeight;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.frame.size.height - titleLabelH;
    _titleLabel.frame   = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.hidden  = !_titleLabel.text;
}

@end
