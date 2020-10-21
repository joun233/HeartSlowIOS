//
//  LPCarouselView.m
//  HeartSlowIOS
//
//  Created by eileenjiang(姜楠) on 2020/10/14.
//  Copyright © 2020 Eileenjiang. All rights reserved.
//

#import "JHSImageSliderView.h"
#import "JHSImageSliderCell.h"
#import <SDWebImage/SDWebImage.h>

@interface JHSImageSliderView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) DidSelectCarouselItemBlock didSelectCarouselItemBlock;

@end

@implementation JHSImageSliderView

@synthesize scrollDuration = _scrollDuration;

static NSInteger const kMaxSections                    = 100;
static CGFloat const kDefaultScrollDuration            = 2.f;
static NSString *const kLPCarouselCollectionViewCellID = @"kLPCarouselCollectionViewCellID";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCarouselView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupCarouselView];
}

+ (instancetype)carouselViewWithFrame:(CGRect)frame
                     placeholderImage:(UIImage *)placeholderImage
                               images:(ImagesDataSourceBlock)images
                               titles:(TitlesDataSourceBlock)titles
                        selectedBlock:(DidSelectCarouselItemBlock)selectedBlock {
    JHSImageSliderView *imageSilderView = [[self alloc] initWithFrame:frame];
    imageSilderView.images = images ? [images() copy] : [NSArray array];
    imageSilderView.titles = titles ? [titles() copy] : [NSArray array];
    imageSilderView.didSelectCarouselItemBlock = selectedBlock ? selectedBlock : nil;
    imageSilderView.placeholderImageView = [[UIImageView alloc] init];
    imageSilderView.placeholderImage = placeholderImage ? : nil;
    if (images().count > 0) {
        [imageSilderView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:kMaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    return imageSilderView;
}

- (void)setupCarouselView {
    UICollectionViewFlowLayout *flowLayout        = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize                           = self.frame.size;
    flowLayout.scrollDirection                    = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing                 = 0;
    UICollectionView *collectionView              = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.delegate                       = self;
    collectionView.dataSource                     = self;
    collectionView.pagingEnabled                  = YES;
    collectionView.backgroundColor                = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollsToTop                   = NO;
    _collectionView                               = collectionView;
    [self addSubview:collectionView];
    [_collectionView registerClass:[JHSImageSliderCell class] forCellWithReuseIdentifier:kLPCarouselCollectionViewCellID];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_pageControl) {
        CGFloat pageControlHeight                 = 10;
        CGFloat pageControlMargin                 = 10;
        UIPageControl *pageControl                = [[UIPageControl alloc] init];
        pageControl.enabled                       = NO;
        pageControl.numberOfPages                 = self.images.count;
        CGPoint pageControlCenter                 = CGPointZero;
        CGSize pageControlSize                    = [pageControl sizeForNumberOfPages:self.images.count];
        switch (self.pageControlPosition) {
            case CarouselViewPageControlPositionRight:
                pageControlCenter = CGPointMake(self.bounds.size.width - pageControlSize.width * 0.5 - pageControlMargin, self.bounds.size.height - pageControlHeight);
                break;
                
            case CarouselViewPageControlPositionLeft:
                pageControlCenter = CGPointMake(pageControlSize.width * 0.5 + pageControlMargin, self.bounds.size.height - pageControlHeight);
                break;
                
            default:
                pageControlCenter = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - pageControlHeight);
                break;
        }
        pageControl.bounds                        = CGRectMake(0, 0, pageControlSize.width, pageControlHeight);
        pageControl.center                        = pageControlCenter;
        pageControl.pageIndicatorTintColor        = self.pageControlNormalPageColor;
        pageControl.currentPageIndicatorTintColor = self.pageControlCurrentPageColor;
        _pageControl                              = pageControl;
        [self addSubview:pageControl];
        if (!self.turnOffInfiniteLoop) {
            [self addTimer];
        }
    }
}

#pragma mark - timer handler 📌
- (void)addTimer {
    [self removeTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollDuration target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextpage {
    if (self.images.count > 0) {
        if (self.images.count == 1 && self.turnOffSingleImageLoop) {
            return;
        }
        NSIndexPath *currentIndexPath      = [[self.collectionView indexPathsForVisibleItems] lastObject];
        NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:kMaxSections/2];
        [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        NSInteger nextItem    = currentIndexPathReset.item + 1;
        NSInteger nextSection = currentIndexPathReset.section;
        if (nextItem == self.images.count) {
            nextItem = 0;
            nextSection++;
        }
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource & delegate 📌
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.images.count == 1 && self.turnOffSingleImageLoop) {
        return 1;
    } else {
        return kMaxSections;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHSImageSliderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLPCarouselCollectionViewCellID forIndexPath:indexPath];
    if (self.images.count) {
        NSString *imagePath = nil;
        if ([self.images[indexPath.item] isKindOfClass:[NSURL class]]) {
            NSURL *imageUrl = self.images[indexPath.item];
            imagePath = imageUrl.absoluteString;
        } else if ([self.images[indexPath.item] isKindOfClass:[NSString class]]) {
            imagePath = self.images[indexPath.item];
        } else if ([self.images[indexPath.item] isKindOfClass:[UIImage class]]) {
            cell.imageView.image = self.images[indexPath.item];
        }
        if (imagePath) {
            if ([imagePath hasPrefix:@"http"] || [imagePath hasPrefix:@"https"]) {
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
            } else {
                cell.imageView.image = [UIImage imageNamed:imagePath];
            }
            cell.imageView.contentMode     = self.carouselImageViewContentMode;
            cell.clipsToBounds             = YES;
        }
    }
    if (self.titles.count) {
        cell.title                     = self.titles[indexPath.item];
        //config
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight          = self.titleLabelHeight;
        cell.titleLabelTextColor       = self.titleLabelTextColor;
        cell.titleLabelTextFont        = self.titleLabelTextFont;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectCarouselItemBlock) {
        self.didSelectCarouselItemBlock(indexPath.item);
    }
}

#pragma mark - configure 📌
- (UIColor *)titleLabelBackgroundColor {
    return _titleLabelBackgroundColor ? : [UIColor clearColor];
}

- (CGFloat)titleLabelHeight {
    return _titleLabelHeight ? : 15.f;
}

- (UIColor *)titleLabelTextColor {
    return _titleLabelTextColor ? : [UIColor blackColor];
}

- (UIFont *)titleLabelTextFont {
    return _titleLabelTextFont ? : [UIFont systemFontOfSize:12.f];
}

- (UIViewContentMode)carouselImageViewContentMode {
    return _carouselImageViewContentMode ? : UIViewContentModeScaleAspectFill;
}

- (UIColor *)pageControlCurrentPageColor {
    return _pageControlCurrentPageColor ? : [UIColor whiteColor];
}

- (UIColor *)pageControlNormalPageColor {
    return _pageControlNormalPageColor ? : [UIColor colorWithWhite:1.f alpha:0.5];
}

- (void)setTurnOffSingleImageLoop:(BOOL)turnOffSingleImageLoop {
    _turnOffSingleImageLoop = turnOffSingleImageLoop;
    [self.collectionView reloadData];
}

#pragma mark - scrollView delegate 📌
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!self.turnOffInfiniteLoop) {
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.turnOffInfiniteLoop) {
        [self addTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width + 0.5) % self.images.count;
    _pageControl.currentPage = page;
}

#pragma mark - setter 📌
- (void)setScrollDuration:(CGFloat)scrollDuration {
    _scrollDuration = scrollDuration;
    if (!self.turnOffInfiniteLoop) {
        [self addTimer];
    }
}

- (CGFloat)scrollDuration {
    return _scrollDuration ? : kDefaultScrollDuration;
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

@end
