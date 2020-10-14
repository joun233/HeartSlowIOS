//
//  FindViewController.m
//  HeartSlowIOS
//
//  Created by eileenjiang(姜楠) on 2020/9/25.
//  Copyright © 2020 Eileenjiang. All rights reserved.
//

#import "JHSFindViewController.h"

@interface JHSFindViewController ()

@end

@implementation JHSFindViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"发现";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/icon_discover@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_discover_press@2x.png"];
    }
    return self;
}


@end
