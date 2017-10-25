//
//  FaBuModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/21.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaBuModel : NSObject
@property(nonatomic,strong)NSString * qujian;
@property(nonatomic,strong)NSString * riqi;
@property(nonatomic,strong)NSString * zhonglaing;
//以接单
@property(nonatomic,assign)BOOL hadBeenReceive;

+(NSMutableArray *)getDefaultDataArray;

#warning 少一个已接单的字段
/** 承载重量*/
@property (nonatomic, strong) NSNumber *ldr_capacity;
/** 出发日期，详情从列表传进去*/
@property (nonatomic, copy) NSString *ldr_can_tack_date;
/** 物流需求id*/
@property (nonatomic, strong) NSNumber *ldr_id;
/** 出发地*/
@property (nonatomic, copy) NSString *depart_address;
/** 目的地*/
@property (nonatomic, copy) NSString *dest_address;


@end
