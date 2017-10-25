//
//  YLShenQingModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/2.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLShenQingModel : NSObject
/** */
@property (nonatomic, strong) NSString *capacity;
/** */
@property (nonatomic, strong) NSString *end_area;
/** */
@property (nonatomic, strong) NSString *logistics_require_id;
/** */
@property (nonatomic, strong) NSString *order_id;
/** */
@property (nonatomic, strong) NSString *order_type;
/** */
@property (nonatomic, strong) NSString *pack_id;
/** */
@property (nonatomic, strong) NSString *pack_phone;
/** */
@property (nonatomic, strong) NSString *pack_real_name;
/** */
@property (nonatomic, strong) NSString *plg_apply_state;
/** */
@property (nonatomic, strong) NSString *plg_estimate_depart_date;
/** */
@property (nonatomic, strong) NSString *plg_id;
/** */
@property (nonatomic, strong) NSString *plg_offer_price;
/** */
@property (nonatomic, strong) NSString *start_area;


//我的申请
/** */
@property (nonatomic, strong) NSString *depart_time;
/** */
@property (nonatomic, strong) NSString *dla_apply_state;
/** */
@property (nonatomic, strong) NSString *dla_id;
/** */
@property (nonatomic, strong) NSString *dla_offer_price;

@end
