//
//  YLDingDanDetailModel.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/9/1.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDingDanDetailModel.h"

@implementation YLDingDanDetailModel
/** 属性为数组 对应相应的解析类 */
+ (NSDictionary *)mj_objectClassInArray{
    return  @{
              @"detail_of_orders" : [Detail_of_orders class],
              @"pack_info" :[Pack_info class],
              
              };
}

@end

@implementation Detail_of_orders

@end

@implementation Pack_info


@end
