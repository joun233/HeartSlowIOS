//
//  HSListenViewController.m
//  HeartSlowIOS
//
//  Created by eileenjiang(姜楠) on 2020/9/25.
//  Copyright © 2020 Eileenjiang. All rights reserved.
//

#import "JHSHomeViewController.h"
#import "JHSImageSliderView.h"
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobFile.h>

#define kHomeViewHigth 150
#define kTitleLabelHeight 25
#define kScrollDuration 2.f

@interface JHSHomeViewController ()

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *actionUrls;

@end

@implementation JHSHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/icon_home@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_home_press@2x.png"];
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.images = [NSMutableArray array];
        self.titles = [NSMutableArray array];
        self.actionUrls = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryDataToImagesSilderView];
}


- (void)queryDataToImagesSilderView {
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"ImageSlider"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            [self.titles addObject:[obj objectForKey:@"sliderTitle"]];
            BmobFile *imageFile = [obj objectForKey:@"imageUrl"];
            [self.images addObject:imageFile.url];
            [self.actionUrls addObject:[obj objectForKey:@"webUrl"]];
        }
        
        JHSImageSliderView *cv = [JHSImageSliderView carouselViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHomeViewHigth) placeholderImage:nil images:^NSArray *{
            return self.images;
        } titles:^NSArray *{
            return self.titles;
        } selectedBlock:^(NSInteger index) {
            NSLog(@"clicked1----%zi", index);
        }];
        cv.titleLabelHeight            = kTitleLabelHeight;
        cv.titleLabelTextColor         = [UIColor whiteColor];
        cv.titleLabelBackgroundColor   = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        cv.pageControlCurrentPageColor = [UIColor whiteColor];
        cv.pageControlNormalPageColor  = [UIColor grayColor];
        cv.scrollDuration              = kScrollDuration;
        [self.view addSubview:cv];
        
    }];
    
   
}

@end
