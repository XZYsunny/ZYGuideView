//
//  ViewController.m
//  ZYGuideViewDemo
//
//  Created by sunny on 2017/3/20.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ViewController.h"
#import "ZYGuideView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /* 注意放在AppDelegate.m 设置过rootVC之后
     *  可以添加不同的images数组来实现不同尺寸的屏幕适配 
     */
    NSMutableArray *imageArray = [NSMutableArray arrayWithArray:@[@"welcome_6_0",@"welcome_6_1",@"welcome_6_2",@"welcome_6_3"]];
    ZYGuideView *guideView = [[ZYGuideView alloc] initWithImages:imageArray EnterBtnImageName:@""];
    guideView.isScrollOut = YES;
    [self.view addSubview:guideView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
