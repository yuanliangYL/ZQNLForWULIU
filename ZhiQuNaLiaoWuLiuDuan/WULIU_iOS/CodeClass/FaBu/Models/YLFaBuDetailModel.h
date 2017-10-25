//
//  YLFaBuDetailModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/24.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLFaBuDetailModel : NSObject

@property(nonatomic,strong)NSString * startP;
@property(nonatomic,strong)NSString * stopP;
@property(nonatomic,strong)NSString * zhonglaing;
@property(nonatomic,strong)NSString * riqi;

+(NSMutableArray *)getDefaultDataArray;

@end
