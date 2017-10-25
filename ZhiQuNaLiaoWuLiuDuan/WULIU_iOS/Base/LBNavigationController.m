//
//  LBNavigationController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBNavigationController.h"
#import "LBTabBarController.h"
#import "UIImage+Image.h"

@interface LBNavigationController ()

@end

@implementation LBNavigationController

+ (void)load
{


    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self] ];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    dic[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
  
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20,SCREEN_WIDTH , 20)];
    view.backgroundColor = [UIColor colorWithHexString:@"#46c01b"];
    [bar addSubview:view];
    
   
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#46c01b"]] forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor colorWithHexString:@"#46c01b"];
    bar.shadowImage = [[UIImage alloc] init];
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    bar.tintColor = [UIColor whiteColor];
    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];

    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [bar setTitleTextAttributes:dic];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    //左侧消息按钮
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiaoxi_return"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;

    
    }

    return [super pushViewController:viewController animated:animated];
}









@end
