//
//  JieDanModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/21.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JieDanModel : NSObject
/** am_or_pm*/
@property (nonatomic, strong) NSNumber *am_or_pm;
/** 操作类型，1为直销订单列表，2为采购订单列表*/
@property (nonatomic, strong) NSNumber *order_type;
/** 打包站id*/
@property (nonatomic, strong) NSNumber *pack_id;
/** 打包站头像*/
@property (nonatomic, copy) NSString *pack_logo;
/** 打包站联系人姓名*/
@property (nonatomic, copy) NSString *pack_name;
/** 打包站手机号*/
@property (nonatomic, copy) NSString *pack_phone;
/** 打包站发货时间*/
@property (nonatomic, copy) NSString *pack_send_time;
/** 货物重量*/
@property (nonatomic, strong) NSNumber *paper_estimate_num;
/** 直销订单id*/
@property (nonatomic, strong) NSNumber *so_id;
/** 直销发货地址*/
@property (nonatomic, copy) NSString *so_send_address;
/** 直销订单发货城市*/
@property (nonatomic, copy) NSString *so_send_city;
/** 直销订单发货区域*/
@property (nonatomic, copy) NSString *so_send_dist;
/** 直销订单发货省份*/
@property (nonatomic, copy) NSString *so_send_province;
/** 直销订单收货地址，*/
@property (nonatomic, copy) NSString *so_take_address;
/** 直销订单收货城市*/
@property (nonatomic, copy) NSString *so_take_city;
/** 直销订单收货区域*/
@property (nonatomic, copy) NSString *so_take_dist;
/** 直销订单收货省份*/
@property (nonatomic, copy) NSString *so_take_province;

@end


@interface CaiGouModel : NSObject
/** am_or_pm*/
@property (nonatomic, strong) NSNumber *am_or_pm;
/** 操作类型，1为直销订单列表，2为采购订单列表*/
@property (nonatomic, strong) NSNumber *order_type;
/** 打包站id*/
@property (nonatomic, strong) NSNumber *pack_id;
/** 打包站头像*/
@property (nonatomic, copy) NSString *pack_logo;
/** 打包站联系人姓名*/
@property (nonatomic, copy) NSString *pack_name;
/** 打包站手机号*/
@property (nonatomic, copy) NSString *pack_phone;
/** 打包站发货时间*/
@property (nonatomic, copy) NSString *pack_send_time;
/** 货物重量*/
@property (nonatomic, strong) NSNumber *paper_estimate_num;
/** 采购订单id*/
@property (nonatomic, strong) NSNumber *pod_id;
/** 采购发货地址*/
@property (nonatomic, copy) NSString *pod_send_address;
/** 采购订单发货城市*/
@property (nonatomic, copy) NSString *pod_send_city;
/** 采购订单发货区域*/
@property (nonatomic, copy) NSString *pod_send_dist;
/** 采购订单发货省份*/
@property (nonatomic, copy) NSString *pod_send_province;
/** 采购订单收货地址，*/
@property (nonatomic, copy) NSString *pod_take_address;
/** 采购订单收货城市*/
@property (nonatomic, copy) NSString *pod_take_city;
/** 采购订单收货区域*/
@property (nonatomic, copy) NSString *pod_take_dist;
/** 采购订单收货省份*/
@property (nonatomic, copy) NSString *pod_take_province;
@end
