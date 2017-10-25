//
//  YLRenZhengList.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/25.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

//认证状态
@interface YLRenZhengList : NSObject
@property(nonatomic,strong)NSString *authentication_status;
@end

//驾驶证
@interface YLJiaShiZhengList : NSObject
@property(nonatomic,strong)NSString *ld_idcard_back_photo;
@property(nonatomic,strong)NSString *ld_idcard_front_photo;
@property(nonatomic,strong)NSString *ld_licence_first_get_date;
@property(nonatomic,strong)NSString *ld_licence_number;
@property(nonatomic,strong)NSString *ld_licence_photo;
@property(nonatomic,strong)NSString *ld_realname;
@property(nonatomic,strong)NSString *type;
@end

//行驶证
@interface YLXingShiZhengList : NSObject
@property(nonatomic,strong)NSString *ld_capacity;
@property(nonatomic,strong)NSString *ld_car_type;
@property(nonatomic,strong)NSString *ld_licence_plate;
@property(nonatomic,strong)NSString *ld_owner;
@property(nonatomic,strong)NSString *ld_permit_photo;
@property(nonatomic,strong)NSString *ld_permit_register_date;
@property(nonatomic,strong)NSString *type;
@end

//保险
@interface YLBaoXianZhengList : NSObject
@property(nonatomic,strong)NSString *ld_insuer;
@property(nonatomic,strong)NSString *ld_policy_coverage;
@property(nonatomic,strong)NSString *ld_policy_end_date;
@property(nonatomic,strong)NSString *ld_policy_number;
@property(nonatomic,strong)NSString *ld_policy_photo;
@property(nonatomic,strong)NSString *ld_policy_start_date;
@property(nonatomic,strong)NSString *type;
@end


//0 =         {
//    "ld_idcard_back_photo" = "<null>";
//    "ld_idcard_front_photo" = "<null>";
//    "ld_licence_first_get_date" = "<null>";
//    "ld_licence_number" = "<null>";
//    "ld_licence_photo" = "<null>";
//    "ld_realname" = "<null>";
//    type = 1;
//};
//1 =         {
//    "ld_capacity" = "<null>";
//    "ld_car_type" = "<null>";
//    "ld_licence_plate" = "<null>";
//    "ld_owner" = "<null>";
//    "ld_permit_photo" = "<null>";
//    "ld_permit_register_date" = "<null>";
//    type = 2;
//};
//2 =         {
//    "ld_insuer" = "<null>";
//    "ld_policy_coverage" = "<null>";
//    "ld_policy_end_date" = "<null>";
//    "ld_policy_number" = "<null>";
//    "ld_policy_photo" = "<null>";
//    "ld_policy_start_date" = "<null>";
//    type = 3;
//};
//"authentication_status" = 2;
//"refuse_reason" = "<null>";
