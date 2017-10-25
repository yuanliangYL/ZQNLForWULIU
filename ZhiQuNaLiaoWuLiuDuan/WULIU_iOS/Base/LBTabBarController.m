//
//  LBTabBarController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBarController.h"
#import "LBNavigationController.h"
#import "LBTabBar.h"
#import "UIImage+Image.h"
#import "WLDingDanViewController.h"
#import "WLJieDanViewController.h"
#import "WLFaBuViewController.h"
#import "WLWoDeViewController.h"


@interface LBTabBarController ()<LBTabBarDelegate>

@end

@implementation LBTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllChildVc];

    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    LBTabBar *tabbar = [[LBTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];


}


#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{
    WLJieDanViewController *jiedanVC = [[WLJieDanViewController alloc] init];
    [self  setUpOneChildVcWithVc:jiedanVC Image:@"tab_icon_jiedan_n" selectedImage:@"tab_icon_jiedan_p" title:@"接单"];
    WLFaBuViewController *fabuVC = [[WLFaBuViewController alloc] init];
    [self setUpOneChildVcWithVc:fabuVC Image:@"tab_icon_fabu_n" selectedImage:@"tab_icon_fabu_p" title:@"发布"];
    WLDingDanViewController *dingdanVC = [[WLDingDanViewController alloc] init];
    [self setUpOneChildVcWithVc:dingdanVC Image:@"tab_icon_order_n" selectedImage:@"tab_icon_order_p" title:@"订单"];
    WLWoDeViewController *wodeVC = [[WLWoDeViewController alloc] init];
    [self setUpOneChildVcWithVc:wodeVC Image:@"tab_icon_my_n" selectedImage:@"tab_icon_my_p" title:@"我的"];

}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    LBNavigationController *nav = [[LBNavigationController alloc] initWithRootViewController:Vc];


//    Vc.view.backgroundColor = [self randomColor];

    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;

    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    Vc.tabBarItem.selectedImage = mySelectedImage;

    Vc.tabBarItem.title = title;
//    Vc.tabBarItem.badgeValue = @"2";

    Vc.navigationItem.title = title;

    [self addChildViewController:nav];
    
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{
//
//    ZYPublishViewController *plusVC = [[ZYPublishViewController alloc] init];
//
//    
//     LBNavigationController *navVc = [[LBNavigationController alloc] initWithRootViewController:plusVC];
//    navVc.navigationBarHidden = YES;
//    
//    [self presentViewController:navVc animated:YES completion:nil];



}


@end
