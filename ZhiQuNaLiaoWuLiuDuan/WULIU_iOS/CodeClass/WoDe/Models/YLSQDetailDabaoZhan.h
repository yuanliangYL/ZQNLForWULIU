//
//  YLSQDetailDabaoZhan.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLSQDetailDabaoZhan : NSObject

//打包站申请
@property(nonatomic,strong)NSString *logistics_require_id;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *order_type;
@property(nonatomic,strong)NSString *pack_id;
@property(nonatomic,strong)NSString *plg_apply_state;
@property(nonatomic,strong)NSString *plg_estimate_depart_date;
@property(nonatomic,strong)NSString *plg_offer_price;
@property(nonatomic,strong)NSString *end_area;
@property(nonatomic,strong)NSString *start_area;
@property(nonatomic,strong)NSString *capacity;

@end


//capacity = "50.0";
//"end_area" = "\U4eba\U6c11\U8def";
//"logistics_require_id" = 26;
//"order_id" = 3;
//"order_type" = 1;
//"pack_id" = 1;
//"plg_apply_state" = 1;
//"plg_estimate_depart_date" = 1506096000;
//"plg_offer_price" = "123.00";
//"start_area" = "\U65b0\U5730\U4e2d\U5fc3";

