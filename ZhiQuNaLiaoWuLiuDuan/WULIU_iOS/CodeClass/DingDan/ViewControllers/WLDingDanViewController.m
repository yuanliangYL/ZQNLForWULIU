//
//  WLDingDanViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLDingDanViewController.h"
#import "YLDaiTiHuoViewController.h"
#import "YLDaiShouHuoViewController.h"
#import "YLDaiJiSuanViewController.h"
#import "YLYiWanChengViewController.h"
#import "YLQuanBuViewController.h"


@interface WLDingDanViewController ()

@end

@implementation WLDingDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"纸元物流";
    
    YLQuanBuViewController *quanbuVC = [[YLQuanBuViewController alloc] init];
    quanbuVC.title = @"全部";
    quanbuVC.slug = 0;
    
    YLQuanBuViewController *daitihuoVC = [[ YLQuanBuViewController alloc] init];
    daitihuoVC.title = @"待提货";
    daitihuoVC.slug = 1;
    
    
    YLQuanBuViewController *daishuohuoVC = [[YLQuanBuViewController alloc] init];
    daishuohuoVC.title = @"待收货";
    daishuohuoVC.slug = 2;
    
//
//    YLDaiJiSuanViewController *daijiesuanVC = [[YLDaiJiSuanViewController alloc] init];
//    daijiesuanVC.title = @"待结算";
    
    YLQuanBuViewController  *yiwanchengVC = [[YLQuanBuViewController  alloc] init];
    yiwanchengVC.title  = @"已完成";
    yiwanchengVC.slug = 3;
    
    self.viewControllers = @[quanbuVC, daitihuoVC, daishuohuoVC, yiwanchengVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
