//
//  YLCheXingModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLCheXingModel : NSObject
@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)BOOL isDefault;


+(NSMutableArray *)getDefaultDataArray;

@end
