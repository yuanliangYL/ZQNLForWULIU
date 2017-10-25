//
//  YLDingDanDetailModel.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/9/1.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Detail_of_orders,Pack_info;
@interface YLDingDanDetailModel : NSObject
@property (nonatomic, strong) NSMutableArray *detail_of_orders;
@property (nonatomic, strong) NSMutableArray *pack_info;
@end

@interface Detail_of_orders : NSObject
/** 物流发货地*/
@property (nonatomic, copy) NSString *plor_send_address;
/** 物流收货地址*/
@property (nonatomic, copy) NSString *plor_take_address;
/** 物流支付日期*/
@property (nonatomic, copy) NSString *plor_pay_date;
/** 物流订单发货日期*/
@property (nonatomic, copy) NSString *plor_send_date;
/** 物流订单重量*/
@property (nonatomic, strong) NSNumber *plor_weight;
/** 物流订单价格*/
@property (nonatomic, strong) NSNumber *plor_total;
/** 物流订单状态（1待提货
 1.待收货
 2.已完成
 ）
*/
@property (nonatomic, copy) NSString *plor_order_state;
/** 物流订单创建时间*/
@property (nonatomic, copy) NSString *created_at;
/** 物流支付编号*/
@property (nonatomic, copy) NSString *plor_pay_number;
/** 物流订单编号*/
@property (nonatomic, copy) NSString *plor_number;

@end

@interface Pack_info : NSObject
/** */
@property (nonatomic, copy) NSString *pk_phone;
/** */
@property (nonatomic, copy) NSString *pk_credit_score;
/** */
@property (nonatomic, copy) NSString *pk_address;
/** */
@property (nonatomic, copy) NSString *pk_real_name;
/** */
@property (nonatomic, copy) NSString *pk_headurl;


@end
