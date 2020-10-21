//
//  JHSImageSliderCell.h
//  HeartSlowIOS
//
//  Created by eileenjiang(姜楠) on 2020/10/21.
//  Copyright © 2020 Eileenjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSImageSliderCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;

@end
