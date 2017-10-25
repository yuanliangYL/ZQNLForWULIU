//
//  YLJiDanDetailModel.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/9/2.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLJiDanDetailModel : NSObject
/** 打包站地址*/
@property (nonatomic, copy) NSString *pk_address;
/** 打包站信用分*/
@property (nonatomic, copy) NSString *pk_credit_score;
/** 打包站头像*/
@property (nonatomic, copy) NSString *pk_headurl;
/** 打包站手机号*/
@property (nonatomic, copy) NSString *pk_phone;
/** 打包站真实姓名*/
@property (nonatomic, copy) NSString *pk_real_name;
/** ld_auth_state
 司机认证状态（只有等于1才能联系打包站和接单）
*/
@property (nonatomic, strong) NSNumber *pk_state;
/** 打包站昵称*/
@property (nonatomic, copy) NSString *pk_username;
/*
 {
 "auth_state" = 1;
 data =     {
 "pk_address" = "\U5b89\U5fbd\U5408\U80a5";
 "pk_credit_score" = "8.0";
 "pk_headurl" = 123123123;
 "pk_phone" = 15555221122;
 "pk_real_name" = "\U76ae\U76ae\U9f99";
 "pk_state" = 1;
 "pk_username" = "\U76ae\U76ae\U9f99\U7684\U6253\U5305\U7ad9";
 };
 msg = "\U83b7\U53d6\U6210\U529f!";
 "status_code" = 10000;
 }
 */

@end
