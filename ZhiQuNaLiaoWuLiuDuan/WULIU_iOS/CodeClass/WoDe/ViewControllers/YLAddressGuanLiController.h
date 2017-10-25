//
//  YLAddressGuanLiController.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLBaseViewController.h"
#import "YLAddressModal.h"

@class YLAddressGuanLiController;

@protocol AddressGuanLiDelegate <NSObject>

-(void)didFinishClickAdress:(YLAddressModal *)resultAddress;

@end

@interface YLAddressGuanLiController : WLBaseViewController


/**
 地址选择代理
 */
@property(nonatomic,strong) id<AddressGuanLiDelegate> delegate;

//初始化数据
-(void)initData;

@property(nonatomic,strong)NSString *pageSource;
@end
