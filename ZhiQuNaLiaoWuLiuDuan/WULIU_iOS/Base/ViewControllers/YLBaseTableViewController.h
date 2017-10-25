//
//  YLBaseTableViewController.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/10/10.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYNUllOrderView.h"
#import "ZYWifiBugView.h"
#import "ZYLoadingDataView.h"
#import "ZYLoadingFialdView.h"
typedef NS_ENUM(NSUInteger, STYLE) {
    ORDER,
    SHENHE,
    XIAOXI,
    BIAOZHUN
};
typedef void(^RefreshWifi)();
typedef void(^RefreshLoad)();
@interface YLBaseTableViewController : UITableViewController
@property (nonatomic, strong) ZYWifiBugView *wifibugView;
@property (nonatomic, strong) ZYNUllOrderView *nullOrderView;
@property (nonatomic, strong) ZYLoadingDataView *loadingdataView;
@property (nonatomic, strong) ZYLoadingFialdView *loadingFialdView;

@property (nonatomic, strong) RefreshWifi refreshWifi;
@property (nonatomic, strong) RefreshLoad refreshLoad;
//网络情况
- (void)networkAnomalyWithView:(UIView *)view refresh:(RefreshWifi)refresh;
//没有订单
- (void)nullOrderViewWithView:(UIView *)view type:(STYLE)type;
//有订单
- (void)hasOrderViewWithView:(UIView *)view;
//正在加载数据
- (void)loadingDataWithView:(UIView *)view;
//数据加载成功
- (void)loadSuccessDataWithView:(UIView *)view;
//数据加载失败
- (void)loadingFialdWithView:(UIView *)view refresh:(RefreshLoad)refresh;


- (void)toDetermineWhetherPhoneNetwork;
@end
