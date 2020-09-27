//
//  HSListenViewController.m
//  HeartSlowIOS
//
//  Created by eileenjiang(姜楠) on 2020/9/25.
//  Copyright © 2020 Eileenjiang. All rights reserved.
//

#import "HSHomeViewController.h"

@interface HSHomeViewController ()

@end

@implementation HSHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/icon_home@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_home_press@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
