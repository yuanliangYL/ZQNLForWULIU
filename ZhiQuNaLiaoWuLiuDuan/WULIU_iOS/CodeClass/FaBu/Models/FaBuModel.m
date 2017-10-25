//
//  FaBuModel.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/21.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "FaBuModel.h"

@implementation FaBuModel

+(NSMutableArray *)getDefaultDataArray{
    
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *qujianA = @[@"car_bangua",@"car_gaolanshi",@"car_jizhuangxiang",@"car_lanbanshi",@"car_pingbanshi",@"car_qianyin",@"car_quanguacar_quanguacar_quanguacar_quangua",@"car_xiangshi",@"car_bangua",@"car_gaolanshi",@"car_jizhuangxiang"];
    
    NSArray *riqiA = @[@"半挂车",@"高栏式货车car_quanguacar_quangua",@"集装箱车",@"栏板式货车",@"平板式货车",@"牵引车",@"全挂车",@"厢式货车",@"半挂车",@"高栏式货车",@"集装箱车"];
    
     NSArray *zhonglaingA = @[@"432",@"423",@"4234",@"5435",@"534",@"534",@"534",@"654",@"654",@"645",@"645"];
    
    for (NSInteger i=0; i<qujianA.count; i++){
        
        FaBuModel *model = [[FaBuModel alloc] init];
        
        model.qujian = qujianA[i];
        
        model.riqi = riqiA[i];
        
        model.zhonglaing = zhonglaingA[i];
        
        if (i == 1 || 5 == i) {
            
            model.hadBeenReceive = YES;
            
        }else{
            model.hadBeenReceive = NO;
        }
        
        
        
        [modelArray addObject:model];
    }
    
    return modelArray;
}



@end
