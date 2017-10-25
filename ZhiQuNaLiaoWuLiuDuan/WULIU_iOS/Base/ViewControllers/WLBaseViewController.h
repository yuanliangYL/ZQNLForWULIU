//
//  WLBaseViewController.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYNUllOrderView.h"
#import "ZYWifiBugView.h"
#import "ZYLoadingDataView.h"
#import "ZYLoadingFialdView.h"

typedef NS_ENUM(NSUInteger, TYPE) {
    ORDER,
    SHENHE,
    XIAOXI,
    FABU,
    SHENQING
};

typedef void(^RefreshWifi)();
typedef void(^RefreshLoad)();

@interface WLBaseViewController : UIViewController

@property (nonatomic, strong) ZYWifiBugView *wifibugView;
@property (nonatomic, strong) ZYNUllOrderView *nullOrderView;
@property (nonatomic, strong) ZYLoadingDataView *loadingdataView;
@property (nonatomic, strong) ZYLoadingFialdView *loadingFialdView;

@property (nonatomic, strong) RefreshWifi refreshWifi;
@property (nonatomic, strong) RefreshLoad refreshLoad;

//网络情况
- (void)networkAnomalyWithView:(UIView *)view refresh:(RefreshWifi)refresh;

//没有订单
- (void)nullOrderViewWithView:(UIView *)view withFrame:(CGRect)frame type:(TYPE )type;

//有订单
- (void)hasOrderViewWithView:(UIView *)view;

//正在加载数据
- (void)loadingDataWithView:(UIView *)view;

//数据加载成功
- (void)loadSuccessDataWithView:(UIView *)view;

//数据加载失败
- (void)loadingFialdWithView:(UIView *)view refresh:(RefreshLoad)refresh;

@end
