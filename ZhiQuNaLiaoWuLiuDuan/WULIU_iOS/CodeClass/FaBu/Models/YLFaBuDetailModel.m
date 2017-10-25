//
//  YLFaBuDetailModel.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/24.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLFaBuDetailModel.h"

@implementation YLFaBuDetailModel

+(NSMutableArray *)getDefaultDataArray{
    
    YLFaBuDetailModel * m = [YLFaBuDetailModel new];
    m.startP = @"上海市浦东兴趣123是31289房";
    m.stopP = @"上海市浦东合肥经济开发区是宗欣内僧啊中国南亚功能的个";
    m.zhonglaing = @"10吨";
    m.riqi = @"2017.22.11  12：12-18:00";
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects: m.startP, m.stopP,m.zhonglaing,m.riqi,nil];
    
    return arr;
}


@end
