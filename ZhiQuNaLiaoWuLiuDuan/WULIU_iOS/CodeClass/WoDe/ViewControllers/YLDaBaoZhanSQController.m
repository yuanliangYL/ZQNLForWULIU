//
//  YLDaBaoZhanSQController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/26.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDaBaoZhanSQController.h"
#import "YLSQTableViewController.h"
#import <MJCSegmentInterface/MJCSegmentInterface.h>
@interface YLDaBaoZhanSQController ()<MJCSegmentDelegate>

@property(nonatomic,strong)NSArray *statusArr;

@property(nonatomic,strong)NSMutableArray *controllerArr;

@end

@implementation YLDaBaoZhanSQController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     [self setupUI];

}

-(void)setupUI{
    
    self.statusArr = [NSArray arrayWithObjects:@"全部",@"待处理",@"已完成", nil];
    
    [self renderPageController:self.statusArr];
}


/**
 渲染子页面控制器
 
 @param arr 页面数组
 
 */
-(void)renderPageController:(NSArray *)arr{
    
//    MJCSegmentInterface *segmentsface = [MJCSegmentInterface showInterfaceWithTitleBarFrame:MJCTitlesClassicStyle  MJCSegmentInterface *segmentsface = [MJCSegmentInterfaceframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    MJCSegmentInterface *segmentsface = [MJCSegmentInterface showInterfaceWithTitleBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) Styles:MJCTitlesClassicStyle];
    
    segmentsface.indicatorColor = [UIColor yl_toUIColorByStr:@"#ff5000"];
    segmentsface.itemTextSelectedColor = [UIColor yl_toUIColorByStr:@"#ff5000"];
    segmentsface.itemTextNormalColor = [UIColor yl_toUIColorByStr:@"#666666"];
    segmentsface.itemTextFontSize = [UIFont adjustFontsize:15];
    
    segmentsface.isChildScollEnabled = YES;
    [segmentsface intoTitlesArray:arr hostController:self];
    
    [self.view addSubview:segmentsface];
    
    self.controllerArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arr.count; i ++) {
        
        YLSQTableViewController *vc = [[YLSQTableViewController alloc]init];
        
        //订单类型
        vc.orderType = 2;
        
        if (i == 0 ) {
            
            vc.ShenQingStatusType = 2;
            
        }else if (i == 1){
            
            vc.ShenQingStatusType = 0;
            
        }else{
            
            vc.ShenQingStatusType = 1;
        }
        

        [self.controllerArr addObject:vc];
    }
    
    [segmentsface intoChildControllerArray:self.controllerArr];
}

#pragma mark - MJCSegmentDelegate
- (void)mjc_ClickEvent:(UIButton *)tabItem childViewController:(UIViewController *)childViewController segmentInterface:(MJCSegmentInterface *)segmentInterface{
    
    
}

@end
