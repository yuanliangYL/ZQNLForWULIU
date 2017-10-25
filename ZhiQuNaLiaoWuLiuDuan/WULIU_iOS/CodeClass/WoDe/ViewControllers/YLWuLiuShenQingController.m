//
//  YLWuLiuShenQingController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/26.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLWuLiuShenQingController.h"
#import "YLOrderTopView.h"
#import "YLDaBaoZhanSQController.h"
#import "YLWoDeSQController.h"

@interface YLWuLiuShenQingController ()
//当前订单类型
@property(nonatomic,assign)NSInteger orderType;

//打包站申请视图
@property(nonatomic,strong)YLDaBaoZhanSQController *dsvc;

//我的申请视图
@property(nonatomic,strong)YLWoDeSQController *pvc;


@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation YLWuLiuShenQingController

- (void)viewDidLoad {
    
     [super viewDidLoad];
   
     [self initdata];
    
     [self setupNavi];
    
     [self setupUI];
}

#pragma mark - initdata
-(void)initdata{
    
    self.orderType = 1;
    
}


#pragma mark - setupNavi
-(void)setupNavi{
    
    //中部title 视图
    //避免循环强引用的方式
    __weak typeof(self) weakSelf = self;
    YLOrderTopView *topView = [[YLOrderTopView alloc]initWiteFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 36)];
    topView.block = ^(NSInteger tag){
        
        weakSelf.orderType = tag;
        
        NSLog(@"%ld",(long)weakSelf.orderType);
        
        [weakSelf renderScrollerBytag:tag];
        
    };
    
    self.navigationItem.titleView  = topView;
}

/**
 头部订单类型选择
 
 @param tag tag
 */
-(void)renderScrollerBytag:(NSInteger)tag{
    
    //  点击处于当前页面的按钮,直接跳出
    if ((tag == 1 && self.currentVC == self.dsvc) || (tag == 2 && self.currentVC == self.pvc)) {
        
        return;
        
    }else{
        
        switch (tag) {
                
            case 1:
                [self replaceController:self.currentVC newController:self.dsvc];
                break;
                
            case 2:
                [self replaceController:self.currentVC newController:self.pvc];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - setupUI
-(void)setupUI{
    
    //直销
    self.dsvc = [[YLDaBaoZhanSQController alloc]init];
    self.dsvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    
    [self addChildViewController:self.dsvc];
    
    //采购
    self.pvc = [[YLWoDeSQController alloc]init];
    self.pvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.view addSubview:self.dsvc.view];
    self.currentVC = self.dsvc;
    
}

//切换订单类型的内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
        }
    }];
}


@end
