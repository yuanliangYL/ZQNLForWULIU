//
//  DingDanListModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/21.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StatusTypeDaiTiHuo = 0,
    StatusTypeDaiSHouHuo = 1,
    StatusTypeDaiJieSuan = 2,
    StatusTypeDaiYiWanCheng = 3
}StatusType;

@interface DingDanListModel : NSObject
@property (nonatomic, strong) UIImageView *headerImageview;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *qujian;
@property (nonatomic, copy) NSString *riqi;
@property (nonatomic, copy) NSString *zhongliang;
@property (nonatomic, copy) NSString *baojia;
@property (nonatomic, copy) NSString *leftBtnTitle;

/** buzhidao*/
@property (nonatomic, copy) NSString *issu ;


/** 商品订单id*/
@property (nonatomic, strong) NSNumber *order_id;
/** 物流订单关联的订单类型（1直销订单，2为采购订单）*/
@property (nonatomic, strong) NSNumber *order_type;
/** 打包站id*/
@property (nonatomic, strong) NSNumber *pack_id;
/** 打包站头像*/
@property (nonatomic, copy) NSString *pk_headurl;

/** 打包站手机号*/
@property (nonatomic, copy) NSString *pk_phone;

/** 打包站名字*/
@property (nonatomic, copy) NSString *pk_real_name;

/** 物流订单id*/
@property (nonatomic, strong) NSNumber *plor_id;
/** 物流订单编号*/
@property (nonatomic, copy) NSString *plor_number;

/** 物流订单状态（1待提货
 1.待收货
 2.已完成
 ），
*/
@property (nonatomic, strong) NSNumber *plor_order_state;
/** 物流支付编号*/
@property (nonatomic, copy) NSString *plor_pay_number;
/** 物流发货地*/
@property (nonatomic, copy) NSString *plor_send_address;
/** 物流订单发货日期*/
@property (nonatomic, copy) NSString *plor_send_date;
/** 物流收货地址*/
@property (nonatomic, copy) NSString *plor_take_address;
/** 物流订单价格*/
@property (nonatomic, strong) NSNumber *plor_total;
/** 物流订单重量*/
@property (nonatomic, strong) NSNumber *plor_weight;


@property (nonatomic, copy) NSString *rightBtnTitle;

@property (nonatomic, assign) StatusType type;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


/** 是否隐藏左边的button */
@property (nonatomic, assign, getter=isHiddenLeftBtn) BOOL hiddenLeftBtn;
/** 是否隐藏下边两个的button */
@property (nonatomic, assign, getter=isHiddenBottomBtn) BOOL hiddenBottomBtn;

//+ (instancetype)messageWithDict:(NSDictionary *)dict;
@end
