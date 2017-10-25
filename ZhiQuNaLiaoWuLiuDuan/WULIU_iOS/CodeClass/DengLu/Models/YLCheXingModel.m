//
//  YLCheXingModel.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLCheXingModel.h"

@implementation YLCheXingModel


+(NSMutableArray *)getDefaultDataArray{
    
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *imageA = @[@"car_bangua",@"car_gaolanshi",@"car_jizhuangxiang",@"car_lanbanshi",@"car_pingbanshi",@"car_qianyin",@"car_quangua",@"car_xiangshi",@"car_bangua",@"car_gaolanshi",@"car_jizhuangxiang"];
    
    NSArray *nameA = @[@"半挂车",@"高栏式货车",@"集装箱车",@"栏板式货车",@"平板式货车",@"牵引车",@"全挂车",@"厢式货车",@"半挂车",@"高栏式货车",@"集装箱车"];
    
    for (NSInteger i=0; i<imageA.count; i++){
        
        YLCheXingModel *model = [[YLCheXingModel alloc] init];
        
        model.imageName = imageA[i];
        
        model.name = nameA[i];
        
        model.isDefault = NO;
    
        [modelArray addObject:model];
    }
    
    return modelArray;
}

@end
