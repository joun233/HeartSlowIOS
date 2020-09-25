//
//  ChatViewController.m
//  HeartSlowIOS
//
//  Created by eileenjiang(姜楠) on 2020/9/25.
//  Copyright © 2020 Eileenjiang. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"树洞";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/icon_hot@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_hot_press@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end